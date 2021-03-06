# Moalis
My Own Arch Linux Installation Script.

Useful for those who want to install Arch Linux and rEFind on Btrfs.

## Usage
1. Connect to the Internet, configure your software mirrors, update system clock
2. Clone this repo
3. Partition, use any tool you want (e.g. `cfdisk`)
4. edit `./partition/post_part.sh`, modify the variables to meet your needs, then run it
5. run `./install/pre_chroot.sh`, and you will switch to the newly installed Arch Linux system
6. `cd /Moalis`
7. run `./post_chroot.sh`, and then exit the chroot environment
8. `umount -R /mnt && reboot`
9. Now you have rebooted to your system, ensure your system is connected to the Internet
10. run `./configure_basic.sh` to configure your system, or edit it to meet your needs before you run it.
11. run `./configure_software.sh` as a normal user to install softwares, or edit it to meet your needs before you run it.

**TIP:** It is recommended to use `less` to see the full outputs of each script. (e.g. `bash ./partition/post_part.sh | less`)

## License
[MIT](https://mit-license.org)
