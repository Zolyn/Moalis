#!/bin/bash
set -e

dir=$(dirname $0)
HOSTNAME="arch"
CPU_BRAND="amd"

echo "[post_chroot] Setting hostname"
echo $HOSTNAME > /etc/hostname

echo "[post_chroot] Configuring hosts"
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain	$HOSTNAME
EOF
cat /etc/hosts

echo "[post_chroot] Setting timezone"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "[post_chroot] Syncing system clock"
hwclock --systohc

echo "[post_chroot] Configuring locale"
cat >> /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8"  > /etc/locale.conf

echo "[post_chroot] Installing ucode"
pacman -S "$CPU_BRAND-ucode" --confirm

echo "[post_chroot] Installing refind"
pacman -S refind --confirm
refind-install

echo "[post_chroot] Searching partition UUID"
ROOT_UUID=$(BLOCK_DEVICE=$ROOT_PART bash "$dir/find_uuid.sh")
SWAP_UUID=$(BLOCK_DEVICE=$SWAP_PART bash "$dir/find_uuid.sh")

if [ -z "$ROOT_UUID" ] || [ -z "$SWAP_UUID" ];then
    echo "Cannot find partition UUID"
    exit
fi

echo "[post_chroot] Replacing /boot/refind_linux.conf"
mv /boot/refind_linux.conf /boot/refind_linux.conf.bak
cat > /boot/refind_linux.conf << EOF
"Boot with standard options"  "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img"
"Boot to single-user mode"    "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img single"
"Boot with minimal options"   "ro root=$ROOT_UUID"
EOF
cat /boot/refind_linux.conf

echo "[post_part] Setting password for root"
passwd root

echo "[post_chroot] Done."