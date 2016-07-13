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
    - some sections(.init_array .fini_array .jcr .dynamic .got) are marked as read-only after they have been initialized by the dynamic loader
    - non-PLT GOT is read-only (.got)
    - GOT is still writeable (.got.plt)

ELF Program Header Table (Segment) for partial RELRO:

    $ readelf -l partial 
    
    Elf file type is EXEC (Executable file)
    Entry point 0x8048350
    There are 9 program headers, starting at offset 52
    
    Program Headers:
      Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
      PHDR           0x000034 0x08048034 0x08048034 0x00120 0x00120 R E 0x4
      INTERP         0x000154 0x08048154 0x08048154 0x00013 0x00013 R   0x1
          [Requesting program interpreter: /lib/ld-linux.so.2]
      LOAD           0x000000 0x08048000 0x08048000 0x00618 0x00618 R E 0x1000
      LOAD           0x000f08 0x08049f08 0x08049f08 0x0011c 0x00120 RW  0x1000
      DYNAMIC        0x000f14 0x08049f14 0x08049f14 0x000e8 0x000e8 RW  0x4
      NOTE           0x000168 0x08048168 0x08048168 0x00044 0x00044 R   0x4
      GNU_EH_FRAME   0x00053c 0x0804853c 0x0804853c 0x0002c 0x0002c R   0x4
      GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RW  0x10
      GNU_RELRO      0x000f08 0x08049f08 0x08049f08 0x000f8 0x000f8 R   0x1
    
     Section to Segment mapping:
      Segment Sections...
       00     
       01     .interp 
       02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rel.dyn .rel.plt .init .plt .text .fini .rodata .eh_frame_hdr .eh_frame 
       03     .init_array .fini_array .jcr .dynamic .got .got.plt .data .bss 
       04     .dynamic 
       05     .note.ABI-tag .note.gnu.build-id 
       06     .eh_frame_hdr 
       07     
       08     .init_array .fini_array .jcr .dynamic .got 


- Full RELRO
    - compiler command line: gcc -Wl,-z,relro,-z,now
    - supports all the features of partial RELRO
    - lazy resolution is disabled: all imported symbols are resolved at startup time.
    - bonus: the entire GOT is also (re)mapped as read-only or the .got.plt section is completely initialized with the final addresses of the target functions (Merge .got and .got.plt to one section .got). Moreover,since lazy resolution is not enabled, the GOT[1] and GOT[2] entries are not initialized.

ELF Program Header Table (Segment) for full RELRO:

    readelf -l full
    
    Elf file type is EXEC (Executable file)
    Entry point 0x8048350
    There are 9 program headers, starting at offset 52
    
    Program Headers:
      Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
      PHDR           0x000034 0x08048034 0x08048034 0x00120 0x00120 R E 0x4
      INTERP         0x000154 0x08048154 0x08048154 0x00013 0x00013 R   0x1
          [Requesting program interpreter: /lib/ld-linux.so.2]
      LOAD           0x000000 0x08048000 0x08048000 0x00618 0x00618 R E 0x1000
      LOAD           0x000edc 0x08049edc 0x08049edc 0x0012c 0x00130 RW  0x1000
      DYNAMIC        0x000ee8 0x08049ee8 0x08049ee8 0x000f8 0x000f8 RW  0x4
      NOTE           0x000168 0x08048168 0x08048168 0x00044 0x00044 R   0x4
      GNU_EH_FRAME   0x00053c 0x0804853c 0x0804853c 0x0002c 0x0002c R   0x4
      GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RW  0x10
      GNU_RELRO      0x000edc 0x08049edc 0x08049edc 0x00124 0x00124 R   0x1
    
     Section to Segment mapping:
      Segment Sections...
       00     
       01     .interp 
       02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rel.dyn .rel.plt .init .plt .text .fini .rodata .eh_frame_hdr .eh_frame 
       03     .init_array .fini_array .jcr .dynamic .got .data .bss 
       04     .dynamic 
       05     .note.ABI-tag .note.gnu.build-id 
       06     .eh_frame_hdr 
       07     
       08     .init_array .fini_array .jcr .dynamic .got


For the experiment, please refer to my github repo - [TraditionalMitigation](https://github.com/mudongliang/TraditionalMitigation)
