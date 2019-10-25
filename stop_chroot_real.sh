#!/bin/bash


if [ $UID -ne 0 ] ; then
	#echo $UID
	#sudo bash ${BASH_SOURCE[0]}
	echo "need root , start as root or sudo"
	exit 0
fi

if [ ! -e proc ] ; then
	echo "directory proc not found"
	exit 1
fi

umount proc
umount sys
umount dev/shm
umount dev/pts
umount dev
umount var/tmp



echo -e "\nstopped chroot\n"






