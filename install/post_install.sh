#!/bin/bash
set -e

log() {
    echo "[Moalis:configure] $1"
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
[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF
pacman -Syu --noconfirm
pacman -S archlinuxcn-keyring --noconfirm

log "Installing X server"
pacman -S xorg xorg-server --noconfirm

log "Installing LightDM"
pacman -S lightdm --noconfirm
systemctl enable lightdm

log "Installing fonts"
pacman -S adobe-source-hans-serif-cn-fonts wqy-zenhei wqy-microhei wqy-microhei-lite wqy-bitmapfont --noconfirm
pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm

log "Installing paru"
pacman -S paru --noconfirm

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

log "Intalling packages"
paru -S baobab bat blanket boxes cpupower cowsay cmatrix downgrade eom exa evince feh ffmpeg flameshot figlet fzf github-cli gnupg gtk2 gtk3 htop imagemagick inotify-tools kdeconnect krita lolcat marktext-bin microsoft-edge-dev-bin mpd mpv neofetch numlockx net-tools peek p7zip paprefs pavucontrol pulseaudio picgo-appimage ranger redshift screenfetch screenkey scrot tar thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tldr toilet unrar unzip  ventoy-bin visual-studio-code-bin vlc wget wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn xdman xdotool xss-lock xwinwrap-git yad yadm yay --noconfirm

log "Done"