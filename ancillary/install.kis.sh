#!/bin/bash

cp MythTV/MythTV.x86_64-1.0.0 /srv/tftpboot/image/MythTV.x86_64-1.0.0
systemctl restart nbd-server
cp MythTV/MythTV.x86_64-1.0.0*.kernel /srv/tftpboot/boot/linux
cp MythTV/MythTV.x86_64-1.0.0.initrd /srv/tftpboot/boot/initrd
