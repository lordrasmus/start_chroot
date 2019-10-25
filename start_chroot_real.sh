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

function dir_mount {
	grep "$(pwd)/$1" /proc/mounts > /dev/null
	if [ ! 0 -eq $? ] ; then
		echo -e "\033[01;32m *\033[00m mount /$1 ( $2 )"
		mount -t $2 none $1
	fi
}

function dir_mount_opt {
	grep "$(pwd)/$1" /proc/mounts > /dev/null
	if [ ! 0 -eq $? ] ; then
		echo -e "\033[01;32m *\033[00m mount /$1 ( $2 , $3)"
		mount -o $3 -t $2 none $1
	fi
}





echo -e "\n\033[01;32m *\033[00m init chroot\n"

dir_mount     'proc'    'proc'
dir_mount     'sys'     'sysfs'
dir_mount     'dev'     'devtmpfs'
dir_mount_opt 'dev/shm' 'tmpfs'    'mode=1777'
dir_mount_opt 'dev/pts' 'devpts'   'gid=5'
dir_mount     'var/tmp' 'tmpfs'


echo ""
if [[ -L "$(pwd)/etc/resolv.conf" ]]; then
	dest=$(readlink -f  etc/resolv.conf)
	cat /etc/resolv.conf > $dest
	echo -e "\033[01;32m *\033[00m $dest created"
else
	cat /etc/resolv.conf > $(pwd)/etc/resolv.conf
	echo -e "\033[01;32m *\033[00m created /etc/resolv.conf"
fi


echo -e "\n\033[01;32m *\033[00m starting chroot\n"
chroot .




