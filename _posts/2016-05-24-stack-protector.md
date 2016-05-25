---
layout: post
title: "GCC Stack Protector options"
date: 2016-05-24
description: ""
category: 
tags: []
---

# GCC Stack Protector options

The following options come from [GCC4.9.3 Manual](https://gcc.gnu.org/onlinedocs/gcc-4.9.3/gcc/Optimize-Options.html)

### -fno-stack-protector
Disable Stack Protector Check

### -fstack-protector
Emit extra code to check for buffer overflows, such as stack smashing attacks. This is done by adding a guard variable to functions with vulnerable objects. This includes functions that call alloca, and functions with buffers larger than 8 bytes. The guards are initialized when a function is entered and then checked when the function exits. If a guard check fails, an error message is printed and the program exits.

### -fstack-protector-all
Like -fstack-protector except that all functions are protected.

### -fstack-protector-strong
Like -fstack-protector but includes additional functions to be protected — those that have local array definitions, or have references to local frame addresses. 

**Comment 1**: The 8 bytes can be configured by "--param=ssp-buffer-size=N" N=8 by default in GCC upstream. Various distributions ended up lowering their default --param=ssp-buffer-size option down to 4, since there were still cases of functions that should have been protected but the conservative gcc upstream default of 8 wasn’t covering them.

**Comment 2**: Overflow doesn't always happen in buffer, for example, member in struct can be a target of overflow. This kind of overflow can't be protected by `-fstack-protector`.

**Comment 3**:

- perforamce: -fstack-protector > -fstack-protector-strong > -fstack-protector-all
- coverage:   -fstack-protector < -fstack-protector-strong < -fstack-protector-all

**Comment 4**:
From [References 2](https://outflux.net/blog/archives/2014/01/27/fstack-protector-strong/), we learn from the condition in which we add stack protector check:

- local variable’s address used as part of the right hand side of an assignment or function argument
- local variable is an array (or union containing an array), regardless of array type or length
- uses register local variables

(Why contains the third condition? **From Kees's Comment: It was to catch unusual ways to get a reference to the frame address, with things like “register unsigned rsp __asm__(“rsp”);”, etc"**)

There is also an example in [Reference 2](https://outflux.net/blog/archives/2014/01/27/fstack-protector-strong/) to prove the functionability of `-fstack-protector-strong`. I also have [an analysis about stack protector options](http://localhost:4000/2016/05/24/debian-gcc-stack-protector-examples.html) in my blog

### References:
[1] ["Strong" stack protection for GCC](https://lwn.net/Articles/584225/)

[2] [-fstack-protector-strong from Kees Cook](https://outflux.net/blog/archives/2014/01/27/fstack-protector-strong/)
