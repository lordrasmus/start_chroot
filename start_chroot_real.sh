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

mount --bind $(pwd) $(pwd)

dir_mount     'proc'    'proc'
dir_mount     'sys'     'sysfs'
dir_mount     'dev'     'devtmpfs'
dir_mount_opt 'dev/shm' 'tmpfs'    'mode=1777'
dir_mount_opt 'dev/pts' 'devpts'   'gid=5'
dir_mount     'run'     'tmpfs'
dir_mount     'var/tmp' 'tmpfs'


echo ""
if [[ -L "$(pwd)/etc/resolv.conf" ]]; then
	dirname="none"
	dest=$(readlink etc/resolv.conf)
	#echo $dest
	if [[ "$dest" == "../"* ]] ; then
		dirname=$(dirname $dest | cut -d'/' -f2-)
		file=$(basename $dest) 
		
		mkdir -p $dirname
		dest=$dirname"/"$file
		cat /etc/resolv.conf > $dest
		echo -e "\033[01;32m *\033[00m $dest created"
	fi
	if [[ $dirname == "none" ]] ; then
		echo -e "\033[01;31m *\033[00m $dest not created"
	fi
else
	cat /etc/resolv.conf > $(pwd)/etc/resolv.conf
	echo -e "\033[01;32m *\033[00m created /etc/resolv.conf"
fi


echo -e "\n\033[01;32m *\033[00m starting chroot\n"
chroot .




