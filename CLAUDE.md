# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for a single user (Inndy). Not an open-source project — there is no test suite, no CI, no build step. Changes are validated by the user re-running `scripts/install.sh` or sourcing the affected file.

## Installation

```
scripts/install.sh                  # install everything
scripts/install.sh -B               # skip bashrc
scripts/install.sh -V               # skip vim/nvim
scripts/install.sh -T               # skip tmux
scripts/install.sh -G               # skip gitconfig
```

`install.sh` is idempotent and uses `ln -s` from `$DOTFILES/<file>` to `~/.<file>`. It refuses to overwrite existing files — if `~/.foo` already exists (not a symlink to here), it prints a warning and skips. To re-link, the user must delete the existing target first.

`scripts/install-shared.sh` is a stripped-down installer for shared/multi-user machines; it only links `inputrc` and tmux config under a non-conflicting name (`~/.inndy.tmux.conf`).

## Architecture

### `bashrc` + `bash/` (sourced shell modules)

`bashrc` sources every file in `bash/*` in sort order, then `~/.bashrc.local` if present. Files are named `NN-name.sh` where `NN` orders sourcing (00 = earliest, 60 = latest). When adding a new bash module, pick the prefix that matches its dependencies — e.g. anything that needs `$EDITOR` must run after `00-auto-choose-vi-editor.sh`.

`~/.bashenv` is created by `install.sh` to export `$DOTFILES` and is sourced from the top of `bashrc` (via `BASHENV_INIT` guard) so the variable is available before any module runs.

### `bin/claude-launcher` (aliased as `cc`)

This is the most non-obvious component. It's a multi-account wrapper for the `claude` CLI:

- Account dirs live under `~/.claude-accounts/<name>/`.
- `cc setup <name>` creates the dir and **symlinks every file from `claude/` into it** *except* `.credentials.json` — so config/commands/statusline are shared across accounts, but each account has its own OAuth credentials.
- `cc use <name>` writes the default account into `~/.claude-accounts/.default`.
- `cc -a <name>` overrides the default for one invocation.
- `cc usage [--json]` fetches the OAuth quota API (token from `.credentials.json` or macOS Keychain). Pure fetch+display — no file side effects. The statusline owns the cache file separately.

**Read the contract docblock at the top of the script before changing resolution logic.** It defines: claude itself only reads `$CLAUDE_CONFIG_DIR`; `$CC_ACCOUNT` and the rest are wrapper-internal; the reserved virtual `default` name; the resolution precedence (`-a` > inherited `CC_ACCOUNT` > `.default` file > virtual `default`); the two operating modes (wrapper-managed vs raw passthrough when caller pre-sets `CLAUDE_CONFIG_DIR`); and the `cc -a default` deactivation rule. The docblock is the source of truth — don't duplicate it here.

When editing the launcher, preserve the **two-phase argument parser**: phase 1 consumes global options (`-a/--account`) before the subcommand, phase 2 dispatches to `cmd_*` functions. Anything after `--` is passed through to `claude` verbatim.

The shell alias (not symlink) `alias cc="$DOTFILES/bin/claude-launcher"` is appended to `~/.bashrc.local` deliberately — making it an alias means non-interactive scripts still get the system `cc` (the C compiler).

### `claude/` (Claude Code config, source-of-truth)

The contents of this directory are the source for `~/.claude-accounts/<name>/` via the symlinking described above. `.gitignore` here is restrictive (`*` with exceptions for `.gitignore`, `CLAUDE.md`, `commands`) — only those files are version-controlled; everything else (sessions, history, credentials, plans, caches) stays local.

- `claude/CLAUDE.md` is the user's **global** Claude instructions (loaded for every project, regardless of CWD). Edit with care — it affects every session.
- `claude/commands/` are user-level slash commands (currently `git-commit` and `vibe`).
- `claude/statusline-command.sh` is the Claude Code statusline. It owns its quota cache at `$CLAUDE_CONFIG_DIR/cc-usage-cache.json` (5-min TTL + 1-min lockfile) and delegates the API fetch to `cc usage --json`. The `cc-` prefix is deliberate so the file is recognizable as wrapper-owned, not part of claude itself.

### `nvim/` and `vim/`

`nvim/init.lua` bootstraps `lazy.nvim` from a config-local lockfile (`nvim/lazy-lock.json`). `install.sh` symlinks the whole `nvim/` dir to `~/.config/nvim` — it will replace an existing symlink that points elsewhere, but refuses to touch a real directory.

`vim/` and `vimrc` are the legacy vim-plug setup; they coexist with the nvim config.

### `tmux.conf`

Prefix is **`C-g`** (not the default `C-b`). When testing tmux changes, reload with `prefix R`.

## Conventions

- The `claude/CLAUDE.md` global instructions already enforce: no decorative comments, no auto-agreeing with user corrections, and a pre-commit check for whether `README.md`/`CLAUDE.md` need updates. Those rules apply here too.
- The `git-commit` slash command (in `claude/commands/`) describes the user's commit-splitting preferences — follow it when asked to commit.
- Commit subject style in this repo: when changes are scoped to a subsystem, prefix with `[scope]` (e.g. `[claude] Restructure cc arg parser around subcommand dispatch`). Match the surrounding history.
