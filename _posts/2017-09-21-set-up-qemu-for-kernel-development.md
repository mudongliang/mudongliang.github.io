---
layout: post
title: "set up qemu for kernel development"
date: 2017-09-21
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Preparation

```
~/Qemu/test-debootstrap$ ls
create.sh
~/Qemu/test-debootstrap$ cat create.sh
#!/bin/bash

IMG=qemu-image.img
DIR=mount-point.dir
qemu-img create $IMG 1g
sudo mkfs.ext2 $IMG
mkdir $DIR
sudo mount -o loop $IMG $DIR
sudo debootstrap --arch amd64 jessie $DIR
sudo umount $DIR
rmdir $DIR
```

Note: I add `sudo` before `mkfs.ext2`, or it could not work.

```
~/Qemu/test-debootstrap$ ./create.sh
./create.sh 
Formatting 'qemu-image.img', fmt=raw size=1073741824
[sudo] password for mdl: 
mke2fs 1.43.6 (29-Aug-2017)
Discarding device blocks: done                            
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 2f04ec87-c64a-417f-836e-379ee7a1f17a
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

I: Retrieving InRelease 
I: Retrieving Release 
I: Retrieving Release.gpg 
I: Checking Release signature
......
I: Configuring iputils-ping...
I: Configuring isc-dhcp-common...
I: Configuring isc-dhcp-client...
I: Configuring tasksel...
I: Configuring tasksel-data...
I: Configuring libc-bin...
I: Configuring systemd...
I: Base system installed successfully.
```

There is no error message when creating rootfs.

At last, I try to boot one kernel with that rootfs.

```
~/Qemu/test-debootstrap$ ls
create.sh  qemu-image.img

# current kernel
~/Qemu/test-debootstrap$ qemu-system-x86_64 -kernel /boot/vmlinuz-4.12.0-2-amd64 \
-drive file=qemu-image.img,index=0,media=disk,format=raw -append "root=/dev/sda single"

# own building kernel

~/Qemu/test-debootstrap$ qemu-system-x86_64 -kernel ~/Repos/linux/arch/x86/boot/bzImage \
-drive file=qemu-image.img,index=0,media=disk,format=raw -append "root=/dev/sda single"
```

## Result

I try to set up qemu according to the instruction in the [References](##Refereces), but failed. I will try my best to figure out reason and finish writing this post.

## References

[1] [Set up qemu for kernel development](https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/)


