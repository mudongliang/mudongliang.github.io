---
layout: post
title: "Linux 地址空间分布随机化(ASLR) 关闭与程序测试"
date: 2015-06-13
description: ""
category: 
tags: []
---

关闭 Linux 内存地址随机化机制, 禁用进程地址空间随机化.可以将进程的mmap的基址，stack和vdso页面地址固定下来. 可以通过设置`kernel.randomize_va_space`内核参数来设置内存地址随机化的行为.

目前randomize_va_space的值有三种，分别是[0, 1, 2]

- 0 - 表示关闭进程地址空间随机化。
- 1 - 表示将mmap的基址，stack和vdso页面随机化。
- 2 - 表示在1的基础上增加栈（heap）的随机化。

```sh
# echo 0 > /proc/sys/kernel/randomize_va_space 
```

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/test/get_sp.c)

```c
#include<stdio.h>

unsigned long sp(void){
    #if defined(__i386__)
        asm("mov %esp, %eax");
    #elif defined(__x86_64__)
        asm("mov %rsp, %rax");
    #endif
}

int main(int argc, const char *argv[])
{
	unsigned long esp = sp();
	printf("Stack pointer (ESP : 0x%lx)\n",esp);
	return 0;
}
```

See the result of this program  and you can see the functionality of ASLR.
Even you can guess the entropy of the ASLR applied to this system.
