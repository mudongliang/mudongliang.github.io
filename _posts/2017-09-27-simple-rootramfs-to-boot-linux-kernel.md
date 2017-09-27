---
layout: post
title: "simple rootramfs to boot linux kernel"
date: 2017-09-27
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Procedure


### What is initramfs?

All 2.6 Linux kernels contain a gzipped "cpio" format archive, which is
extracted into rootfs when the kernel boots up.  After extracting, the kernel
checks to see if rootfs contains a file "init", and if so it executes it as PID
1.  If found, this init process is responsible for bringing the system the
rest of the way up, including locating and mounting the real root device (if
any).  If rootfs does not contain an init program after the embedded cpio
archive is extracted into it, the kernel will fall through to the older code
to locate and mount a root partition, then exec some variant of /sbin/init
out of that.

### How to create one simple initramfs

A good first step is to get initramfs to run a statically linked "hello world"
program as init, and test it under an emulator like qemu (www.qemu.org) or
User Mode Linux, like so:

```
cat > hello.c << EOF
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  printf("Hello world!\n");
  sleep(999999999);
}
EOF
gcc -static hello.c -o init
echo init | cpio -o -H newc | gzip > test.cpio.gz
# Testing external initramfs using the initrd loading mechanism.
qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r` -initrd test.cpio.gz

# use own building kernel to boot
qemu-system-x86_64 -kernel ~/Repos/linux/arch/x86/boot/bzImage -initrd test.cpio.gz


# use "--enable-kvm" to accelerate the boot speed
qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r` -initrd test.cpio.gz --enable-kvm

# use "-nographic" to disable gui
# ttyS0 valid on most PC
qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r` -initrd test.cpio.gz -nographic -append 'console=ttyS0'
```

After the kernel boots successfully, you will see "Hello World" at the bottom of qemu window.

Note: if you disable gui, you can switch to qemu console with ctrl-A + C + ENTER. Then you can exit by `quit` command in the qemu console. For more detail you can refer to [one blog](http://nairobi-embedded.org/qemu_monitor_console.html).

## Reference

[1] [https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)
