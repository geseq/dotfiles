#!/bin/bash

set -x -e

# Determine OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# OS specific installation
if [ $machine = "Linux" ]; then
    flavor="$(cat /var/log/installer/media-info | cut -f 1 -d ' ' | xargs)"
    echo $flavor;
    if [ $flavor = "Ubuntu-Server" ]; then
        ./scratch.sh
    else
        ./linux.sh
    fi
elif [ $1 = "Mac" ]; then
    ./mac.sh
else
    echo "Invaild OS detected"
fi

# Setup shell
./shell.sh

# Setup vim and tmux
./vimux.sh
