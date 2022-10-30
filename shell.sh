echo "Backing up ~/.zshrc to ~/.zshrc.bak"
rm -f $HOME/.zshrc.bak
mv $HOME/.zshrc $HOME/.zshrc.bak

rm -rf $HOME/.zsh.bak
mv $HOME/.zsh $HOME/.zsh.bak

# Configure terminal
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $HOME/.zsh/themes/powerlevel10k

cat >> $HOME/.zshrc <<"EOT"
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_THEME="powerlevel10k/powerlevel10k"
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

#go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

#c++
# C++
export CPM_SOURCE_CACHE=$HOME/.cache/CPM
export CXX=clang++

# set default editor
export EDITOR=nvim
# this will fix bindings on tmux
bindkey -e

# set history size
export HISTSIZE=10000
# save history after logout
export SAVEHIST=10000
# history file
export HISTFILE=~/.zhistory
# append into history file
setopt INC_APPEND_HISTORY
# save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
# add timestamp for each entry
setopt EXTENDED_HISTORY   

# aliases
alias zr='source $HOME/.zshrc'
alias ze='nvim $HOME/.zshrc'
alias lg='lazygit'
alias cx='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1'


# functions
ds() { docker stop $(docker ps -a -q);  }
drm() { docker rm $(docker ps -a -q);  }
drmi() { docker rmi $(docker images -q) -f;  }
drmv() { docker volume prune;  }

EOT

chsh -s $(which zsh)
