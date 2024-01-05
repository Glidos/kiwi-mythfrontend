#!/bin/bash

to_m () {
    echo $(( ($1 + 512 * 1024) / (1024 * 1024) ))
}

IMG=MythTV/MythTV.x86_64-1.0.0
KERNEL=MythTV/MythTV.x86_64-1.0.0*.kernel
INITRD=MythTV/MythTV.x86_64-1.0.0.initrd
DISC=MythTV/MythTV.x86_64-1.0.0.efi

IMG_SIZE=$(to_m $(stat -c "%s" $IMG))
KERNEL_SIZE=$(to_m $(stat -c "%s" $KERNEL))
INITRD_SIZE=$(to_m $(stat -c "%s" $INITRD))

PART1_SIZE=$(($KERNEL_SIZE + $INITRD_SIZE + 10))
DISC_SIZE=$(($PART1_SIZE + $IMG_SIZE + 10))

echo $IMG_SIZE $KERNEL_SIZE $INITRD_SIZE $DISC_SIZE

rm -f $DISC

echo "Create empty disc image"

dd if=/dev/zero of=$DISC bs=1M count=$DISC_SIZE status=progress

echo "Create partitions"

sfdisk $DISC << EOF
label: gpt
unit: sectors

1 : start=2048, size=$(($PART1_SIZE * 2048)), type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
2 : start=$(($PART1_SIZE * 2048 + 2048)), type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
EOF

losetup -P /dev/loop0 $DISC

echo "Create msdos file system"

mkfs.msdos /dev/loop0p1

echo "Copy across kernel, initrd and grub2"

mkdir part1
mount /dev/loop0p1 part1
cp $KERNEL part1/linux
cp $INITRD part1/initrd

mkdir part1/EFI
mkdir part1/EFI/linux
cp /usr/share/grub2/x86_64-efi/* part1/EFI/linux
cat > part1/EFI/linux/grub.cfg << EOF
set default="SSD"
set timeout=0

menuentry "SSD" {
	insmod part_gpt
	linux (hd0,gpt1)/linux root=overlay:UNIXNODE=sda2 drm.edid_firmware=HDMI-A-1:edid/marantz_edid.bin video=HDMI-A-1:D
	initrd (hd0,gpt1)/initrd
}
EOF

umount part1
rmdir part1

echo "Copy file system image directly to partion"
dd if=$IMG of=/dev/loop0p2 bs=1M status=progress

losetup -d /dev/loop0
