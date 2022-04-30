#!/bin/bash
set -e

dir=$(dirname $0)

echo "[pre_chroot] Installing system"
pacstrap /mnt base base-devel linux linux-firmware git dhcpcd nano vim sudo

echo "[pre_chroot] Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

echo "[pre_chroot] Copying scripts"
cp "$dir/post_chroot.sh" /mnt/internal_post_chroot.sh
cp "$dir/find_uuid.sh" /mnt/find_uuid.sh

echo "[pre_chroot] Changing system environment"
arch-chroot /mnt