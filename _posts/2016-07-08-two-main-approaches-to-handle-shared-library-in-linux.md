---
layout: post
title: "Two main approaches to handle shared library in Linux"
date: 2016-07-08
description: ""
category: 
tags: []
---

Briefly, when the linker creates a shared library, it does not know in advance where it might be loaded. This creates a problems for the data and code references within the library, which should be somehow make to point to the correct memory locations.

There are two approaches to solve this problem in Linux ELF shared libraries:

- [Load-time relocation](http://eli.thegreenplace.net/2011/08/25/load-time-relocation-of-shared-libraries/)
- [Postion Independent Code(PIC)](http://eli.thegreenplace.net/2011/11/03/position-independent-code-pic-in-shared-libraries)

If I have time then, I will try to translate those two articles into Chinese.
