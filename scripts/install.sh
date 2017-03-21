#!/bin/bash

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.4.0  | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\________________________________________________\\|"
echo ""

echo "source $HOME/.dotfiles/bashrc" >> ~/.bashrc
echo "source $HOME/.dotfiles/peda/peda.py" >> ~/.gdbinit

for file in tmux.conf vim vimrc inputrc bashrc gitconfig
do
	if [ "$(whoami)" != "inndy" -a "$file" = "gitconfig" ]; then
		continue
	fi
    ln -s .dotfiles/$file ~/.$file
done


echo "Init submodules..."
git submodule update --init cli-tools
git submodule update --init peda
git submodule status

echo<<__LOCAL_RC_FILE__ >> ~/.bashrc.local
export PATH="\$PATH:\$HOME/.bin:\$HOME/.dotfiles/cli-tools/bin"
__LOCAL_RC_FILE__
