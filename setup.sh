#!/bin/bash

set -eEuo pipefail

if [ $(id -u) -ne 0 ] ; then
  echo "This script needs to be run as root"
  exit 1
fi

if [ -d root ] ; then
  echo "The system is already setup, please delete the root folder if you"
  echo "want a fresh install."
fi

# Download alpine if required
if ! [ -f alpine-minirootfs-3.13.2-x86_64.tar.gz ] ; then
  wget https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86_64/alpine-minirootfs-3.13.2-x86_64.tar.gz
fi


# create the new root folder
mkdir root

# Decompress the base system
pushd root > /dev/null
tar -xaf ../alpine-minirootfs-3.13.2-x86_64.tar.gz
popd > /dev/null

# Setup name resolution
cp /etc/resolv.conf root/etc/resolv.conf

# Run the init script
cp ./bashrc root/tmp/
cp ./_init_new_system.sh root/tmp/
mount -t proc proc root/proc/
mount -o bind /sys root/sys/
mount -o bind /dev root/dev/
mount -t devpts pts root/dev/pts/
chroot root /sbin/apk add --no-cache bash
chroot root /bin/bash -l /tmp/_init_new_system.sh
umount root/proc
umount root/sys
umount root/dev/pts
umount root/dev
