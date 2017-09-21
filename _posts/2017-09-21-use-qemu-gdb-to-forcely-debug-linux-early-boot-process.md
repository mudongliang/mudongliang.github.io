---
layout: post
title: "Use Qemu GDB to forcely debug Linux early boot process"
date: 2017-09-21
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Background

Several guides on the Internet suggest the following generic procedure when debugging the Linux boot process with GDB:

Start QEMU with the following debugging options:

```
$ qemu-system-$ARCH -kernel $IMAGE -S -s
```

where:

- `$IMAGE` is a bootable kernel image that should have been built with debugging info (at least, `CONFIG_DEBUG_INFO`).

- `-S` stalls QEMU CPU at startup.

- `-s` is shorthand for `-gdb tcp::1234`. This results in QEMU's GDB server listening on TCP port 1234 for a remote connection from a gdb(1) client.

Separately load the corresponding ELF vmlinux object in `gdb(1)` and then connect to the waiting QEMU GDB server:

```
$ gdb vmlinux
(gdb) target remote tcp::1234
```

## Problem

Now, depending on several factors including the target architecture, and the manner in which the QEMU guest kernel image gets loaded into the machine emulator's memory, this generic procedure may take certain variations. Consider the following case:

```
$ make x86_64_defconfig

$ make menuconfig ## to enable "CONFIG_DEBUG_INFO"

$ make -jN
```

```
$ qemu-system-x86_64 -kernel arch/x86/boot/bzImage -S -s
```

QEMU starts up in a "stopped" state (courtesy of `-S`), with the QEMU GDB server waiting for a connection (on TCP port 1234 courtesy of `-s`) from a remote `gdb(1)` client. Now, if the following `gdb(1)` client connection,

```
$ gdb -q vmlinux
Reading symbols from /tmp/qgdb/linux/vmlinux...done.

(gdb) target remote tcp::1234
Remote debugging using tcp::1234
0x0000000000000000 in ?? ()
breakpoint specification e.g.

(gdb) break parse_early_param 
Breakpoint 1 at 0xffffffff81cdba4d: file init/main.c, line 422.
and continue command

(gdb) c
Continuing.
result in QEMU resuming execution without ever stopping at the specified
breakpoints, and if further gdb(1) commands result in errors such as

<CTRL+C>
^CRemote 'g' packet reply is too long: 0000000000000000d81fc0[...]801f0000
(gdb)

(gdb) c
Continuing.
Remote 'g' packet reply is too long: 0000000000000000d81fc0[...]801f0000

(gdb) s
Remote 'g' packet reply is too long: 0000000000000000d81fc0[...]801f0000
then consider the following variation in procedure.
```

## Solution

How to hack the early boot process of Linux Kernel?

Please refer to Link 1 in Section [References](##References).

## References

[1] [http://nairobi-embedded.org/linux_boot_qemu_gdb.html](http://nairobi-embedded.org/linux_boot_qemu_gdb.html)

[2] [https://www.kernel.org/doc/html/v4.13/dev-tools/gdb-kernel-debugging.html](https://www.kernel.org/doc/html/v4.13/dev-tools/gdb-kernel-debugging.html)
