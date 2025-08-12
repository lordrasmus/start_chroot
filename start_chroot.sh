#!/bin/bash

#if [ ! -e ~/.cache/ ]; then
#	mkdir -p ~/.cache/
#fi	


if [ ! -e /usr/local/start_chroot/ ]; then
	( cd /usr/local/; git clone git@github.com:lordrasmus/start_chroot.git )
else
	( cd /usr/local/start_chroot/; git pull )
fi

bash /usr/local/start_chroot/start_chroot_real.sh
exit $?
