#!/bin/bash
readonly BOOTISO="FreeDOS.iso"
readonly PARTED="parted -s"
readonly freeDosSrcIso="fd11src.iso"
readonly memdisk="/mnt/fdos/memdisk"
readonly FREEDOS="/mnt/fdos/freedos"

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

sudo find ${FREEDOS}/freedos/packages/base/*.zip | sudo xargs -l unzip -d ${memdisk}/fdos
sudo unzip ${FREEDOS}/freedos/packages/boot/syslnxx.zip -d ${memdisk}/fdos

sudo cp syslinux.cfg ${memdisk}/
sudo cp autoexec.bat ${memdisk}/
sudo cp config.sys   ${memdisk}/

sync ; sync ; sync;
sudo umount ${memdisk}
sudo umount ${FREEDOS}

sudo kpartx -d ${BOOTISO}
