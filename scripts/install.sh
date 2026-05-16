#!/bin/bash

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.7.0   | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\________________________________________________\\|"
echo ""

-warn() {
	printf "\e[1;4;5m[!] Warning: %s\e[0m\n" "$*"
}

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

add_dotfiles claude
add_dotfiles_unless "$NO_TMUX" tmux.conf
add_dotfiles_unless "$NO_VIM" vim vimrc

[ "$(whoami)" = "inndy" ] && add_dotfiles_unless "$NO_GIT" gitconfig
if [ -z "$NO_GIT" ]; then
	grep -qF 'name = Inndy' ~/.gitconfig || cat << _EOF_ >> ~/.gitconfig
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
		-warn "~/.bashenv exists, will not append any data to it."
	else
		{
			echo '#!/bin/bash'
			echo "export DOTFILES=\"$DOTFILES\""
		} >> ~/.bashenv
	fi

	# alias (not symlink) so `cc` stays interactive-only and doesn't shadow the C compiler in scripts
	cc_alias='alias cc="$DOTFILES/bin/claude-launcher"'
	grep -qF "$cc_alias" ~/.bashrc.local 2>/dev/null || echo "$cc_alias" >> ~/.bashrc.local

fi

for file in $LINK_DOT_FILES; do
	if [ -e ~/."$file" ]
	then
		-warn "~/.$file exists, will not create link"
	else
		ln -s "$DOTFILES"/$file ~/.$file
	fi
done

if [ -z "$NO_VIM" ]; then
	mkdir -p ~/.config

	NVIM_CONFIG="$HOME/.config/nvim"
	NVIM_DOTFILES="$DOTFILES/nvim"

	if [ -L "$NVIM_CONFIG" ]; then
		if [ "$(readlink "$NVIM_CONFIG")" != "$NVIM_DOTFILES" ]; then
			rm "$NVIM_CONFIG"
			ln -s "$NVIM_DOTFILES" "$NVIM_CONFIG"
		fi
	elif [ -e "$NVIM_CONFIG" ]; then
		-warn "$NVIM_CONFIG exists, will not replace it"
	else
		ln -s "$NVIM_DOTFILES" "$NVIM_CONFIG"
	fi
fi
