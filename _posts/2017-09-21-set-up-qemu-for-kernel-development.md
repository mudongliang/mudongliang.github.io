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

Create one Debian image as rootfs. Two methods are in the following:

### Method One

Use [one script in syzkaller](https://github.com/google/syzkaller/blob/master/tools/create-image.sh) to generate debian image. It could generate wheezy, jessie, stretch release.

However, for jessie or above releases, you need to take care of kernel configuration. See [another post](https://mudongliang.github.io/2019/02/08/syzkaller-stretch-image-troubleshooting.html)

### Method Two

```
IMG=test_stretch.img
DIR=stretch
qemu-img create $IMG 1g
sudo mkfs.ext4 $IMG
mkdir -p $DIR
sudo mount -o loop $IMG $DIR
sudo debootstrap --arch amd64 stretch $DIR
sudo umount $DIR
rmdir $DIR
```
The above instruction sequence is copied from Reference 1.

There is no error message when creating rootfs. At last, I try to boot one kernel with that rootfs.

## Experiment

### Test on the current kernel

```
$ qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r` \
-hda qemu-image.img -append "console=ttyS0 root=/dev/sda"
```

**Result:**

Succeed in both Debian and Ubuntu

### Test on own building kernel

```
$ git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
$ cd linux
$ make x86_64_defconfig
$ make kvmconfig
$ make -j4

$ qemu-system-x86_64 -kernel linux/arch/x86/boot/bzImage \
-hda qemu-image.img -append "console=ttyS0 root=/dev/sda"
```

**Result:**

Succeed in Both Ubuntu and Debian

### Other options

You could use options `--enable-kvm`(speed up with KVM) and `--nographic`(without GUI).

## References

[1] [Set up qemu for kernel development](https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/)
