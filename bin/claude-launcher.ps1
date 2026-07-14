# claude-launcher.ps1 -- named-account wrapper for `claude` (Claude Code).
# Windows PowerShell 5.1 port of bin/claude-launcher. Deltas from the bash
# original:
#   * `cc hi` / `hi-cleanup-hook` dropped (depend on tmux + SIGINT).
#   * Env files are PowerShell scripts: env.ps1 instead of env (dot-sourced).
#   * Account linking uses NTFS symlinks -- requires Windows Developer Mode
#     (Settings > System > For developers) or an elevated shell.
#   * No installer: expose as `cc` via $PROFILE:
#       function cc { & "$env:USERPROFILE\.local\bin\claude-launcher.ps1" @args }
#   * Keep this file ASCII-only: PS 5.1 reads BOM-less files as ANSI.
#
# -- CONTRACT ---------------------------------------------------------------
#
# Claude Code reads ONE env var: $env:CLAUDE_CONFIG_DIR. Everything else
# below is invented by this wrapper and is invisible to claude itself.
#
# Wrapper-owned env vars
#   CC_ACCOUNT         The account *name*. In wrapper-managed mode the
#                      wrapper sets it from the resolved account and the
#                      name drives where CLAUDE_CONFIG_DIR points. In
#                      raw passthrough it becomes a display-only label
#                      (like a venv name) -- read by other wrapper tools,
#                      never by claude.
#   CLAUDE_CONFIG_DIR  Shared with claude. The wrapper sets it from the
#                      resolved account directory, or clears it to mean
#                      "use native ~/.claude". When pre-set by the
#                      caller it's treated as a *location* ("store my
#                      claude config here") and the wrapper honors it.
#
# Reserved name
#   default            Virtual account meaning "native ~/.claude -- do
#                      not switch". Valid for `cc -a default` and `cc
#                      use default`; rejected by `cc setup default`.
#
# Account resolution (highest precedence first; more-specific overrides
# less-specific, args beat env)
#   1. `-a <name>` flag                       (this-invocation explicit)
#   2. pre-set $env:CLAUDE_CONFIG_DIR         (caller's explicit env;
#                                              what claude actually reads)
#   3. inherited $env:CC_ACCOUNT              (wrapper metadata)
#   4. ~/.claude-accounts/.default            (persistent default)
#   5. virtual `default` (native)             (fallback)
#
# Operating modes (consequence of resolution, not separate decisions)
#   Wrapper-managed   ACCOUNT resolves to a named account dir under
#                     $ACCOUNTS_DIR. Wrapper sets $env:CC_ACCOUNT, points
#                     $env:CLAUDE_CONFIG_DIR at the account dir, sources
#                     both env files.
#   Virtual default   ACCOUNT resolves to native (`-a default`, or no
#                     signal at all). $env:CLAUDE_CONFIG_DIR unset,
#                     $env:CC_ACCOUNT="default", only global env sourced.
#   Raw passthrough   $env:CLAUDE_CONFIG_DIR was pre-set by the caller.
#                     Dir kept as-is, inherited $env:CC_ACCOUNT left
#                     untouched as a display-only label. Only global env
#                     sourced -- per-account env is the caller's
#                     responsibility now. `cc usage` still works against
#                     the chosen dir.
#
# Env config (dot-sourced before launch; PowerShell syntax, e.g.
# `$env:FOO = 'bar'`)
#   ~/.claude-accounts/env.ps1           global; sourced in all modes
#   ~/.claude-accounts/<name>/env.ps1    per-account; overrides global;
#                                        sourced only in wrapper-managed
#                                        mode
#
#   Env files can only INTRODUCE new vars -- they cannot override vars
#   the caller already set (inherited from the parent shell, or set by
#   an earlier env file). Precedence high to low:
#   caller env > per-account env > global env.
#
# ---------------------------------------------------------------------------

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
# PS 5.1 does not enable TLS 1.2 by default; TLS 1.3 enum needs .NET 4.8+.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try {
  [Net.ServicePointManager]::SecurityProtocol =
    [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls13
} catch {}

# Shared config source linked into each account dir by `cc setup`.
# Edit this if your shared claude config lives elsewhere.
$CLAUDE_BASE = Join-Path $env:USERPROFILE '.claude'
$ACCOUNTS_DIR = Join-Path $env:USERPROFILE '.claude-accounts'
$DEFAULT_FILE = Join-Path $ACCOUNTS_DIR '.default'

$script:Account = ''

# The `cc` profile function runs this script in-process (`&`), so unlike the
# bash launcher (separate process), $env: mutations would outlive the call
# and poison the caller's shell -- e.g. a leftover CLAUDE_CONFIG_DIR turns
# the next bare `cc` into raw passthrough. Snapshot here, restore in the
# dispatch finally (runs even on `exit`); `& claude` children inherit the
# env at spawn time, so restoring afterward never affects them.
$script:CallerEnv = @{}
foreach ($entry in Get-ChildItem Env:) {
  $script:CallerEnv[$entry.Name] = $entry.Value
}

function Restore-CallerEnv {
  foreach ($entry in Get-ChildItem Env:) {
    if (-not $script:CallerEnv.ContainsKey($entry.Name)) {
      Remove-Item -Path "Env:$($entry.Name)" -ErrorAction SilentlyContinue
    }
  }
  foreach ($name in $script:CallerEnv.Keys) {
    Set-Item -Path "Env:$name" -Value $script:CallerEnv[$name] -ErrorAction SilentlyContinue
  }
}

function Die([string]$msg) {
  [Console]::Error.WriteLine("claude-launcher: $msg")
  exit 1
}

function Read-DefaultFile {
  if (-not (Test-Path -LiteralPath $DEFAULT_FILE -PathType Leaf)) { return '' }
  $content = Get-Content -LiteralPath $DEFAULT_FILE -Raw -ErrorAction SilentlyContinue
  if ($content) { return $content.Trim() }
  return ''
}

function New-AccountLinks([string]$dir) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
  if (-not (Test-Path -LiteralPath $CLAUDE_BASE -PathType Container)) { return }
  foreach ($item in Get-ChildItem -LiteralPath $CLAUDE_BASE -Force) {
    if ($item.Name -eq '.credentials.json') { continue }
    $linkPath = Join-Path $dir $item.Name
    # Get-Item -Force also sees broken symlinks (Test-Path does not).
    if (Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue) { continue }
    try {
      New-Item -ItemType SymbolicLink -Path $linkPath -Target $item.FullName | Out-Null
    } catch {
      Die ("Cannot create symlink '$linkPath' -- enable Windows Developer Mode " +
        "(Settings > System > For developers) or run elevated. ($($_.Exception.Message))")
    }
  }
}

function Import-EnvFile([string]$path, [hashtable]$snapshot) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return }
  # $snapshot maps env var name -> caller value. After dot-sourcing we
  # re-apply it so the file can ADD new vars but cannot override
  # caller-set vars (or launcher-managed vars in raw passthrough).
  . $path
  foreach ($name in $snapshot.Keys) {
    Set-Item -Path "Env:$name" -Value $snapshot[$name]
  }
}

function Resolve-Account {
  $explicitA = [bool]$script:Account
  # Snapshot caller env for env-file protection (see CONTRACT). Exclude the
  # launcher-managed vars -- those are owned by resolution logic, not env
  # files. Raw passthrough re-adds CLAUDE_CONFIG_DIR below.
  $snapshot = @{}
  foreach ($entry in Get-ChildItem Env:) {
    if ($entry.Name -in @('CC_ACCOUNT', 'CLAUDE_CONFIG_DIR')) { continue }
    $snapshot[$entry.Name] = $entry.Value
  }

  if (-not $script:Account) {
    if ($env:CLAUDE_CONFIG_DIR) {
      # Caller set CLAUDE_CONFIG_DIR -- that's where their config lives.
      # Raw passthrough: don't derive ACCOUNT, don't touch CC_ACCOUNT
      # (it's a display label, like a venv name). Load only the global env.
      $snapshot['CLAUDE_CONFIG_DIR'] = $env:CLAUDE_CONFIG_DIR
      Import-EnvFile (Join-Path $ACCOUNTS_DIR 'env.ps1') $snapshot
      return
    } elseif ($env:CC_ACCOUNT) {
      $script:Account = $env:CC_ACCOUNT
    } else {
      $script:Account = Read-DefaultFile
    }
  }
  if ($script:Account -eq 'default') {
    $script:Account = ''
    # Explicit `-a default` deactivates even an inherited CLAUDE_CONFIG_DIR.
    if ($explicitA) { Remove-Item Env:CLAUDE_CONFIG_DIR -ErrorAction SilentlyContinue }
  }
  if ($script:Account) {
    $dir = Join-Path $ACCOUNTS_DIR $script:Account
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
      Die "Unknown account: $($script:Account) (run: cc setup $($script:Account))"
    }
    $env:CLAUDE_CONFIG_DIR = $dir
  }
  Import-EnvFile (Join-Path $ACCOUNTS_DIR 'env.ps1') $snapshot
  if ($script:Account) {
    Import-EnvFile (Join-Path (Join-Path $ACCOUNTS_DIR $script:Account) 'env.ps1') $snapshot
  }
}

function Get-OAuthToken([string]$configDir) {
  $creds = Join-Path $configDir '.credentials.json'
  if (-not (Test-Path -LiteralPath $creds -PathType Leaf)) { return '' }
  try {
    $token = (Get-Content -LiteralPath $creds -Raw | ConvertFrom-Json).claudeAiOauth.accessToken
    if ($token) { return $token }
  } catch {}
  return ''
}

function Show-Usage([string]$configDir, [string]$accountLabel, [bool]$rawJson) {
  $token = Get-OAuthToken $configDir
  if (-not $token) { Die "No OAuth token found for account: $accountLabel" }

  $body = ''
  try {
    $resp = Invoke-WebRequest -UseBasicParsing -TimeoutSec 10 `
      -Uri 'https://api.anthropic.com/api/oauth/usage' `
      -Headers @{ Authorization = "Bearer $token" }
    $body = $resp.Content
  } catch {
    $response = $null
    if ($_.Exception -is [Net.WebException]) { $response = $_.Exception.Response }
    if (-not $response) { Die 'API request failed (network error)' }
    $http = [int]$response.StatusCode
    switch ($http) {
      401 { Die "API returned 401 for '$accountLabel' -- token expired; run: cc setup $accountLabel" }
      429 { Die "API returned 429 for '$accountLabel' -- rate limited, try again later" }
      default {
        $errBody = ''
        try {
          $reader = New-Object IO.StreamReader($response.GetResponseStream())
          $errBody = $reader.ReadToEnd()
        } catch {}
        Die "API returned HTTP $http for '${accountLabel}': $errBody"
      }
    }
  }

  if ($rawJson) {
    # Emit the upstream body unmodified -- statusline consumers parse the
    # raw API JSON; do not deserialize/re-serialize.
    Write-Output $body
    return
  }
  try {
    $data = $body | ConvertFrom-Json
    $fiveUtil = $data.five_hour.utilization
    $fiveReset = $data.five_hour.resets_at
    $sevenUtil = $data.seven_day.utilization
    $sevenReset = $data.seven_day.resets_at
  } catch {
    Die "Unexpected API response: $body"
  }
  Write-Output "Account  : $accountLabel"
  Write-Output ("5h limit : {0}% used  (resets {1})" -f $fiveUtil, $fiveReset)
  Write-Output ("7d limit : {0}% used  (resets {1})" -f $sevenUtil, $sevenReset)
}

function Cmd-Help {
  Write-Output @"
Usage: claude-launcher.ps1 [GLOBAL OPTIONS] [COMMAND] [ARGS]

Commands:
  setup <name>        create account dir + launch to authenticate
  use <name>          set default account
  list                list accounts with credential status
  usage [--json]      show quota usage for current/specified account
  -h, --help, help    show this help

Global options (before subcommand):
  -a, --account <name>  use specific account. Resolution order when omitted:
                        inherited `$env:CC_ACCOUNT > ~/.claude-accounts/.default > 'default'

Reserved account name:
  default               virtual -- do NOT switch; use native ~/.claude

Launch options (when no subcommand):
  --yolo                --dangerously-skip-permissions
  --                    end of launcher options; remaining args go to claude
                        (note: PowerShell may consume a bare --; quote it as
                        '--' when invoking through the cc function)

Env config (optional, dot-sourced before launch; PowerShell syntax):
  ~/.claude-accounts/env.ps1          global env vars for all accounts
  ~/.claude-accounts/<name>/env.ps1   per-account env vars (takes precedence)

Notes:
  * `cc setup` creates NTFS symlinks -- requires Windows Developer Mode
    (Settings > System > For developers) or an elevated shell.
  * No `cc hi` on Windows (needs tmux + SIGINT; Linux/WSL only).

Examples:
  cc setup work           # create 'work' account, authenticate
  cc use work             # set 'work' as default
  cc use default          # pin native ~/.claude as default
  cc                      # launch with resolved account
  cc -a personal          # launch with 'personal' account
  cc -a default           # launch with native ~/.claude (no switching)
  cc --yolo               # launch without permission prompts
  cc '--' -h              # show claude's own help
  `$env:DEBUG = 1; cc      # env vars set in shell (merged with env.ps1 files)
  cc usage                # quota usage for resolved account
  cc usage --json         # raw JSON from the quota API
  cc -a work usage        # quota usage for 'work' account
"@
}

function Cmd-Setup([string]$name) {
  if (-not $name) { Die 'Usage: cc setup <name>' }
  if ($name -eq 'default') {
    Die "'default' is reserved (means native ~/.claude); pick a different name"
  }
  $dir = Join-Path $ACCOUNTS_DIR $name
  New-AccountLinks $dir
  Write-Output "Launching claude for '$name' -- log in to save credentials..."
  $env:CLAUDE_CONFIG_DIR = $dir
  & claude
  exit $LASTEXITCODE
}

function Cmd-Use([string]$name) {
  if (-not $name) { Die 'Usage: cc use <name>' }
  if ($name -ne 'default') {
    if (-not (Test-Path -LiteralPath (Join-Path $ACCOUNTS_DIR $name) -PathType Container)) {
      Die "Unknown account: $name"
    }
  }
  New-Item -ItemType Directory -Path $ACCOUNTS_DIR -Force | Out-Null
  Set-Content -LiteralPath $DEFAULT_FILE -Value $name
  Write-Output "Default: $name"
}

function Cmd-List {
  $default = Read-DefaultFile
  if (-not $default) { $default = 'default' }
  $marker = if ($default -eq 'default') { '* ' } else { '  ' }
  Write-Output "${marker}default  [native ~/.claude]"
  if (-not (Test-Path -LiteralPath $ACCOUNTS_DIR -PathType Container)) { return }
  foreach ($dir in Get-ChildItem -LiteralPath $ACCOUNTS_DIR -Directory) {
    $name = $dir.Name
    $marker = if ($name -eq $default) { '* ' } else { '  ' }
    $creds = Join-Path $dir.FullName '.credentials.json'
    if (Test-Path -LiteralPath $creds -PathType Leaf) {
      $tier = '?'
      try {
        $value = (Get-Content -LiteralPath $creds -Raw | ConvertFrom-Json).claudeAiOauth.rateLimitTier
        if ($value) { $tier = $value }
      } catch {}
    } else {
      $tier = 'no credentials'
    }
    Write-Output "${marker}${name}  [$tier]"
  }
}

function Cmd-Usage([string[]]$rest) {
  if ($null -eq $rest) { $rest = @() }
  $rawJson = $false
  if ($rest.Count -gt 0) {
    switch ($rest[0]) {
      '--json' { $rawJson = $true }
      default { Die 'Usage: cc usage [--json]' }
    }
  }
  Resolve-Account
  $configDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR }
               else { Join-Path $env:USERPROFILE '.claude' }
  # Display label: resolved ACCOUNT if set, else inherited CC_ACCOUNT (raw
  # passthrough display label), else "default".
  $label = if ($script:Account) { $script:Account }
           elseif ($env:CC_ACCOUNT) { $env:CC_ACCOUNT }
           else { 'default' }
  Show-Usage $configDir $label $rawJson
}

function Cmd-Launch([string[]]$rest) {
  if ($null -eq $rest) { $rest = @() }
  $claudeArgs = New-Object Collections.Generic.List[string]
  $i = 0
  while ($i -lt $rest.Count) {
    switch ($rest[$i]) {
      '--yolo' { $claudeArgs.Add('--dangerously-skip-permissions'); $i++ }
      '--' {
        $i++
        while ($i -lt $rest.Count) { $claudeArgs.Add($rest[$i]); $i++ }
      }
      default { $claudeArgs.Add($rest[$i]); $i++ }
    }
  }
  Resolve-Account
  # Set CC_ACCOUNT to the resolved account name. Raw passthrough
  # (CLAUDE_CONFIG_DIR set, ACCOUNT empty) leaves any inherited CC_ACCOUNT
  # alone -- in that mode it's a display-only label (like a venv name).
  if ($script:Account) {
    $env:CC_ACCOUNT = $script:Account
  } elseif (-not $env:CLAUDE_CONFIG_DIR) {
    $env:CC_ACCOUNT = 'default'
  }
  & claude @claudeArgs
  exit $LASTEXITCODE
}

# ---- main: phase 1 (global opts) -> phase 2 (dispatch) ----

$argv = @($args)
while ($argv.Count -gt 0 -and ($argv[0] -eq '-a' -or $argv[0] -eq '--account')) {
  if ($argv.Count -lt 2) { Die "Missing value for $($argv[0])" }
  $script:Account = $argv[1]
  $argv = @($argv | Select-Object -Skip 2)
}

$cmd = if ($argv.Count -gt 0) { $argv[0] } else { '' }
$rest = @($argv | Select-Object -Skip 1)

try {
  switch ($cmd) {
    { $_ -in '-h', '--help', 'help' } { Cmd-Help; break }
    'setup' { Cmd-Setup $(if ($rest.Count -gt 0) { $rest[0] } else { '' }); break }
    'use'   { Cmd-Use   $(if ($rest.Count -gt 0) { $rest[0] } else { '' }); break }
    'list'  { Cmd-List; break }
    'usage' { Cmd-Usage $rest; break }
    default { Cmd-Launch $argv; break }
  }
} finally {
  Restore-CallerEnv
}
