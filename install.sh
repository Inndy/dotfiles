#!/bin/bash

files='ctags
       gitignore_global
       tmux.conf
       vim vimrc
       nvim nvimrc
       zshrc
       inputrc
       bashrc
       pythonrc.py
'

function abspath() {
    pushd . > /dev/null
    if [ -d "$1"  ]; then
        cd "$1"; dirs -l +0
    else
        cd "`dirname \"$1\"`"
        cur_dir=`dirs -l +0`
        if [ "$cur_dir" == "/"  ]; then
            echo "$cur_dir`basename \"$1\"`"
        else
            echo "$cur_dir/`basename \"$1\"`"
        fi
    fi
    popd > /dev/null
}

function check_git() {
    if [ -x "`which git`" ]; then
        echo "You already have git. :D"
    else
        echo "You need git to do this. :("
        return 1
    fi
}

function check_zsh() {
    if [ -x "`which zsh`" ]; then
        echo "You already have zsh. :D"
    else
        echo "You may need zsh..."
        return 1
    fi
}

function check_ohmyzsh() {
    if [ -d ~/.oh-my-zsh ]; then
        echo "You already have oh-my-zsh. Good!"
    else
        echo "Seems that you don't have oh-my-zsh."
        return 1
    fi
}

function install_file() {
    dst=~/.$1
    if [ -f $dst ] || [ -d $dst ]; then
        echo "File conflict: $dst"
    else
        src="`abspath $1`"
        link "$src" "$dst"
    fi
}

function link() {
    echo "Link '$1' to '$2'"
    ln -s "$1" "$2"
}

function install_vim_plugin() {
    echo "Install vim plugins"
    vim -c "NeoBundleInstall" -c "q"
}

function fix_prev() {
    if [ -L ~/.pytonrc.py ]; then
        echo -ne '~/.pytonrc.py found, do you want to remove it? (y)'
        read rmf
        if [ -z $rmf ] || [ $rmf == "Y" ] || [ $rmf == "y" ]; then
            rm ~/.pytonrc.py
        fi
    fi
}

echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |    Inndy's config file install script v0.2.0a  | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\________________________________________________\\|"
echo ""

fix_prev

if [ -f ~/.bashrc ]; then
    echo -ne "~/.bashrc found, do you want to append to it?"
    read append_to_bashrc
    if [ "$append_to_bashrc" = "y" -o "$append_to_bashrc" = "Y" ]; then
        echo "source $HOME/.dotfiles/bashrc" >> ~/.bashrc
    fi
fi

for file in `echo $files | tr ' ' '\n'`; do
    install_file $file
done

if [ "$(whoami)" = "inndy" ]; then
    install_file gitconfig
else
    if [ -f ~/.gitconfig ]; then
        echo "File conflict: ~/.gitconfig"
    else
        echo -ne "You are not Inndy, so you have to gitconfig manually "
        echo "update gitconfig when git-pull."
        awk '{if ($1 != "email" && $1 != "name") {print $0}}' gitconfig > ~/.gitconfig
    fi
fi

echo "Install cli-tools..."
git submodule init
git submodule update
git submodule status

install_vim_plugin

check_zsh
if [ $? -eq 0 ]; then
    echo -ne "Do you want to switch to zsh? (y/n)"
    read switch_to_zsh
    if [ "$switch_to_zsh" = "y" ] || [ "$switch_to_zsh" = "Y" ]; then
        echo "Now we switch to zsh!!"
        chsh -s /bin/zsh
    fi
fi

check_ohmyzsh
if [ $? -ne 0 ]; then
    check_git
    if [ $? -eq 0 ]; then
        echo -ne "You don't have oh-my-zsh, do you want to install? (y/n)"
        read install_ohmyzsh
        if [ "$install_ohmyzsh" = "y" ] || [ "$install_ohmyzsh" = "Y" ]; then
            git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1
        fi
    else
        echo "You don't have git so we can't install oh-my-zsh for you :("
    fi
fi

if [ -f ~/.zshrc.local ]; then
    echo "~/.zshrc.local exists, please manual add cli-tools to \$PATH"
else
    echo "Write cli-tools path to $HOME/.zshrc.local"
    echo "export PATH=\"\$PATH:$PWD/cli-tools/bin\"" >> ~/.zshrc.local
fi

if [ -f ~/.bashrc.local ]; then
    echo "~/.bashrc.local exists, please manual add cli-tools to \$PATH"
else
    echo "Write cli-tools path to $HOME/.bashrc.local"
    echo "export PATH=\"\$PATH:$PWD/cli-tools/bin\"" >> ~/.bashrc.local
fi
