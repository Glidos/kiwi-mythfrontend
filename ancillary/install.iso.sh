#!/bin/bash

cp MythTV/MythTV.x86_64-1.0.0.iso /tftpboot/image/MythTV.x86_64-1.0.0
systemctl restart vblade

mkdir iso
mount MythTV/MythTV.x86_64-1.0.0.iso iso
cp iso/boot/x86_64/loader/linux /tftpboot/boot
cp iso/boot/x86_64/loader/initrd /tftpboot/boot
umount iso
rmdir iso
