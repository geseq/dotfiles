echo "Backing up ~/.zshrc to ~/.zshrc.bak"
mv $HOME/.zshrc $HOME/.zshrc.bak

# Configure terminal
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/plugins/zsh-syntax-highlighting
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $HOME/.zsh/themes/powerlevel10k

echo "source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
echo "source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
echo "source $HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme" >> $HOME/.zshrc
echo "ZSH_AUTOSUGGEST_STRATEGY=(history completion)" >> $HOME/.zshrc
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> $HOME/.zshrc
echo "export HOMEBREW_NO_INSECURE_REDIRECT=1" >> $HOME/.zshrc
echo "export HOMEBREW_CASK_OPTS=--require-sha" >> $HOME/.zshrc
echo "alias zr='source $HOME/.zshrc'" >> $HOME/.zshrc
echo "alias lg='lazygit'" >> $HOME/.zshrc
echo 'ds() { docker stop $(docker ps -a -q); }' >> $HOME/.zshrc
echo 'drm() { docker rm $(docker ps -a -q); }' >> $HOME/.zshrc
echo 'drmi() { docker rmi $(docker images -q) -f; }' >> $HOME/.zshrc
echo 'drmv() { docker volume prune; }' >> $HOME/.zshrc

chsh -s $(which zsh)
