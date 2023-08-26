## Update System
pacman -Syu

pacman -Sy --noconfirm \
  git \
  vim \
  reflector \
  intel-ucode \
  linux-lts linux-lts-headers 

## Using reflector to get faster mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && \
reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy

## yay installation
cd $HOME
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

## yay installs
yay -Sy --needed --noconfirm \
  visual-studio-code-bin \
  timeshift \
  kubectl \
  slack-dekstop \
  opensc \
  ccid \
  icaclient \
  pcsc-tools

## Enable on startup
systemctl enable --now pcscd.service

## AWS CLI install
cd $HOME
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
cd aws
./install -i $HOME/.local/aws-cli -b $HOME/.local/bin --update
PATH=$PATH:/home/hgbarreto/.local/bin

## Restart
shutdown -r 00
