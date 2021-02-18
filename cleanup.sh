#!/bin/bash
umount root/proc
umount root/sys
umount root/dev/pts
umount root/dev
rm --one-file-system -r ./root/
