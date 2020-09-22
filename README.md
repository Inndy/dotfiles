# Inndy's config files

## It's not an open source project

> READ IT BEFORE USE IT. I AM NOT RESPONSIBLE FOR ANY DAMANGE.

## Install

`git clone https://github.com/Inndy/dotfiles.git .dotfiles --depth 1 && cd .dotfiles && scripts/install.sh`

## Bootstrap your ubuntu VM

```
export EXTRA_PACKAGE="ack-grep curl htop iftop tree"
wget -qO- https://raw.githubusercontent.com/Inndy/dotfiles/master/scripts/bootstrap-ubuntu-vm.sh | bash
```
