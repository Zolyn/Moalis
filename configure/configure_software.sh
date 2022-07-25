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

log "Configuring Fcitx5"
cat > ~/.pam_environment << EOF
INPUT_METHOD DEFAULT=fcitx5
GTK_IM_MODULE DEFAULT=fcitx5
QT_IM_MODULE DEFAULT=fcitx5
XMODIFIERS DEFAULT=\\@im=fcitx5
SDL_IM_MODULE DEFAULT=fcitx
EOF

log "Installing timeshift"
paru -S timeshift --noconfirm

log "Intalling packages"
paru -S baobab bat cpupower cheese downgrade eom exa evince feh filelight ffmpeg flameshot fzf github-cli gnupg gnome-keyring gtk2 gtk3 htop imagemagick kcalc lolcat marktext-bin microsoft-edge-dev-bin mpd mpv mugshot neofetch numlockx net-tools peek p7zip paprefs pavucontrol pulseaudio picgo-appimage ranger screenfetch screenkey scrot skanlite smartmontools tar thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tldr unrar unzip ventoy-bin visual-studio-code-bin vlc variety wget xdman xdotool xss-lock yad yadm yay --noconfirm

paru -S howdy

log "Done"
