#!/bin/bash

if [ ! -e ~/.cache/ ]; then
	mkdir -p ~/.cache/
fi	


if [ ! -e ~/.cache/start_chroot/ ]; then
	( cd ~/.cache/; git clone https://github.com/lordrasmus/start_chroot )
else
	( cd ~/.cache/start_chroot/; git pull )
fi

bash ~/.cache/start_chroot/start_chroot_real.sh
exit $?
