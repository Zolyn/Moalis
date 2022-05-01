#!/bin/bash
set -e

log() {
    echo "[Moalis:post_part] $1"
}

LABEL="Arch"
EFI_PART="/dev/nvme0n1p6"
ROOT_PART="/dev/nvme0n1p7"
SWAP_PART="/dev/sdb2"

log "Formatting partition"
mkswap -f $SWAP_PART
mkfs.btrfs -f -L $LABEL $ROOT_PART
#mkfs.fat -F 32 $EFI_PART

log "Mounting Btrfs partition"
mount -t btrfs -o compress=zstd $ROOT_PART /mnt

log "Creating subvolumes"
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume list -p /mnt

log "Unmounting Btrfs partition"
umount /mnt

log "Mounting subvolumes"
mount -t btrfs -o subvol=/@,compress=zstd $ROOT_PART /mnt
mkdir /mnt/home
mount -t btrfs -o subvol=/@home,compress=zstd $ROOT_PART /mnt/home
mkdir -p /mnt/boot/efi
mount $EFI_PART /mnt/boot/efi
swapon $SWAP_PART

log "Checking status"
df -h
free -h

log "Writing parition info for script"
cat > /mnt/post_chroot.sh << EOF
#!/bin/bash
ROOT_PART=$ROOT_PART SWAP_PART=$SWAP_PART bash post_chroot.sh
EOF

log "Done."
