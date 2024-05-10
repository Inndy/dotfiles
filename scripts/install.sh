#!/bin/bash

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.7.0   | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\________________________________________________\\|"
echo ""

SCRIPT=`realpath "$0"`
SCRIPTS=`dirname "$SCRIPT"`
DOTFILES=`dirname "$SCRIPTS"`

# parse arguments
POSITIONAL=()
END_PARSE=N
while [[ $# -gt 0 ]]; do
	key="$1"
	if [ $END_PARSE = N ]; then
		case $key in
			-B|--no-bashrc)
				NO_BASH=Y
				shift
				;;
			-V|--no-vim)
				NO_VIM=Y
				shift
				;;
			-T|--no-tmux)
				NO_TMUX=Y
				shift
				;;
			-G|--no-git)
				NO_GIT=Y
				shift
				;;
			-h|--help)
				echo "Usage $0 [options]"
				echo ""
				echo "  options:"
				echo "    -B, --no-bashrc         Do not install bashrc related files"
				echo "    -V, --no-vim            Do not install vim profiles"
				echo "    -T, --no-tmux           Do not install tmux profiles"
				echo "    -G, --no-git            Do not install git profiles"
				exit
				;;
			--)
				END_PARSE=Y
				;;
			-*)
				echo "Unkown option $key" >&2
				exit 1
				;;
			*)
				POSITIONAL+=("$1")
				shift
				;;
		esac
	else
		POSITIONAL+=("$1")
		shift
	fi
done
set -- "${POSITIONAL[@]}"

LINK_DOT_FILES="inputrc"

function add_dotfiles()
{
	LINK_DOT_FILES="$LINK_DOT_FILES $*"
}

function add_dotfiles_unless()
{
	[ -z "$1" ] && shift && add_dotfiles "$*"
}

add_dotfiles_unless "$NO_TMUX" tmux.conf
add_dotfiles_unless "$NO_VIM" vim vimrc

[ "$(whoami)" = "inndy" ] && add_dotfiles_unless "$NO_GIT" gitconfig
if [ -z "$NO_GIT" ]; then
	[ ! -f ~/.gitconfig ] && cat << _EOF_ > ~/.gitconfig
[user]
	name = Inndy
	email = inndy.tw@gmail.com
_EOF_

	grep -qF "$DOTFILES/gitconfig" ~/.gitconfig || cat << _EOF_ >> ~/.gitconfig
[include]
	path = $DOTFILES/gitconfig
_EOF_
fi

if [ -z "$NO_BASH" ]; then

	newline="source $DOTFILES/bashrc"
	grep -qF "$newline" ~/.bashrc || echo "$newline" >> ~/.bashrc

	if [ -f ~/.bashenv ]
	then
		echo -e "\e[1;4;5m[!] Warning: ~/.bashenv exists, will not append any data to it.\e[0m"
	else
		{
			echo '#!/bin/bash'
			echo "export DOTFILES=\"$DOTFILES\""
		} >> ~/.bashenv
	fi

fi

for file in $LINK_DOT_FILES; do
    ln -s "$DOTFILES"/$file ~/.$file
done

if [ -z "$NO_VIM" ]; then
	mkdir -p ~/.config
	ln -s ~/.vim ~/.config/nvim
	ln -s ~/.vimrc ~/.config/nvim/init.vim
fi
