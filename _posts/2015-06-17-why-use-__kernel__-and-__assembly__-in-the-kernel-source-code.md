---
layout: post
title: "Why use __KERNEL__ and __ASSEMBLY__ in the kernel source code?"
date: 2015-06-17
description: ""
category: 
tags: []
---

From Why use `__KERNEL__` and `__ASSEMBLY__` in the kernel source code?

## Question:
Why use following macros in the kernel source code?

1)

    #ifdef __KERNEL__
    
    ...code...

    #endif /* __KERNEL__ */

2)

    #ifdef __ASSEMBLY__
    
    ...code...
    
    #endif /* __ASSEMBLY__ */

## Answer:

Those are for kernel headers. In some cases user space programs/libraries use the kernel headers. To make them run/compile/see only things they need, there is the `__KERNEL__` macro. It is defined during the kernel compilation.

It is very similar with `__ASSEMBLY__`. Assembly source uses some kernel headers. Some things are not valid in assembly, however (like C functions...).The macro is defined for assembly code and allows to mark the part of the definitions that is needed in assembly.

In general, you do not have to use those if nobody complains. If it is needed, you will get notified.
