#!/bin/bash

source ./rainbow.sh

echogreen 'Do you partitioned the disk?'
read -r answer

if [ "$answer" != "${answer#[Yy]}" ]; then
	echo Yes
else
	exit
fi

loadkeys br-abnt2

echo "Enter EFI partition: "
read -r EFI_PART

echo "Enter ROOT partition: "
read -r ROOT_PART

echo ""
echogreen "Format $EFI_PART..."
mkfs.fat -F 32 "$EFI_PART"

echogreen "Format $ROOT_PART..."
mkfs.ext4 "$ROOT_PART"

echogreen "Mounting $ROOT_PART..."
mount "$ROOT_PART" /mnt

echogreen "Mounting $EFI_PART..."
mkdir -p /mnt/boot/efi
mount "$EFI_PART" /mnt/boot/efi

echoyellow "Now, i will perform pacstrap."
echogreen "Press any key to continue..."
read -r -p

pacstrap -K /mnt base base-devel linux-zen linux-zen-headers amd-ucode linux-firmware \
	neovim git dosfstools grub efibootmgr os-prober networkmanager network-manager-applet man

echoyellow "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

echogreen "Now, you can perform a arch-chroot /mnt..."
