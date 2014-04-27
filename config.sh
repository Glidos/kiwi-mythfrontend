#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#======================================
# Activate services
#--------------------------------------
suseInsertService sshd
if [[ ${kiwi_type} =~ oem|vmx ]];then
    suseInsertService grub_config
else
    suseRemoveService grub_config
fi

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3


suseInsertService ntpd

ldconfig

chmod +s /usr/bin/Xorg
patch -p 0 -i /patches/xorg.patch

baseUpdateSysConfig /etc/sysconfig/lirc LIRCD_DRIVER devinput
baseUpdateSysConfig /etc/sysconfig/lirc LIRCD_DEVICE /dev/input/by-id/usb-Philips_eHome_Infrared_Transceiver_PH00YzQQ-event-if00

suseInsertService lircd

ln -s /etc/systemd/system/mythfrontend@.service /etc/systemd/system/getty.target.wants/getty@tty8.service
mkdir /etc/systemd/system/remote-fs.target.wants
ln -s /etc/systemd/system/home-mythfrontend-music.mount /etc/systemd/system/remote-fs.target.wants/home-mythfrontend-music.mount
ln -s /etc/systemd/system/home-mythfrontend-photos.mount /etc/systemd/system/remote-fs.target.wants/home-mythfrontend-photos.mount
ln -s /etc/systemd/system/home-mythfrontend-.mythtv.mount /etc/systemd/system/remote-fs.target.wants/home-mythfrontend-.mythtv.mount

#==========================================
# remove package docs
#------------------------------------------
rm -rf /usr/share/doc/packages/*
rm -rf /usr/share/doc/manual/*
rm -rf /opt/kde*

#======================================
# only basic version of vim is
# installed; no syntax highlighting
#--------------------------------------
sed -i -e's/^syntax on/" syntax on/' /etc/vimrc

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

#======================================
# Remove yast if not in use
#--------------------------------------
suseRemoveYaST

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
