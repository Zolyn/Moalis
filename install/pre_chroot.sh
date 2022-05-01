#!/bin/bash
set -e

log() {
    echo "[Moalis:pre_chroot] $1"
}

dir=$(dirname $0)

log "Installing system"
pacstrap /mnt base base-devel linux linux-firmware git dhcpcd nano vim sudo networkmanager

log "Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

log "Copying scripts"
cp "$dir/post_chroot.sh" /mnt/internal_post_chroot.sh
cp "$dir/find_uuid.sh" /mnt/find_uuid.sh

log "Changing system environment"
arch-chroot /mnt