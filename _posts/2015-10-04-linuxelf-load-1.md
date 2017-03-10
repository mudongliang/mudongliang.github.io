---
layout: post
title: "Linux内核中ELF加载解析（一）"
date: 2015-10-04
description: ""
category: 
tags: []
---

```
/* Get the exec-header */
loc->elf_ex = *((struct elfhdr *)bprm->buf);
retval = -ENOEXEC; /* First of all, some simple consistency checks */
if (memcmp(loc->elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
    goto out;
```

这段代码位于`fs/binfmt_elf.c`的`load_elf_binary`函数，其功能是为了检测`ELF`文件的魔数，就是文件开始处的前四个字节 - `7F 45 4C 46`。
那么我们先来看一下`elfhdr`这个结构体是干什么的？在这个`include/linux/elf.h`文件中，根据系统使用的框架结构来决定使用 32 位还是 64 位的`elf header`结构。

```
 #if ELF_CLASS == ELFCLASS32

 extern Elf32_Dyn _DYNAMIC [];
 #define elfhdr          elf32_hdr
 #define elf_phdr        elf32_phdr
 #define elf_shdr        elf32_shdr
 #define elf_note        elf32_note
 #define elf_addr_t      Elf32_Off
 #define Elf_Half        Elf32_Half

 #else

 extern Elf64_Dyn _DYNAMIC [];
 #define elfhdr          elf64_hdr
 #define elf_phdr        elf64_phdr
 #define elf_shdr        elf64_shdr
 #define elf_note        elf64_note
 #define elf_addr_t      Elf64_Off
 #define Elf_Half        Elf64_Half

 #endif
```

然后，我们将 32 位和 64 位的`elf header`结构的内容拿出来看看，

```
#define EI_NIDENT       16

typedef struct elf32_hdr{
  unsigned char e_ident[EI_NIDENT];
  Elf32_Half    e_type;
  Elf32_Half    e_machine;
  Elf32_Word    e_version;
  Elf32_Addr    e_entry;  /* Entry point */
  Elf32_Off     e_phoff;
  Elf32_Off     e_shoff;
  Elf32_Word    e_flags;
  Elf32_Half    e_ehsize;
  Elf32_Half    e_phentsize;
  Elf32_Half    e_phnum;
  Elf32_Half    e_shentsize;
  Elf32_Half    e_shnum;
  Elf32_Half    e_shstrndx;
} Elf32_Ehdr;

typedef struct elf64_hdr {
  unsigned char e_ident[EI_NIDENT];     /* ELF "magic number" */
  Elf64_Half e_type;
  Elf64_Half e_machine;
  Elf64_Word e_version;
  Elf64_Addr e_entry;           /* Entry point virtual address */
  Elf64_Off e_phoff;            /* Program header table file offset */
  Elf64_Off e_shoff;            /* Section header table file offset */
  Elf64_Word e_flags;
  Elf64_Half e_ehsize;
  Elf64_Half e_phentsize;
  Elf64_Half e_phnum;
  Elf64_Half e_shentsize;
  Elf64_Half e_shnum;
  Elf64_Half e_shstrndx;
} Elf64_Ehdr;
```

在`elf header`结构中的`e_ident`存储鉴定`ELF`文件，特别是前四个字节。下面位置是`ELF MAGIC NUMBER`的宏。

```
#define ELFMAG0         0x7f            /* EI_MAG */
#define ELFMAG1         'E'
#define ELFMAG2         'L'
#define ELFMAG3         'F'
#define ELFMAG          "\177ELF"
#define SELFMAG         4
```

memcmp用来检查`elf header`的`e_ident`数组的前四个字节是不是和`ELFMAG`是否相等。但是这里面有一个疑问：**为什么ELFMAG会是"\177ELF"？**

这里面是有字符转义，

- \ddd 1到3位八进制数所代表的任意字符 三位八进制

- \xhh 1到2位十六进制所代表的任意字符 二位十六进制

从上面的解释可以看出来，"\"和"\x"分别对应于不同的数进制 : "\177" = "\x7f"。

为什么不使用 16 进制呢？是因为后面的“ELF”，其中“E”也会被翻译为16进制。

为了让大家更加理解这个概念，我写了一个小例子，让大家看看！

```
char mag[]  = "\x7fELF";    //wrong
char mag1[] = "\x7f ELF";   //wrong
char mag2[] = "\177ELF";    //right

int main()
{
    char *a = NULL;
    for( a = &mag; *a ; a++)
        printf("%d and %x\n", *a, *a);
    printf("--- ---\n");
    for( a = &mag1 ; *a ; a++)
        printf("%d and %x\n", *a, *a);
    printf("--- ---\n");
    for( a = &mag2 ; *a ; a++)
        printf("%d and %x\n", *a, *a);
    printf("--- ---\n");
    return 0;
}
```

执行结果如下所示：

```
[mdl@mdl ~]$ ./a
-2 and fffffffe
76 and 4c
70 and 46
--- ---
127 and 7f
32 and 20
69 and 45
76 and 4c
70 and 46
--- ---
127 and 7f
69 and 45
76 and 4c
70 and 46
--- ---
```
