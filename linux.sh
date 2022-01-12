#!/bin/bash

set -x

sudo -v

# Privacy settings https://askubuntu.com/questions/1027532/how-to-opt-out-of-system-information-reports
ubuntu-report -f send no
sudo apt purge ubuntu-report popularity-contest apport whoopsie

# Update and install necessary components
sudo apt update && sudo apt upgrade

# codecs
sudo apt install -y ubuntu-restricted-extras

# battery
sudo apt install tlp tlp-rdw
sudo tlp start

# cleanup
sudo apt autoremove

# privacy focused hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts
wc -l /etc/hosts
egrep -ve "^#|^255.255.255.255|^127.|^0.|^::1|^ff..::|^fe80::" /etc/hosts | sort | uniq | egrep -e "[1,2]|::"

# install flameshot for screenshots
sudo apt install -y flameshot

# enable firewall
sudo apt install -y ufw
sudo ufw enable

#development tools
sudo apt install -y wget vim neovim curl xclip
sudo snap install --classic go
sudo apt install -y fzf ripgrep fd-find
sudo apt install -y tmux
sudo apt install -y zsh
sudo apt install -y gnupg software-properties-common
sudo apt install -y jq

# lazygit
sudo add-apt-repository -y ppa:lazygit-team/release && sudo apt update
sudo apt install -y lazygit
 
# fonts
sudo apt install -y fonts-firacode

# docker
sudo apt install -y apt-transport-https ca-certificates lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install -y terraform

# ulauncher
sudo add-apt-repository -y ppa:agornostal/ulauncher
sudo apt update && sudo apt install -y ulauncher
systemctl --user enable --now ulauncher

# sway
sudo apt install -y sway
# grim and slurp for screenshots in sway
sudo apt install -y grim slurp

# regolith
sudo add-apt-repository -y ppa:regolith-linux/stable
sudo apt install -y regolith-desktop-minimal
sudo apt install regolith-look-ubuntu
regolith-look set ubuntu
regolith-look refresh
sudo apt purge remontoire -y
sudo apt install -y i3xrocks-time i3xrocks-volume 

# blueman
sudo apt install -y blueman

# clipper
git clone git://git.wincent.com/clipper.git
(cd clipper && go build && sudo cp clipper /usr/local/bin/ && cp contrib/linux/systemd-service/clipper.service ~/.config/systemd/user)
systemctl --user daemon-reload
systemctl --user enable clipper.service
systemctl --user start clipper.service

# yubikey-agent
sudo apt -y install build-essential libpcsclite-dev pcscd
git clone https://filippo.io/yubikey-agent
(cd yubikey-agent && go build && sudo cp yubikey-agent /usr/local/bin/)

mkdir -p $HOME/.config/systemd/user
curl https://raw.githubusercontent.com/FiloSottile/yubikey-agent/main/contrib/systemd/user/yubikey-agent.service -o $HOME/.config/systemd/user/yubikey-agent.service
systemctl daemon-reload --user
sudo systemctl enable --now pcscd.socket
systemctl --user enable --now yubikey-agent

mkdir -p $HOME/.ssh
echo "Host *" > $HOME/.ssh/config
echo "    IdentityAgent ${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock" >> $HOME/.ssh/config
echo "    VisualHostKey yes" >> $HOME/.ssh/config
