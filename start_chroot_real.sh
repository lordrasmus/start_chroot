
mount -t proc none proc
mount -t sysfs none sys
mount -t devtmpfs none dev
mount -o gid=5 -t devpts none  /dev/pts
mount -o mode=1777 -t tmpfs  none /dev/shm
chroot .
