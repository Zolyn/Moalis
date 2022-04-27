#!/bin/bash
set -e

dir=$(dirname $0)

echo "Installing system"
pacstrap /mnt base base-devel linux linux-firmware zsh zsh-completions git dhcpcd nano vim sudo

echo "Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

echo "Copying scripts"
cp "$dir/post_chroot.sh" /mnt/post_chroot.sh
cp "$dir/find_uuid.sh" /mnt/find_uuid.sh

echo "Changing system environment"
arch-chroot /mnt