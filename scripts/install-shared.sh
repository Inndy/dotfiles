#!/bin/bash

SCRIPT=`realpath "$0"`
SCRIPTS=`dirname "$SCRIPT"`
DOTFILES=`dirname "$SCRIPTS"`

function linkfile()
{
    ln -s "$DOTFILES"/"$1" "$2"
}

linkfile inputrc ~/.inputrc
linkfile tmux.conf ~/.inndy.tmux.conf

echo '[ -n "$_BASH_SOURCE_FILE" ] && source "$_BASH_SOURCE_FILE"' >> ~/.bashrc
cat<<__LOCAL_RC_FILE__ >> ~/.bashenv
#!/bin/bash
export DOTFILES="$DOTFILES"
__LOCAL_RC_FILE__
