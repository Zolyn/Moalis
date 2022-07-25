#!/bin/bash
set -e

dir=$(dirname $0)
HOSTNAME="laptop"
CPU_BRAND="intel"
RESOLUTION="1366 768"

log() {
    echo "[Moalis:post_chroot] $1"
}

log "Setting hostname"
echo $HOSTNAME > /etc/hostname

log "Configuring hosts"
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain	$HOSTNAME
EOF
cat /etc/hosts

log "Setting timezone"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

log "Syncing system clock"
hwclock --systohc

log "Configuring locale"
cat >> /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

log "Installing ucode"
pacman -S "$CPU_BRAND-ucode" --noconfirm

log "Patching /etc/mkinitcpio.conf"
# patch /etc/mkinitcpio.conf "$dir/patches/mkinitcpio_amdgpu.patch"
patch /etc/mkinitcpio.conf "$dir/patches/mkinitcpio_intel_touchpad.patch"

log "Removing old refind configuration"
rm /boot/efi/EFI/refind/refind.conf

log "Installing refind"
pacman -S refind ntfs-3g --noconfirm
refind-install

log "Searching partition UUID"
ROOT_UUID=$(BLOCK_DEVICE=$ROOT_PART bash "$dir/find_uuid.sh")
SWAP_UUID=$(BLOCK_DEVICE=$SWAP_PART bash "$dir/find_uuid.sh")

if [ -z "$ROOT_UUID" ] || [ -z "$SWAP_UUID" ];then
    log "Cannot find partition UUID"
    exit
fi

log "Replacing /boot/refind_linux.conf"
mv /boot/refind_linux.conf /boot/refind_linux.conf.bak
cat > /boot/refind_linux.conf << EOF
"Boot with standard options"  "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img"
"Boot to single-user mode"    "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img single"
"Boot with minimal options"   "ro root=$ROOT_UUID"
EOF
cat /boot/refind_linux.conf

echo "Configuring rEFind"
cat >> /boot/efi/EFI/refind/refind.conf << EOF
resolution $RESOLUTION
extra_kernel_version_strings linux-hardened,linux-zen,linux-lts,linux
also_scan_dirs boot,ESP2:EFI/linux/kernels,@/boot
EOF

# cp /usr/share/refind/drivers_x64/btrfs_x64.efi /boot/efi/EFI/refind/drivers_x64/btrfs_x64.efi
ls -ahl /boot/efi/EFI/refind/drivers_x64/

log "Setting dhcpcd"
systemctl enable dhcpcd

log "Setting password for root"
passwd root

log "Regenerating initramfs image"
mkinitcpio -P

log "Done."
