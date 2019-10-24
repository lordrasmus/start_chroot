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

grep "$(pwd)/proc proc" /proc/mounts > /dev/null
if [ ! 0 -eq $? ] ; then
	echo "mount proc ( proc )"
	mount -t proc none proc
fi

grep "$(pwd)/sys sysfs" /proc/mounts > /dev/null
if [ ! 0 -eq $? ] ; then
	echo "mount sys ( sysfs )"
	mount -t sysfs none sys
fi

grep "$(pwd)/dev devtmpfs" /proc/mounts > /dev/null
if [ ! 0 -eq $? ] ; then
	echo "mount dev ( devtmpfs ) "
	mount -t devtmpfs none dev
fi

grep "$(pwd)/dev/shm tmpfs" /proc/mounts > /dev/null
if [ ! 0 -eq $? ] ; then
	echo "mount dev/shm ( tmpfs ) "
	mount -o mode=1777 -t tmpfs  none dev/shm
fi

grep "$(pwd)/dev/pts devpts" /proc/mounts > /dev/null
if [ ! 0 -eq $? ] ; then
	echo "mount dev/pts ( devpts ) "
	mount -o gid=5 -t devpts none  dev/pts
fi

if [[ -L "$(pwd)/etc/resolv.conf" ]]; then
	echo "/etc/resolv.conf symlink not suported"
	exit 1
else
	cat /etc/resolv.conf > $(pwd)/etc/resolv.conf
fi


chroot .


