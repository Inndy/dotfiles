#!/bin/bash

cd /tmp
git clone https://github.com/ilikenwf/apt-fast.git apt-fast --depth 1
cd apt-fast
sudo apt-get install aria2 -y

function installfile()
{
    sudo install -o root -m $1 $2 $3
}
gzip -f9 man/apt-fast.8
gzip -f9 man/apt-fast.conf.5

installfile 755 apt-fast /usr/bin/apt-fast
installfile 644 apt-fast.conf /etc/apt-fast.conf
installfile 644 completions/bash/apt-fast /etc/bash_completion.d/
installfile 644 man/apt-fast.8.gz /usr/share/man/man8
installfile 644 man/apt-fast.conf.5.gz /usr/share/man/man5
