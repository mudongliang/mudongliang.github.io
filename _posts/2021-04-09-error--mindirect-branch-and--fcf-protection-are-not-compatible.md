---
layout: post
title: "error: ' mindirect branch' and ' fcf protection' are not compatible"
date: 2021-04-09
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Compiling errors

```
vclock_gettime.c: In function ‘__vdso_time’:
vclock_gettime.c:319:1: error: ‘-mindirect-branch’ and ‘-fcf-protection’ are not compatible
  319 | {
      | ^
```

## Solutions

Switching to gcc-8 should fix the problem:

```
make CC=gcc-8
```

## References

[1] <https://badsimplicity.com/2019/07/10/gcc-9-and-ubuntu-kernel-error/> 
