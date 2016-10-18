#!/bin/bash

function run()
{
    echo "X18gICAgIF9fX18gIF9fICAgX19fXyAgICAgICAgICAgICAgXyAgICAgICBfICAgICAgICAg
ICAgICAgICAgIApcIFwgICAvIC8gIFwvICB8IHwgX18gKSAgX19fICAgX19fIHwgfF8gX19f
fCB8XyBfIF9fIF9fIF8gXyBfXyAgCiBcIFwgLyAvfCB8XC98IHwgfCAgXyBcIC8gXyBcIC8g
XyBcfCBfXy8gX198IF9ffCAnX18vIF9gIHwgJ18gXCAKICBcIFYgLyB8IHwgIHwgfCB8IHxf
KSB8IChfKSB8IChfKSB8IHxfXF9fIFwgfF98IHwgfCAoX3wgfCB8XykgfAogICBcXy8gIHxf
fCAgfF98IHxfX19fLyBcX19fLyBcX19fLyBcX198X19fL1xfX3xffCAgXF9fLF98IC5fXy8g
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHxffCAgICAK" | base64 --decode

    if [ ! -x "$(which apt-get 2>/dev/null)" ]; then
        echo "I need an ubuntu environment :("
        exit 1
    fi

    command="echo 'Asia/Taipei' > /etc/timezone &&
             apt-get update &&
             apt-get upgrade -y &&
             apt-get install -y git-core tmux vim build-essential python3-pip"

    if [ -n "$HACKER" ]; then
        PACKAGES="$PACKAGES gdb gcc-multilib p7zip-full nmap hexedit ht python python-dev python-pip"
        command="$command && pip3 install ipython[notebook] && pip2 install ipython[notebook] pwntools"
    fi

    if [ -n "$PACKAGES" ]; then
        command="$command && apt-get install -y $PACKAGES"
    fi

    if [ "$DOCKER" = "1" ]; then
        command="$command && wget -qO- https://get.docker.com | sh"
    fi

    sudo sh -c "$command"

    git clone https://github.com/inndy/dotfiles ~/.dotfiles
    cd ~/.dotfiles
    git checkout ubuntu-vm

    files='ctags
           gitignore_global
           vim vimrc
           inputrc
           bashrc
           gitconfig'
    for file in `echo $files | tr ' ' '\n'`; do
        ln -sf ~/.dotfiles/$file ~/.$file
    done
    ln -sf ~/.dotfiles/server-tmux.conf ~/.tmux.conf
    git submodule init
    git submodule update
    git submodule status
}

run
