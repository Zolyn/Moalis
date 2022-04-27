#!/bin/bash
set -e

dir=$(dirname $0)

echo "Installing system"
pacstrap /mnt base base-devel linux linux-firmware zsh zsh-completions dhcpcd nano vim sudo

echo "Generating fstab"
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

echo "Copying scripts"
cp $dir/post_chroot.sh /mnt/post_chroot.sh

echo "Changing system environment"
arch-chroot /mnt