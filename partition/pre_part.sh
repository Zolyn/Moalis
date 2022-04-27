#!/bin/bash
set -e

SOFTWARE_MIRROR="https://opentuna.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch"
# SOFTWARE_MIRROR = "https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch"

echo "Disabling reflector"
systemctl stop reflector.service
systemctl status reflector.service

echo "Updating system clock"
timedatectl set-ntp true
timedatectl status

echo "Configuring software mirror"
echo "Server = $SOFTWARE_MIRROR" > /etc/pacman.d/mirrorlist

echo "[pre_part] Done."
