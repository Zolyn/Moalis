#!/bin/bash
# Useless script, maybe.
set -e

log() {
    echo "[Moalis:pre_part] $1"
}

SOFTWARE_MIRROR="https://opentuna.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch"

log "Disabling reflector"
systemctl stop reflector.service
systemctl status reflector.service

log "Updating system clock"
timedatectl set-ntp true
timedatectl status

log "Configuring software mirror"
echo "Server = $SOFTWARE_MIRROR" > /etc/pacman.d/mirrorlist

log "Syncing software database"
pacman -Sy

log "Done."
