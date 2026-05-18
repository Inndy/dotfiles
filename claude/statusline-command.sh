#!/usr/bin/env bash

# To install this statusline in your claude code,
# merge following config into your ~/.claude/settings.json
# {
#   "statusLine": {
#     "type": "command",
#     "command": "bash /home/inndy/.claude/statusline-command.sh"
#   }
# }

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

env > /tmp/cc-env.txt

reset="\e[00m"
fg_yellow="\e[33m"
fg_lightblue="\e[94m"
fg_green="\e[38;5;82m"
fg_orange="\e[38;5;208m"
fg_magenta="\e[38;5;177m"
fg_cyan="\e[38;5;81m"
fg_red="\e[38;5;196m"

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
# `cc-` prefix flags these as wrapper-owned, not part of claude itself.
USAGE_CACHE="$CLAUDE_DIR/cc-usage-cache.json"
USAGE_LOCK="$CLAUDE_DIR/cc-usage-cache.lock"

get_claude_usage() {
    local is_stale=0
    [ ! -f "$USAGE_CACHE" ] && is_stale=1
    [ "$is_stale" = "0" ] && [ -n "$(find "$USAGE_CACHE" -mmin +5 2>/dev/null)" ] && is_stale=1

    if [ "$is_stale" = "1" ]; then
        local lock_held=0
        [ -f "$USAGE_LOCK" ] && [ -z "$(find "$USAGE_LOCK" -mmin +1 2>/dev/null)" ] && lock_held=1
        if [ "$lock_held" = "0" ]; then
            touch "$USAGE_LOCK"
            (
                # cc handles auth + API; statusline owns the cache.
                # `usage --json` honors inherited CC_ACCOUNT / CLAUDE_CONFIG_DIR
                # per the launcher contract — works in all three modes.
                # Prefer PATH (for users who installed claude-launcher into their
                # own bin/); fall back to the dotfiles install location.
                LAUNCHER=$(command -v claude-launcher 2>/dev/null \
                    || echo "${DOTFILES:-$HOME/.dotfiles}/bin/claude-launcher")
                RESULT=$("$LAUNCHER" usage --json 2>/dev/null)
                if echo "$RESULT" | jq -e '.five_hour' >/dev/null 2>&1; then
                    echo "$RESULT" > "$USAGE_CACHE"
                fi
                rm -f "$USAGE_LOCK"
            ) &>/dev/null &
            disown
        fi
    fi

    [ ! -f "$USAGE_CACHE" ] && return

    local five_h seven_d color
    five_h=$(jq -r '(.five_hour.utilization // empty) | if type == "number" then floor else empty end' "$USAGE_CACHE" 2>/dev/null)
    seven_d=$(jq -r '(.seven_day.utilization // empty) | if type == "number" then floor else empty end' "$USAGE_CACHE" 2>/dev/null)
    [ -z "$five_h" ] || [ -z "$seven_d" ] && return

    local max_util
    max_util=$(( five_h > seven_d ? five_h : seven_d ))
    if   [ "$max_util" -ge 90 ]; then color="$fg_red"
    elif [ "$max_util" -ge 75 ]; then color="$fg_orange"
    elif [ "$max_util" -ge 50 ]; then color="$fg_yellow"
    else color="$fg_cyan"
    fi

    printf "%b[5h:%d%% 7d:%d%%]%b" "$color" "$five_h" "$seven_d" "$reset"
}

time_part="${fg_yellow}[$(date '+%H:%M')]${reset}"
host_part="${fg_green}$(hostname -s)${reset}"

display_cwd="${cwd/#"$HOME"/\~}"
cwd_part="${fg_lightblue}${display_cwd}${reset}"

git_part=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -z "$(git -C "$cwd" status --short 2>/dev/null)" ]; then
            git_part=" ${fg_green}(${branch})${reset}"
        else
            git_part=" ${fg_orange}(${branch}*)${reset}"
        fi
    fi
fi

account_part=""
[ -n "$CC_ACCOUNT" ] && account_part=" ${fg_magenta}«${CC_ACCOUNT}»${reset}"

usage_part=""
usage_text=$(get_claude_usage)
[ -n "$usage_text" ] && usage_part=" $usage_text"

printf "%b %b%b %b%b%b" "$time_part" "$host_part" "$account_part" "$cwd_part" "$git_part" "$usage_part"
