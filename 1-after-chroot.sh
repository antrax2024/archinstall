#!/bin/bash

source ./rainbow.sh

gA=$(echogreen "==>")

echo "$gA Set timezone..."

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

echo "$gA Locale, hostname and hosts settings..."

nvim /etc/locale.gen
locale-gen

echo 'LANG=en_US.UTF-8' >/etc/locale.conf

echo 'KEYMAP=br-abnt2' >/etc/vconsole.conf

echo 'shadowBox' >/etc/hostname

echo '127.0.0.1 localhost' >/etc/hosts
echo '::1 localhost' >>/etc/hosts
echo '127.0.1.1 shadowBox' >>/etc/hosts

echo "$gA Password for user root..."
passwd

echo "$gA Add user antrax..."
useradd -m antrax
usermod -aG wheel antrax
echo "$gA Password for user antrax..."
passwd antrax

EDITOR=nvim visudo

echo "$gA Install grub..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "$gA Enable Network Manager..."
systemctl enable NetworkManager

echo "$gA Everything OK!"
