echo "=============================="
echo "Update System"
echo "=============================="

pacman -Syu

pacman -Sy --needed --noconfirm \
  git \
  vim \
  reflector
  
echo "=============================="
echo "Refelector Setup"
echo "=============================="

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && \
reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy
mkdir install && cd install

echo "=============================="
echo "YAY Install"
echo "=============================="

cd $HOME/install
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

echo "=============================="
echo "YAY Insallations"
echo "=============================="

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
  gnome-icon-theme-symbolic \
  gnome-browser-connector

echo "=============================="
echo "Enable PCSD Service on startup"
echo "=============================="

systemctl enable --now pcscd.service

echo "=============================="
echo "AWS CLI install"
echo "=============================="

cd $HOME/install
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip awscli-exe-linux-x86_64.zip
cd aws
./install -i $HOME/.local/aws-cli -b $HOME/.local/bin --update
PATH=$PATH:$HOME/.local/bin

echo "=============================="
echo "Install Vitals Extension"
echo "=============================="

cd $HOME/install
git clone https://aur.archlinux.org/gnome-shell-extension-vitals-git.git/
cd gnome-shell-extension-vitals-git && makepkg -si

echo "=============================="
echo "Add AWS MFA Script"
echo "=============================="

mkdir ~/bin
cat > ~/bin/aws-mfa-connect.sh <<'endmsg'
#!/bin/bash
#
# https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/
#
# Usage: source ~/bin/awssessiontoken

# arn:aws:iam::12345689012:mfa/ExampleMFADevice

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

mfa_arn=$(aws iam list-mfa-devices --query 'MFADevices[].SerialNumber' --output text)
echo "MFA ARN: $mfa_arn"
echo -n "Enter MFA Code: "
read code

get_session_token=$(aws sts get-session-token --serial-number "$mfa_arn" --token-code "$code" --output json)

export AWS_ACCESS_KEY_ID=$(echo "$get_session_token" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$get_session_token" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$get_session_token" | jq -r '.Credentials.SessionToken')

unset mfa_arn
unset code
unset get_session_token
endmsg

chomd +x ~/bin/aws-mfa-connect.sh
alias aws-mfa-connect="source ~/bin/aws-mfa-connect.sh"

echo "=============================="
echo "Install Docker"
echo "=============================="

sudo pacman -S docker
sudo systemctl start docker.service
sudo systemctl enable docker.service

echo "=============================="
echo "Restart"
echo "=============================="
shutdown -r 00
