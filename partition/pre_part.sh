#!/bin/bash
# Useless script, maybe.
set -e

SOFTWARE_MIRROR="https://opentuna.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch"

echo "[pre_part] Disabling reflector"
systemctl stop reflector.service
systemctl status reflector.service

echo "[pre_part] Updating system clock"
timedatectl set-ntp true
timedatectl status

echo "[pre_part] Configuring software mirror"
echo "Server = $SOFTWARE_MIRROR" > /etc/pacman.d/mirrorlist

echo "[pre_part] Done."
