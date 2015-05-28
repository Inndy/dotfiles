# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
[ -z $ZSH_THEME ] && ZSH_THEME="alanpeabody"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ -x "`which nvim`" ]; then
    VIM=nvim
else
    VIM=vim
fi

alias ll="ls -l"
alias la="ls -a"
alias l="ls -alh"
alias less="less -R"
alias grep="grep --color=auto"
alias python2=python2.7
alias python=python3
alias ipy=ipython
alias vim=$VIM

# tmux
[ -x "`which tmux`" ] && alias tm=tmux

# ctags for php
if [ -x "`which ctags`" ]; then
    alias phptags='ctags --langmap=php:.engine.inc.module.theme.php --php-kinds=cdf --languages=php'
fi

# underscore-cli (nodejs package)
if [ -x "`which underscore`" ]; then
    alias pjson='underscore print --color'
fi

if [ -x "`which iconv`" ]; then
    function big5-2-utf8() {
        iconv -f big5 -t utf-8 "$1" > "$1.tmp~"
        mv "$1.tmp~" "$1"
    }

    function utf8-2-big5() {
        iconv -f utf8 -t big5 "$1" > "$1.tmp~"
        mv "$1.tmp~" "$1"
    }
fi

# pygmentize
if [ -x "`which pygmentize`" ]; then
    function highlight() {
        pygmentize -O encoding=utf8,style=monokai -f 256 $@
    }
    function readcode() {
        highlight $@ | less -R
    }
fi

# github-cli
# [ -x "`which hub`" ] && eval "$(hub alias -s)"

# 7z
if [ -x "`which 7z`" ]; then
    alias 8z=7z
    alias zl="7z l"
    alias zx="7z x"
fi

# minecraft path
if [ -d "/Users/$USER/Library/Application Support/minecraft" ]; then
    export MINECRAFT="/Users/$USER/Library/Application Support/minecraft"
fi

# python
if [ -r ~/.pythonrc.py ]; then
    export PYTHONSTARTUP=~/.pythonrc.py
fi

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew colored-man composer git history-substring-search laravel tmux urltools zsh-syntax-highlighting)

export HISTSIZE=10000000
setopt HIST_IGNORE_SPACE CORRECT

# User configuration

prefix_path() { [ -d "$1" ] && export PATH="$1:$PATH" }
extend_path() { [ -d "$1" ] && export PATH="$PATH:$1" }

register_man_path() { [ -d "$1" ] && export MANPATH="$1:$MANPATH" }


# check and preserve $PATH
if [ -z "$_PATH" ]; then
    export _PATH="$PATH"
else
    export PATH="$_PATH"
fi

# My CLI tools
extend_path "$HOME/cli-tool"

# Composer bin
extend_path "$HOME/.composer/vendor/bin"

if [ `uname -s` = 'Linux' ]; then
elif [ `uname -s` = 'Darwin' ]; then
    # brew
    prefix_path "/usr/local/sbin"

    # gnu tools
    prefix_path "/usr/local/opt/gnu-tar/libexec/gnubin"
    prefix_path "/usr/local/opt/gnu-sed/libexec/gnubin"

    register_man_path "/usr/local/opt/gnu-sed/libexec/gnuman"

    prefix_path "/usr/local/opt/coreutils/libexec/gnubin"
    register_man_path "/usr/local/opt/coreutils/libexec/gnuman"

    [ -x "`which mono`" ] && export MONO_GAC_PREFIX="/usr/local"

    # Genymotion adb
    function gadb {
    $( (ps aux | grep Genymotion | grep adb | grep -o -e '[^ ]\+adb'; echo adb) | head -n 1) $@
}
elif [ `uname -o` = 'Cygwin' ]; then
else
    echo "Oops! What's your OS?" > /dev/stderr
fi

# Android NDK
#export NDK_ROOT=~/android-ndk-r9d
#export NDK_Sample=$NDK_ROOT/samples
#export PATH=$PATH:$NDK_ROOT

# export MANPATH="/usr/local/man:$MANPATH"
# export NODE_PATH="/usr/local/lib/node_modules"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR=$VIM

# Compilation flags
# export ARCHFLAGS="-arch x86"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

[ -r ~/.zshrc.local ] && source ~/.zshrc.local

[ -d ~/.phpbrew ] && source ~/.phpbrew/bashrc

[ -d /usr/local/opt/android-sdk ] && export ANDROID_HOME=/usr/local/opt/android-sdk

# zsh help
if [ -f /usr/local/share/zsh/helpfiles ]; then
    unalias run-help
    autoload run-help
    HELPDIR=/usr/local/share/zsh/helpfiles
fi

source $ZSH/oh-my-zsh.sh

[ -r ~/.zshrc.local.after ] && source ~/.zshrc.local.after
#[ -x rvm ] && export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
