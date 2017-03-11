---
layout: post
title: "syscall wrapper in glibc"
date: 2017-03-10
description: ""
category: 
tags: []
---

最近在看 glibc 的源码，想要看一下 glibc 中的动态内存管理器 ptmalloc 是如何实现的。

刚才去看了 brk 和 sbrk 函数的实现，发现一些很有趣的地方。

brk 库函数的实现是在 `misc/brk.c`

```
/* sbrk.c expects this.  */
void *__curbrk;

/* Set the end of the process's data space to ADDR.
   Return 0 if successful, -1 if not.  */
int
__brk (void *addr)
{
  __set_errno (ENOSYS);
  return -1;
}
stub_warning (brk)

weak_alias (__brk, brk)
```

但是，当我们自己查看这个函数的时候，很明显，这个并不是真正的定义，至少并不是我们想找的那个。那么，这个函数是什么呢？

它其实是`brk`的一个`alias`，而且还是`weak alias`。换而言之，如果一个平台上没有定义自己的 brk ，那么就用这个。而且从上面的代码也可以看得出来，这个函数仅仅是处理了一下`errno`，别的什么都不做。

另外，关于`Glibc`中`weak alias`和`strong alias`的定义与含义，可以参考[博客](http://www.cnblogs.com/justinyo/archive/2013/03/12/2956438.html)以及 [Stack Overflow 上的一个回答](http://stackoverflow.com/questions/34892601/what-does-the-weak-alias-function-do-and-where-is-it-defined)

现在问题来了，`brk`的真正定义位置是在哪里呢？

经过了一番搜索，我找到了一些资料：

- [stack overflow 上的回答](http://stackoverflow.com/questions/6515583/where-are-syscalls-located-in-glibc-source)
- [glibc定义的系统调用](http://wangcong.org/2010/04/27/glibc-e5-ae-9a-e4-b9-89-e7-9a-84-e7-b3-bb-e7-bb-9f-e8-b0-83-e7-94-a8/)
- [CSDN Blog](http://blog.csdn.net/zhb_sh/article/details/7017654)

```
sysdeps/unix/make-syscalls.sh
sysdeps/unix/syscalls.list（sysdeps/unix/inet/syscalls.list）
sysdeps/unix/syscall-template.S
```

其中，`make-syscalls.sh`就是用模板和那个列表来构建生成系统调用定义。

首先，这个`shell`脚本要从`sysdir`中对应`syscall`的定义，这些`sysdir`如下所示：

- sysdeps/unix/sysv/linux
- sysdeps/posix
- sysdeps/x86_64 (My CPU Arch is x86_64).

那么我们现在就找一下 brk 的真正定义位置。

```
glibc/sysdeps$ find . -name brk.[cS] -print
./unix/sysv/linux/x86_64/brk.c
./unix/sysv/linux/hppa/brk.c
./unix/sysv/linux/sh/brk.c
./unix/sysv/linux/microblaze/brk.c
./unix/sysv/linux/mips/brk.c
./unix/sysv/linux/alpha/brk.S
./unix/sysv/linux/m68k/brk.c
./unix/sysv/linux/generic/brk.c
./unix/sysv/linux/s390/brk.c
./unix/sysv/linux/sparc/sparc64/brk.S
./unix/sysv/linux/sparc/sparc32/brk.c
./unix/sysv/linux/i386/brk.c
./unix/sysv/linux/ia64/brk.S
./unix/sysv/linux/powerpc/powerpc32/brk.S
./unix/sysv/linux/powerpc/powerpc64/brk.S
./unix/sysv/linux/arm/brk.c
./mach/hurd/brk.c
./nacl/brk.c
```

```
/* This must be initialized data because commons can't have aliases.  */
void *__curbrk = 0;

int
__brk (void *addr)
{
  void *newbrk;

  __curbrk = newbrk = (void *) INLINE_SYSCALL (brk, 1, addr);

  if (newbrk < addr)
    {
      __set_errno (ENOMEM);
      return -1;
    }

  return 0;
}
weak_alias (__brk, brk)
```

从上面看出，针对我的系统框架，`brk`的定义在`sysdeps/unix/sysv/linux/x86_64/brk.c`中，

其次，如果某些 syscall 没有对应的`.c`或`.S`文件的话，就需要以 模板文件(`syscall-template.S`)以及系统调用列表来创建对应的系统调用定义。
