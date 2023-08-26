## Update System
pacman -Syu

pacman -Sy --needed --noconfirm \
  git \
  vim \
  reflector \
  intel-ucode \
  linux-lts linux-lts-headers 

## Using reflector to get faster mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && \
reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy
mkdir install && cd install

## yay installation
cd $HOME/install
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

## yay installs
yay -Sy --needed --noconfirm \
  visual-studio-code-bin \
  terraform \
  terragrunt \
  kubectl \
  zoom \
  slack-desktop \
  opensc \
  ccid \
  icaclient \
  pcsc-tools \
  timeshift \
  gnome-icon-theme \
  gnome-icon-theme-symbolic

## Enable on startup
systemctl enable --now pcscd.service

## AWS CLI install
cd $HOME/install
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
cd aws
./install -i $HOME/.local/aws-cli -b $HOME/.local/bin --update
PATH=$PATH:$HOME/.local/bin

## Install Vitals Extension
cd $HOME/install
git clone https://aur.archlinux.org/gnome-shell-extension-vitals-git.git/
cd gnome-shell-extension-vitals-git && makepkg -si

## Restart
shutdown -r 00
