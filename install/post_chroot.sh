#!/bin/bash
set -e

HOSTNAME="arch"
CPU_BRAND="amd"

find_uuid() {
    partinfo=$(blkid | grep $1)
    index=1

    while true
    do
      fragment=$(echo "$partinfo" | awk -F ' ' '{print $'$index'}')
      uuid=$(echo "$fragment" | grep "UUID")
      echo "$fragment"

      if [ -n "$uuid" ];then
        break
      fi

      if [ -z "$fragment" ];then
        break
      fi

      ((index++))
    done

    if [ -z "$uuid" ];then
      0
    else
      $uuid
    fi
}

echo "Setting hostname"
echo $HOSTNAME > /etc/hostname

echo "Configuring hosts"
cat >> /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain	$HOSTNAME
EOF
cat /etc/hosts

echo "Setting timezone"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "Syncing system clock"
hwclock --systohc

echo "Configuring locale"
cat >> /etc/locale.gen << EOF
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8"  > /etc/locale.conf

echo "Installing ucode"
pacman -S "$CPU_BRAND-ucode" --confirm

echo "Installing refind"
pacman -S refind --confirm
refind-install

echo "Searching partition UUID"
ROOT_UUID=$(blkid | grep $ROOT_PART | awk -F '[ :]' '{print $3}')
SWAP_UUID=$(blkid | grep $SWAP_PART | awk -F '[ :]' '{print $3}')

echo "Replacing /boot/refind_linux.conf"
mv /boot/refind_linux.conf /boot/refind_linux.conf.bak
cat > /boot/refind_linux.conf << EOF
"Boot with standard options"  "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img"
"Boot to single-user mode"    "root=$ROOT_UUID rw rootflags=subvol=@ loglevel=5 nowatchdog resume=$SWAP_UUID initrd=@\boot\\$CPU_BRAND-ucode.img initrd=@\boot\initramfs-%v.img single"
"Boot with minimal options"   "ro root=$ROOT_UUID"
EOF
cat /boot/refind_linux.conf

echo "[post_chroot] Done."