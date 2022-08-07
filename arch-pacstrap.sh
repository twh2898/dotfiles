#!/bin/bash

pacman -Sy --noconfirm --needd archlinux-keyring

pacstrap /mnt base linux linux-firmware base-devel git vi vim networkmanager sudo

arch-chroot /mnt systemctl enable NetworkManager.service
