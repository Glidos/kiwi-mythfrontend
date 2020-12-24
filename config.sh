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
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Activate services
#--------------------------------------
suseInsertService sshd

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3


suseInsertService ntpd

ldconfig

chmod +s /usr/bin/Xorg
patch -p 0 -i /patches/xorg.patch

baseUpdateSysConfig /etc/sysconfig/network/config NETCONFIG_DNS_STATIC_SEARCHLIST "site"
baseUpdateSysConfig /etc/sysconfig/network/config NETCONFIG_DNS_STATIC_SERVERS "10.0.0.5"

baseUpdateSysConfig /etc/sysconfig/lirc LIRCD_DRIVER devinput
baseUpdateSysConfig /etc/sysconfig/lirc LIRCD_DEVICE /dev/input/by-id/usb-Philips_eHome_Infrared_Transceiver_PH00YzQQ-event-if00

suseInsertService lircd

ln -s /etc/systemd/system/mythfrontend@.service /etc/systemd/system/getty.target.wants/getty@tty8.service
mkdir /etc/systemd/system/remote-fs.target.wants

ln -s /etc/systemd/system/home-mythfrontend-.mythtv.mount /etc/systemd/system/remote-fs.target.wants/home-mythfrontend-.mythtv.mount

update-alternatives --auto libglx.so
