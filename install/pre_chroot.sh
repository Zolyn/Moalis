#!/bin/bash
set -e

log() {
    echo "[Moalis:pre_chroot] $1"
}

dir=$(dirname $0)

log "Installing system"
pacstrap /mnt base base-devel linux linux-firmware git dhcpcd nano vi vim sudo networkmanager btrfs-progs

log "Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

log "Copying scripts"
cp "$dir/post_chroot.sh" /mnt/Moalis/internal_post_chroot.sh
cp "$dir/find_uuid.sh" /mnt/Moalis/find_uuid.sh
cp "$dir/../configure/configure_basic.sh" /mnt/Moalis/configure_basic.sh
cp "$dir/../configure/configure_software.sh" /mnt/Moalis/configure_software.sh

log "Copying patches"
cp -r "$dir/../patches" /mnt/Moalis

log "Changing system environment"
arch-chroot /mnt