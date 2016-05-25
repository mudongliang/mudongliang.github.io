---
layout: post
title: "GCC Optimization Level"
date: 2016-05-25
description: ""
category: 
tags: []
---

To be pedantic, there are 7 different valid `-O` options you can give to `gcc`, though there are some that mean the same thing. From the [man page](http://linux.die.net/man/1/gcc):

- `-O` (Same as `-O1`)
- `-O0` (do no optimization, the default if no optimization level is specified)
- `-O1` (optimize minimally)
- `-O2` (optimize more)
- `-O3` (optimize even more)
- `-Ofast` (optimize very aggressively to the point of breaking standard compliance)
- `-Os` (Optimize for size. `-Os` enables all `-O2` optimizations that do not typically increase code size. It also performs further optimizations designed to reduce code size. `-Os` disables the following optimization flags: `-falign-functions -falign-jumps -falign-loops -falign-labels -freorder-blocks -freorder-blocks-and-partition -fprefetch-loop-arrays -ftree-vect-loop-version`)
- `-Og` (Optimize, but do not interfere with debugging. This enables non-embarrassing performance for debug builds and is intended to replace `-O0` for debug builds. 

More details refer to GCC Online Docs in References.

References:

[1] [GCC Online Docs](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)
