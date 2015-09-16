# Inndy's config files

## Notice

> I don't promise anything for these setting files,
> so you should check all files before you install it.

## Install

`git clone https://github.com/Inndy/dotfiles.git .dotfiles --depth 1 && cd .dotfiles && scripts/install.sh`

## Bootstrap your ubuntu VM

```
export EXTRA_PACKAGE="ack-grep curl htop iftop tree"
wget -qO- https://raw.githubusercontent.com/Inndy/dotfiles/master/scripts/bootstrap-ubuntu-vm.sh | bash
```

## About VIM

- My environment use [neovim](https://github.com/neovim/neovim) by default
- [README for VIM config](README_VIM.md)
