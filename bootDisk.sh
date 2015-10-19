#!/bin/bash
# Script to create FreeDOS live CD
# ref: 
# http://www.chtaube.eu/computers/freedos/bootable-usb/image-generation-howto/
# http://www.chtaube.eu/computers/freedos/bootable-usb/

readonly BOOTISO="FreeDOS.iso"
readonly PARTED="parted -s"
readonly freeDosSrcIso="fd11src.iso"
readonly memdisk="/mnt/fdos/memdisk"
readonly FREEDOS="/mnt/fdos/freedos"
readonly ISO_SRC="http://www.freedos.org/download/download/fd11src.iso"

# Download FreeDos CD image if it doesn't exist
[ -f "${freeDosSrcIso}" ] || wget -c "${ISO_SRC}"

# Create image
dd if=/dev/zero of=${BOOTISO} bs=1M count=100

# Give bootable partition
${PARTED} ${BOOTISO} unit %
${PARTED} ${BOOTISO} mklabel msdos
${PARTED} ${BOOTISO} mkpart primary fat16 0 100%
${PARTED} ${BOOTISO} set 1 boot on  
# Access partition with kpartx
readonly loopdevice="/dev/mapper/$( sudo kpartx -av ${BOOTISO} | awk '{ print $3}' )"

# Make filesystem & install syslinux bootloader
mkfs.msdos -F 16 -n FREEDOS ${loopdevice}
syslinux -i ${loopdevice}

# Mount file system
[ ! -d "${memdisk}" ] && sudo mkdir -p ${memdisk}
sudo mount ${loopdevice} ${memdisk}
[ ! -d "${memdisk}/fdos" ] && sudo mkdir -p ${memdisk}/fdos

sudo mkdir -p ${FREEDOS}
sudo mount -o ro,loop ${freeDosSrcIso} ${FREEDOS}

# Extract necessary files
sudo find ${FREEDOS}/freedos/packages/base/*.zip | sudo xargs -l unzip -d ${memdisk}/fdos
sudo unzip ${FREEDOS}/freedos/packages/boot/syslnxx.zip -d ${memdisk}/fdos

# Add syslinux.cfg, autoexec.bat and config.sys
sudo cp syslinux.cfg ${memdisk}/
sudo cp ${memdisk}/fdos/autoexec.txt ${memdisk}/autoexec.bat
sudo cp ${memdisk}/fdos/config.txt   ${memdisk}/config.sys

# Unmount all images
sync ; sync ; sync;
sudo umount ${memdisk}
sudo umount ${FREEDOS}
sudo kpartx -d ${BOOTISO}
