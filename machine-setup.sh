#!/bin/bash
BIN_DIR="$(cd `dirname $0` && pwd)"/bin
source $BIN_DIR/.envrc
source $BIN_DIR/setup-funcs.sh

if [ ! -f /etc/apt/sources.list.d/google.list ]; then
    echo Getting Google Package list
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
else
    if [ $PLATFORM == "Linux" ]; then
        read -p "Update package database? (y/N): "
        if [ "$REPLY" == "y" ]; then
            sudo apt-get update
        fi
    fi
fi

get_pkgs aptitude curl fping emacs23-nox
get_pkgs python-pip python-virtualenv
get_pkgs google-chrome-stable

get_pkgs git

if [ "$(git config --global user.name)" == "" ]; then
    read -p "Git Fullname: "
    git config --global user.name "$REPLY"
    read -p "Git Email: "
    git config --global user.email "$REPLY"
fi

get_pkgs s3cmd

if [ ! -f "$HOME/.s3cfg" ]; then
    s3cmd --configure
fi

for config in $PROJ_DIR/home/.* ; do
    [ -d $config ] && continue
    base=$(basename $config)
    if [ -e $HOME/$base ]; then
        echo Skipping $base config file - file exists.
    else
        echo Adding $base config file.
        ln -s $config $HOME/$base
    fi
done
