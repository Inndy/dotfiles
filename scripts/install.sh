#!/bin/bash

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.3.0  | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\________________________________________________\\|"
echo ""

if [ -f ~/.bashrc ]; then
    echo -ne "~/.bashrc found, do you want to append to it?"
    read append_to_bashrc
    if [ "$append_to_bashrc" = "y" -o "$append_to_bashrc" = "Y" ]; then
        echo "source $HOME/.dotfiles/bashrc" >> ~/.bashrc
    fi
fi

for file in ctags gitignore_global tmux.conf vim vimrc nvim nvimrc inputrc bashrc
do
	if [ "$(whoami)" = "inndy" -a "$file" = "gitconfig" ]; then
		continue
	fi
    ln -s .dotfiles/$file ~/.$file
done


echo "Install cli-tools..."
git submodule update --init cli-tools
git submodule status

echo<<__LOCAL_RC_FILE__ >> ~/.bashrc.local
export PATH="\$PATH:\$HOME/.bin:\$HOME/.dotfiles/cli-tools/bin"
__LOCAL_RC_FILE__
