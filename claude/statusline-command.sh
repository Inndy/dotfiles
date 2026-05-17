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

printf "%b %b%b %b%b" "$time_part" "$host_part" "$account_part" "$cwd_part" "$git_part"
