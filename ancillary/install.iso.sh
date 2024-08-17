#!/bin/bash

cp MythTV/MythTV.x86_64-1.0.0.iso /srv/tftpboot/image/MythTV.x86_64-1.0.0
systemctl restart vblade

mkdir iso
mount MythTV/MythTV.x86_64-1.0.0.iso iso
cp iso/boot/x86_64/loader/linux /srv/tftpboot/boot
cp iso/boot/x86_64/loader/initrd /srv/tftpboot/boot
umount iso
rmdir iso
