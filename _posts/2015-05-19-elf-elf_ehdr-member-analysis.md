---
layout: post
title: "ELF Elf_Ehdr member analysis"
date: 2015-05-19
description: ""
category: 
tags: []
---

# ELF文件中Elf_Ehdr成员类型分析

ELF文件的重要数据都存放在/usr/include/elf.h头文件中！我们这一次并不是要介绍这些数据结构有什么什么用处我只是要弄清楚这些个数据结构中成员的类型，因为我今天在写C语言来解析ELF文件的时候出现了许多的Wformat警告！

```c
#define EI_NIDENT 16

typedef struct {
    unsigned char   e_ident[EI_NIDENT];
	Elf32_Half      e_type;
	Elf32_Half      e_machine;
	Elf32_Word      e_version;
	Elf32_Addr      e_entry;
	Elf32_Off       e_phoff;
	Elf32_Off       e_shoff;
	Elf32_Word      e_flags;
	Elf32_Half      e_ehsize;
	Elf32_Half      e_phentsize;
	Elf32_Half      e_phnum;
	Elf32_Half      e_shentsize;
	Elf32_Half      e_shnum;
	Elf32_Half      e_shtrndx;
} Elf32_Ehdr;

typedef struct {
	unsigned char   e_ident[EI_NIDENT];
	Elf64_Half      e_type;
	Elf64_Half      e_machine;
	Elf64_Word      e_version;
	Elf64_Addr      e_entry;
	Elf64_Off       e_phoff;
	Elf64_Off       e_shoff;
	Elf64_Word      e_flags;
	Elf64_Half      e_ehsize;
	Elf64_Half      e_phentsize;
	Elf64_Half      e_phnum;
	Elf64_Half      e_shentsize;
	Elf64_Half      e_shnum;
	Elf64_Half      e_shtrndx;
} Elf64_Ehdr;
```

这两个数据结构中的成员的类型重要数据同样定义在/usr/include/elf.h头文件中！

```c
/* Unsigned.  */
/* Type for a 16-bit quantity.  */
typedef uint16_t Elf32_Half;
typedef uint16_t Elf64_Half;

/* Types for signed and unsigned 32-bit quantities.  */
typedef uint32_t Elf32_Word;
typedef	int32_t  Elf32_Sword;
typedef uint32_t Elf64_Word;
typedef	int32_t  Elf64_Sword;

/* Types for signed and unsigned 64-bit quantities.  */
typedef uint64_t Elf32_Xword;
typedef	int64_t  Elf32_Sxword;
typedef uint64_t Elf64_Xword;
typedef	int64_t  Elf64_Sxword;

/* Type of addresses.  */
typedef uint32_t Elf32_Addr;
typedef uint64_t Elf64_Addr;

/* Type of file offsets.  */
typedef uint32_t Elf32_Off;
typedef uint64_t Elf64_Off;
```

看到这里我们还是没有找到他们具体的变量类型，所以还要继续找，终于在搜索之后发现这个东西的定义其实是在/usr/include/stdint.h这个头文件中，马上将这些所有的定义粘出来，马上对照这个进行修改的话，就可以消除所有的Wformat警告！

```c
/* Unsigned.  */
typedef unsigned char		uint8_t;
typedef unsigned short int	uint16_t;
#ifndef __uint32_t_defined
typedef unsigned int		uint32_t;
# define __uint32_t_defined
#endif
#if __WORDSIZE == 64
typedef unsigned long int	uint64_t;
#else
__extension__
typedef unsigned long long int	uint64_t;
#endif
```
