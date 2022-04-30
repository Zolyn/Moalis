#!/bin/bash
set -e

log() {
    echo "[Moalis:user] $1"
}

USERNAME="zorin"
UHOME="/home/$USERNAME"

log "Adding user $USERNAME"
useradd -m -G wheel -s /bin/bash $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/hosts

log "Setting password for user $USERNAME"
passwd $USERNAME

log "Configuring pacman"
cat >> /etc/pacman.conf << EOF
Color

[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF
pacman -Syu --confirm
pacman -S archlinuxcn-keyring

log "Installing X server"
pacman -S xorg xorg-server --confirm

log "Installing LightDM"
pacman -S lightdm --confirm
systemctl enable lightdm

log "Installing fonts"
pacman -S adobe-source-hans-serif-cn-fonts wqy-zenhei wqy-microhei --confirm
pacman -S pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --confirm

log "Installing paru"
pacman -S paru --confirm

log "Installing Fcitx5 and rime"
paru -S fcitx-im fcitx-material-color fcitx-rime  rime-cloverpinyin --noconfirm

log "Configuring rime"
mkdir $UHOME/.local/share/fcitx5/rime
cat > $UHOME/.local/share/fcitx5/rime/default.custom.yaml << EOF
patch:
  "menu/page_size": 8
  schema_list:
    - schema: clover
EOF

log "Configuring Fcitx5"
cat > $UHOME/.pam_environment << EOF
INPUT_METHOD DEFAULT=fcitx5
GTK_IM_MODULE DEFAULT=fcitx5
QT_IM_MODULE DEFAULT=fcitx5
XMODIFIERS DEFAULT=\\@im=fcitx5
SDL_IM_MODULE DEFAULT=fcitx
EOF

log "Installing timeshift"
paru -S timeshift --noconfirm

log "Installing graphic card drivers"
paru -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon --noconfirm
