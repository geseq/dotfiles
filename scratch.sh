#!/bin/bash

set -x -e

sudo -v

export DEBIAN_FRONTEND=noninteractive

# Cleanup
sudo apt -y purge apport
sudo apt -y purge cloud-init
sudo apt -y purge lxd-agent-loader
sudo rm -rf /etc/cloud && sudo rm -rf /var/lib/cloud

# Update and install necessary components
sudo apt update && sudo apt upgrade -y

# Other stuff
sudo apt install -y xdg-utils

# codecs
sudo apt install -y ubuntu-restricted-extras

# battery
sudo apt install -y tlp tlp-rdw
sudo systemctl enable tlp.service
sudo tlp start

# cleanup
sudo apt autoremove -y

# privacy focused hosts file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts
wc -l /etc/hosts
egrep -ve "^#|^255.255.255.255|^127.|^0.|^::1|^ff..::|^fe80::" /etc/hosts | sort | uniq | egrep -e "[1,2]|::"

# install flameshot for screenshots
sudo apt install -y flameshot

# enable firewall
sudo apt install -y ufw
sudo ufw enable

# font awesome
sudo apt install fonts-font-awesome

#development tools
sudo apt install -y wget vim curl pkg-config wl-clipboard
sudo snap install nvim --classic
sudo apt install -y golang
sudo apt install -y fzf ripgrep fd-find
sudo apt install -y tmux
sudo apt install -y zsh
sudo apt install -y gnupg software-properties-common
sudo apt install -y jq
sudo apt install -y network-manager
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile

# lazygit
go install github.com/jesseduffield/lazygit@latest
 
# fonts
sudo apt install -y fonts-firacode

# docker
sudo apt install -y apt-transport-https ca-certificates lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER

# terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install -y terraform

# sway
sudo apt install -y sway wdisplays swayidle swaylock xdg-desktop-portal-wlr waybar

# ulauncher
sudo add-apt-repository -y ppa:agornostal/ulauncher
sudo apt update && sudo apt install -y ulauncher
systemctl --user enable --now ulauncher

# grim and slurp for screenshots in sway
sudo apt install -y grim slurp

# blueman
sudo apt install -y blueman

# firefox
sudo apt install -y firefox

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

# Use network-manager
sudo rm /etc/netplan/*.yaml
echo "network:
  version: 2
  renderer: NetworkManager
" | sudo tee -a /etc/netplan/01-network-manager-all.yaml > /dev/null

echo 'export MOZ_ENABLE_WAYLAND=1' | sudo tee -a /etc/profile > /dev/null

sudo netplan generate
sudo netplan apply

# More cleanup
sudo apt -y purge byobu tilix

reboot
