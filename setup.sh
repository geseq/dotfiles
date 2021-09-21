#!/bin/bash

set -x

# Determine OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# OS specific installation
if [ $machine = "Linux" ]; then
    ./linux.sh
elif [ $1 = "Mac" ]; then
    ./mac.sh
else
    echo "Invaild OS detected"
fi

# Setup shell
./shell.sh

# Setup vim and other configs
./vim.sh
