---
layout: post
title: "Debian enable kernel dump"
date: 2018-07-02
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Introduction to kdump

**Kdump** is a kernel crash dumping mechanism that allows you to save the contents of the system’s memory for later analysis. It relies on `kexec`, which can be used to boot a Linux kernel from the context of another kernel, bypass BIOS, and preserve the contents of the first kernel’s memory that would otherwise be lost.

In case of a system crash, `kdump` uses `kexec` to boot into a second kernel (a capture kernel). This second kernel resides in a reserved part of the system memory that is inaccessible to the first kernel. The second kernel then captures the contents of the crashed kernel’s memory (a crash dump) and saves it.

## Installation

1. `sudo apt-get install kdump-tools crash kexec-tools makedumpfile $(uname -r)-dbg`
2. Check `USE_KDUMP=1` in `/etc/default/kdump-tools`
3. Check `crashkernel=384M-:128M`
4. If you modify the kernel command-line given in bootloader configuration, `sudo update-grub`

## Ensure Kernel Configuration

Make sure your kernel configuration has the following entries:

```
CONFIG_RELOCATABLE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_DEBUG_INFO=y
```

## Verify that the crash kernel is loaded

```
cat /sys/kernel/kexec_crash_loaded
```

## Test that the crash kernel is loaded

```
sudo sync; echo c | sudo tee /proc/sysrq-trigger
```

Use the `crash` tool to look at the resulting crash dump


## References

[1] <https://superuser.com/questions/280767/how-can-i-enable-kernel-crash-dumps-in-debian>

[2] <https://github.com/mudongliang/Language_Programming/tree/master/C/KernelModule/helloworld>

[3] <https://help.ubuntu.com/lts/serverguide/kernel-crash-dump.html>

[4] <https://www.kernel.org/doc/Documentation/kdump/kdump.txt>

[5] <https://github.com/gurugio/linuxdeveloptip/blob/master/qemu-gdb-kdump.md>

[6] <https://www.dedoimedo.com/computers/crash-analyze.html#mozTocId45838>
