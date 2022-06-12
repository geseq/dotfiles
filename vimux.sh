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

# Install plugins

# Install fzf
(git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)

# install fzf.vim
git clone https://github.com/junegunn/fzf.vim.git ~/.vim/pack/plugins/start/fzf.vim

# install vim-airline
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/pack/plugins/start/vim-airline

# install vim-go
git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
vim +GoInstallBinaries +qall 

# install vim-terraform
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugins/start/vim-terraform

# install vim-mucomplete
git clone https://github.com/lifepillar/vim-mucomplete.git ~/.vim/pack/plugins/start/vim-mucomplete

# install languageclient-neovim
git clone https://github.com/autozimu/Languageclient-neovim.git ~/.vim/pack/plugins/start/languageclient-neovim
(cd ~/.vim/pack/plugins/start/languageclient-neovim && bash install.sh)

# install vim-autoformat
git clone https://github.com/vim-autoformat/vim-autoformat.git ~/.vim/pack/plugins/start/vim-autoformat

# Install auto-pairs
mkdir -p ~/.vim/plugin
curl -o ~/.vim/plugin/auto-pairs.vim  https://raw.githubusercontent.com/jiangmiao/auto-pairs/master/plugin/auto-pairs.vim

# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 
cp ./.vimrc ~/
cp ./.tmux.conf ~/
cp ./.clipper.json ~/

if [[ $machine == "Linux" ]]; then
    cp -r ./.config/* ~/.config
fi

cp -r ./.cargo/* ~/.cargo

nvim -c ":PackerInstall"
