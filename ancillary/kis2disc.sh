#!/bin/bash

to_m () {
    echo $(( ($1 + 512 * 1024) / (1024 * 1024) ))
}

IMG=MythTV/MythTV.x86_64-1.0.0
KERNEL=MythTV/MythTV.x86_64-1.0.0*.kernel
INITRD=MythTV/MythTV.x86_64-1.0.0.initrd
DISC=MythTV/MythTV.x86_64-1.0.0.disc

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
label: dos
unit: sectors

1 : start=2048, size=$(($PART1_SIZE * 2048)), type=c
2 : start=$(($PART1_SIZE * 2048 + 2048)), type=83
EOF

losetup -P /dev/loop0 $DISC

echo "Create msdos file system"

mkfs.msdos /dev/loop0p1

echo "Copy across kernel and initrd"

mkdir part1
mount /dev/loop0p1 part1
cp $KERNEL part1/linux
cp $INITRD part1/initrd
umount part1
rmdir part1

echo "Copy file system image directly to partion"
dd if=$IMG of=/dev/loop0p2 bs=1M status=progress

losetup -d /dev/loop0
