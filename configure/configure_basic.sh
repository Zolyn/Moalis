#!/bin/bash
set -e

log() {
    echo "[Moalis:configure_basic] $1"
}

dir=$(dirname $0)
USERNAME="zorin"

log "Adding user $USERNAME"
useradd -m -G wheel -s /bin/bash $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

log "Setting password for user $USERNAME"
passwd $USERNAME

log "Configuring pacman"
patch /etc/pacman.conf "$dir/patches/pacman_conf.patch"

pacman -Syu --noconfirm
pacman -S archlinuxcn-keyring --noconfirm

log "Fixing archlinuxcn-keyring"
pacman -Syu haveged --noconfirm
systemctl start haveged
systemctl enable haveged

rm -fr /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate archlinuxcn

log "Installing X server"
pacman -S xorg xorg-server --noconfirm

log "Installing graphic card drivers"
pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon --noconfirm

log "Installing LightDM"
pacman -S lightdm lightdm-webkit2-greeter --noconfirm

log "Patching LightDM config"
patch /etc/lightdm/lightdm.conf "$dir/patches/lightdm_conf.patch"

log "Installing paru"
pacman -S paru --noconfirm

log "Modifying systemd config"
echo "DefaultTimeoutStopSec=30" >> /etc/systemd/system.conf
systemctl daemon-reload

# Do not uncomment here unless you have already installed DE/WM.
#log "Setting up LightDM service"
#systemctl enable lightdm

log "Switching user"
su $USERNAME
