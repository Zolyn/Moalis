#!/bin/bash
set -e

log() {
    echo "[Moalis:configure_software] $1"
}

if [ "$USER" == "root" ];then
  log "Please run this script as normal user"
  exit
fi

log "Installing fonts"
paru -S adobe-source-han-serif-cn-fonts wqy-zenhei wqy-microhei-kr-patched wqy-microhei-lite wqy-bitmapfont --noconfirm
paru -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --noconfirm

log "Installing Fcitx5 and rime"
paru -S fcitx5-im fcitx5-rime rime-cloverpinyin --noconfirm

log "Configuring rime"
mkdir -p ~/.local/share/fcitx5/rime
cat > ~/.local/share/fcitx5/rime/default.custom.yaml << EOF
patch:
  "menu/page_size": 8
  schema_list:
    - schema: clover
EOF

log "Installing timeshift"
paru -S timeshift --noconfirm

log "Intalling packages"
paru -S baobab bat blanket bluez bluez-utils blueberry boxes cpupower cheese cowsay cmatrix cpu-x downgrade dmidecode eom exa evince feh filelight ffmpeg flameshot figlet fzf github-cli gnupg gnome-keyring gpu-viewer gtk2 gtk3 htop imagemagick inotify-tools kcalc kdeconnect krita lolcat libva-mesa-driver marktext-bin microsoft-edge-dev-bin mpd mpv mugshot namcap neofetch numlockx net-tools obs-studio peek p7zip paprefs pavucontrol pulseaudio picgo-appimage ranger redshift screenfetch screenkey scrot skanlite smartmontools tar thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tldr toilet unrar unzip ventoy-bin visual-studio-code-bin vlc wget wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn xdman xdotool xss-lock xwinwrap-git yad yadm yay --noconfirm

paru -S howdy linux-enable-ir-emitter

log "Enabling bluetooth service"
sudo systemctl enable bluetooth.service

log "Done"
