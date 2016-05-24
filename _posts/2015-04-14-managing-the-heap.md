---
layout: post
title: "堆管理"
date: 2015-04-14
description: ""
category: 
tags: []
---

关于堆分配的库函数，它们在底层调用的基本是brk系统调用！

brk -> sys_brk

它的源码在mm/mmap.c中，不过因为各种原因，内核的系统调用的写法发生了改变，用宏调用的方式重写了一遍！回归正题，sys_brk的源码中有很多函数调用，但是最重要的，也是含细节的函数就是do_brk了！这里面是十分详细的细节问题！还需要再好好读！

- [SYSCALL_DEFINE详解](http://blog.csdn.net/adaptiver/article/details/7175165)
- [linux内存管理之sys_brk实现分析](http://blog.csdn.net/beyondhaven/article/details/6636561)
- [Linux内核源代码情景分析——2.12  系统调用brk()](http://blog.sina.com.cn/s/blog_72a2ef140100pdea.html)
