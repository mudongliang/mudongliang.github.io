---
layout: post
title: "RELRO - A (not so well known) Memory Corruption Mitigation Technique"
date: 2016-07-11
description: ""
category: 
tags: []
---

From [RELRO - A (not so well known) Memory Corruption Mitigation Technique](http://tk-blog.blogspot.com/2009/02/relro-not-so-well-known-memory.html)

RELRO is a generic mitigation technique to harden the data sections of an ELF binary/process. There are two different "operation modes" of RELRO:

- Partial RELRO
    - compiler command line: gcc -Wl,-z,relro
    - the ELF sections are reordered so that the ELF internal data sections (.got, .dtors, etc.) precede the program's data sections (.data and .bss)
    - non-PLT GOT is read-only
    - GOT is still writeable

- Full RELRO
    - compiler command line: gcc -Wl,-z,relro,-z,now
    - supports all the features of partial RELRO
    - bonus: the entire GOT is also (re)mapped as read-only

For the experiment, please refer to my github repo - [TraditionalMitigation](https://github.com/mudongliang/TraditionalMitigation)
