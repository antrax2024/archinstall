#!/bin/bash

source ./rainbow.sh

gA=$(echogreen "==>")

echo 'Do you partitioned the disk?'
read -r answer

if [ "$answer" != "${answer#[Yy]}" ]; then
	echo Yes
else
	exit
fi

echo "$gA Enter EFI partition: "
read -r EFI_PART

echo "$gA Enter ROOT partition: "
read -r ROOT_PART

echo "$gA Format $EFI_PART..."
mkfs.fat -F 32 "$EFI_PART"

echo "$gA Format $ROOT_PART..."
mkfs.ext4 "$ROOT_PART"

echo "$gA Mounting $ROOT_PART..."
mount "$ROOT_PART" /mnt

echo "$gA Mounting $EFI_PART..."
mkdir -p /mnt/boot/efi
mount "$EFI_PART" /mnt/boot/efi

echo "$gA Now, i will perform pacstrap."
echo "Press any key to continue..."
read -r -p

pacstrap -K /mnt base base-devel linux-zen linux-zen-headers amd-ucode linux-firmware \
	neovim git dosfstools grub efibootmgr os-prober networkmanager network-manager-applet man

echo "$gA Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

echo "Now, you can perform a arch-chroot /mnt..."
