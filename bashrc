#!/usr/bin/env bash

export HISTSIZE=100000
export HISTCONTROL=erasedups
shopt -s histappend

reset_color="\e[00m"
fg_black="\e[30m"
fg_red="\e[31m"
fg_green="\e[32m"
fg_yellow="\e[33m"
fg_blue="\e[34m"
fg_magenta="\e[35m"
fg_cyan="\e[36m"
fg_white="\e[37m"

parse_git_branch() {
    git branch --no-color 2> /dev/null | awk '{ if ($1 == "*" ) { print substr($0, 3) } }'
}

print_git_branch() {
    branch="$(parse_git_branch)"
    if [ -n "$branch" ]; then
        echo -ne " (${fg_green}${branch}${reset_color})"
    fi
}

PS1="${fg_magenta}\u@\h ${fg_blue}\W${reset_color}\$(print_git_branch)\$ "
alias ls="ls -G --color=auto"

if [ -f ~/.phpbrew/bashrc ]; then
    source /Users/inndy/.phpbrew/bashrc
fi

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
