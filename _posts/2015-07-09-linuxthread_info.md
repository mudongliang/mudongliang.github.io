---
layout: post
title: "Linux内核的thread_info结构分析"
date: 2015-07-09
description: ""
category: 
tags: []
---

本文大部分转载自 ： [http://blog.chinaunix.net/uid-28453894-id-3534203.html](http://blog.chinaunix.net/uid-28453894-id-3534203.html)

对于每个进程，`Linux`内核都把两个不同的数据结构紧凑地存放在一个单独为进程分配的内存区域中：一个是内核态的进程堆栈，另一个是紧挨着进程描述符的小数据结构`thread_info`，叫做线程描述符。在较新的内核代码中，这个存储区域的大小通常为`8192`个字节（两个页框）。在 `linux/arch/x86/include/asm/page_32_types.h`中，

```
#define THREAD_SIZE_ORDER    1
#define THREAD_SIZE        (PAGE_SIZE << THREAD_SIZE_ORDER)
```

出于效率考虑，内核让这`8K`空间占据连续的两个页框并让第一个页框的起始地址是`2^13`的倍数。

内核态的进程访问处于内核数据段的栈，这个栈不同于用户态的进程所用的栈。用户态进程所用的栈，是在进程线程地址空间中；而内核栈是当进程从用户空间进入内核空间时，特权级发生变化，需要切换堆栈，那么内核空间中使用的就是这个内核栈。因为内核控制路径使用很少的栈空间，所以只需要几千个字节的内核态堆栈。需要注意的是，内核态堆栈仅用于内核例程，Linux内核另外提供了单独的硬中断栈和软中断栈。

下图中显示了在物理内存中存放两种数据结构的方式。线程描述符驻留与这个内存区的开始，而内核栈顶向下增长。下图摘自**ULK3**，但是较新的内核代码中，进程描述符`task_struct`结构中没有直接指向`thread_info`结构的指针，而是用一个`void *`类型的成员表示，然后通过类型转换来访问`thread_info`结构。相关代码在`include/linux/sched.h`中：

```
#define task_thread_info(task)    ((struct thread_info *)(task)->stack)
```

![thread_info]({{site.url}}/images/thread_info.gif)

在上图中，`esp`寄存器是`CPU`栈指针，用来存放栈顶单元的地址。在`80x86`系统中，栈起始于顶端，并朝着这个内存区开始的方向增长。从用户态刚切换到内核态以后，进程的内核栈总是空的。因此，`esp`寄存器指向这个栈的顶端。一旦数据写入堆栈，`esp`的值就递减。在`Linux3.5.4`内核中，`thread_info`结构是`72`个字节长（`ULK3`时代的内核中，这个结构的大小是52个字节），因此内核栈能扩展到`8120`个字节。`thread_info`结构的定义如下：

```
struct thread_info {
    struct task_struct    *task;           /* main task structure */
    struct exec_domain    *exec_domain;    /* execution domain */
    __u32            flags;                /* low level flags */
    __u32            status;               /* thread synchronous flags */
    __u32            cpu;                  /* current CPU */
    int            preempt_count;          /* 0 => preemptable, <0 => BUG */
    mm_segment_t            addr_limit;
    struct restart_block     restart_block;
    void __user             *sysenter_return;
#ifdef CONFIG_X86_32
    unsigned long previous_esp; /* ESP of the previous stack in
                                   case of nested (IRQ) stacks
                                   */
    __u8                supervisor_stack[0];
#endif
    unsigned int        sig_on_uaccess_error:1;
    unsigned int        uaccess_err:1;    /* uaccess failed */
};
```

`Linux`内核中使用一个联合体来表示一个进程的线程描述符和内核栈：

```
union thread_union {
    struct thread_info thread_info;
    unsigned long stack[THREAD_SIZE/sizeof(long)];
};
```

下面来说说如何通过`esp`栈指针来获取当前在`CPU`上正在运行进程的`thread_info`结构。实际上，上面提到，`thread_info`结构和内核态堆栈是紧密结合在一起的，占据两个页框的物理内存空间。而且，这两个页框的起始起始地址是`2^13`对齐的。所以，内核通过简单地屏蔽掉`esp`的低13位有效位就可以获得`thread_info`结构的基地址了。在文件`linux/arch/x86/include/asm/thread_info.h`中，有如下代码：

```
#ifndef __ASSEMBLY__
/* how to get the current stack pointer from C */
register unsigned long current_stack_pointer asm("esp") __used;
/* how to get the thread information struct from C */
static inline struct thread_info *current_thread_info(void)
{
    return (struct thread_info *)
        (current_stack_pointer & ~(THREAD_SIZE - 1));
}
#else /* !__ASSEMBLY__ */
/* how to get the thread information struct from ASM */
#define GET_THREAD_INFO(reg)     \
    movl $-THREAD_SIZE, reg; \
    andl %esp, reg
/* use this one if reg already contains %esp */
#define GET_THREAD_INFO_WITH_ESP(reg) \
    andl $-THREAD_SIZE, reg
#endif
```

在上面的代码中，当前的栈指针`current_stack_pointer`就是`esp`，
`THREAD_SIZE`为`8K`，二进制的表示为`0000 0000 0000 0000 0010 0000 0000 0000`。而 `~(THREAD_SIZE-1)`的结果刚好为`1111 1111 1111 1111 1110 0000 0000 0000`，第十三位是全为零，也就是刚好屏蔽了`esp`的低十三位，最终得到的是`thread_info`的地址。

进程最常用的是进程描述符结构`task_struct`而不是`thread_info`结构的地址。为了获取当前`CPU`上运行进程的`task_struct`结构，内核提供了`current`宏，该宏本质上等价于
`current_thread_info()->task`，在`include/asm-generic/current.h`中定义：

```
#define get_current() (current_thread_info()->task)
#define current get_current()
```

另外关于current的详细内容，可以参见kernelnewbies的FAQ：[current](http://kernelnewbies.org/FAQ/current)，[get_current](http://kernelnewbies.org/FAQ/get_current)
