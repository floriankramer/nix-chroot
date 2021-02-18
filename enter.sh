#!/bin/bash

if [ $(id -u) -ne 0 ] ; then
  echo "This script needs to be run as root"
  exit 1
fi

mount -t proc proc root/proc/
mount -o bind /sys root/sys/
mount -o bind /dev root/dev/
mount -t devpts pts root/dev/pts/
chroot root /bin/bash -l -c 'su -l user'
umount root/proc
umount root/sys
umount root/dev/pts
umount root/dev
