#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo "Backing up ~/.vimrc to ~/.vimrc.bak"
mv ~/.vimrc ~/.vimrc.bak

echo "Backing up ~/.tmux.conf to ~/.tmux.conf.bak"
mv ~/.tmux.conf ~/.tmux.conf.bak

echo "Backing up ~/.vim to ~/.vim.bak"
mv ~/.vim ~/.vim.bak

mkdir -p ~/.vim/pack/plugins/start
mkdir ~/.vim/undos

# Install color schemes

# Install PaperColor
mkdir -p ~/.vim/colors
curl -o ~/.vim/colors/PaperColor.vim https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim

# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 
cp ./.vimrc ~/
cp ./.tmux.conf ~/

if [[ $machine == "Linux" ]]; then
    cp -r ./.config/* ~/.config
fi

cp -r ./.cargo/* ~/.cargo

nvim -c ":PackerInstall"
