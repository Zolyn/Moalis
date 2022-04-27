#!/bin/bash
set -e

LABEL="Arch"
EFI_PART="/dev/nvme0n1p6"
ROOT_PART="/dev/nvme0n1p7"
SWAP_PART="/dev/sdb2"

echo "Formatting partition"
mkswap -f $SWAP_PART
mkfs.btrfs -f -L $LABEL $ROOT_PART

echo "Mounting Btrfs partition"
mount -t btrfs -o compress=zstd $ROOT_PART /mnt

echo "Creating subvolumes"
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume list -p /mnt

echo "Unmounting Btrfs partition"
umount /mnt

echo "Mounting subvolumes"
mount -t btrfs -o subvol=/@,compress=zstd $ROOT_PART /mnt
mkdir /mnt/home
mount -t btrfs -o subvol=/@home,compress=zstd $ROOT_PART /mnt/home
mkdir -p /mnt/boot/efi
mount $EFI_PART /mnt/boot/efi
swapon $SWAP_PART

echo "Checking status"
df -h
free -h

echo "Writing parition info for script"
cat > /mnt/post_chroot_with_partinfo.sh << EOF
#!/bin/bash
set -e

ROOT_PART=$ROOT_PART SWAP_PART=$SWAP_PART bash post_chroot.sh
EOF

echo "[post_part] Done."
