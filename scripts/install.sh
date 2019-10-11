#!/bin/bash

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.6.1   | \\"
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
			-P|--no-peda)
				NO_PEDA=Y
				shift
				;;
			-C|--no-cli)
				NO_CLI=Y
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
				echo "    -P, --no-peda           Do not install gdb plugin peda"
				echo "    -C, --no-cli            Do not install cli-tools"
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

add_dotfiles_unless $NO_TMUX tmux.conf
add_dotfiles_unless $NO_VIM vim vimrc

# only install gitconfig if user is inndy
[ "$(whoami)" = "inndy" ] && add_dotfiles_unless $NO_GIT gitconfig


[ -z "$NO_CLI" ] && git submodule update --init cli-tools

if [ -z "$NO_PEDA" ]; then
	echo "source $DOTFILES/peda/peda.py" >> ~/.gdbinit
	git submodule update --init peda
fi

if [ -z "$NO_BASH" ]; then
add_dotfiles $NO_BASH bashrc

[ ! -f ~/.bashrc.local ] && echo "source $DOTFILES/bashrc" >> ~/.bashrc

cat<<__LOCAL_RC_FILE__ >> ~/.bashenv
#!/bin/bash
export DOTFILES="$DOTFILES"
__LOCAL_RC_FILE__

if [ -z "$NO_CLI" ]; then
cat<<__LOCAL_RC_FILE_CLITOOLS_PATH__ >> ~/.bashenv
export PATH="\$PATH:$DOTFILES/cli-tools/bin"
__LOCAL_RC_FILE_CLITOOLS_PATH__
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

git submodule status
