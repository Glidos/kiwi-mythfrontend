#!/bin/bash

cp MythTV/MythTV.x86_64-1.0.0 /tftpboot/image/MythTV.x86_64-1.0.0
systemctl restart vblade
cp MythTV/MythTV.x86_64-1.0.0*.kernel /tftpboot/boot/linux
cp MythTV/MythTV.x86_64-1.0.0.initrd /tftpboot/boot/initrd
