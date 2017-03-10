---
layout: post
title: "Linux内核中ELF加载解析（四）"
date: 2015-10-16
description: ""
category: 
tags: []
---

```
if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
    goto out;
if (!elf_check_arch(&loc->elf_ex))
    goto out;
if (!bprm->file->f_op->mmap)
    goto out;
```

`elf header`中的`e_type`表示文件类型，`ET_EXEC`和`ET_DYN`分别表示可执行文件和共享库，只是这两种类型的`ELF`才可以去加载，执行。

`elf_check_arch`用于检测当前的架构是否支持，以`x86`, `x86_64`为例，

```
/*
 * This is used to ensure we don't load something * for the wrong architecture.
 */
#define elf_check_arch(x) \
    (((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
#define elf_check_arch(x) \
    ((x)->e_machine == EM_X86_64)
```

`f_op`表示对于文件的操作集合，如果这里面没有定义`mmap`函数的话，就要退出。

另外关于`elf_phdata`的来历，我们进行简要的分析：

`elf_phdata`指向`ELF`文件的`program header table`, `elf_phdata`的数据是从`file`中根据`elf header`中的`program header table`文件偏移，`entry`数目和`program header`结构的大小。

可以从以下函数中的某一代码片段看出来：

```
kernel_read(elf_file, elf_ex->e_phoff, (char *)elf_phdata, size);
elf_file : 已打开的文件对象
elf_ex : 指向elfhdr的数据指针
elf_phdata : 存放elf_phdr的数据指针
size : 从elf_ex中读出来program header table中program header的数目e_phnum
static struct elf_phdr *load_elf_phdrs(struct elfhdr *elf_ex,
                                   struct file *elf_file)
{
    struct elf_phdr *elf_phdata = NULL;
    int retval, size, err = -1;
    /*
     * If the size of this structure has changed, then punt, since
     * we will be doing the wrong thing.
     */
    if (elf_ex->e_phentsize != sizeof(struct elf_phdr))
       goto out;
    /* Sanity check the number of program headers... */
    if (elf_ex->e_phnum < 1 ||
        elf_ex->e_phnum > 65536U / sizeof(struct elf_phdr))
            goto out;
    /* ...and their total size. */
    size = sizeof(struct elf_phdr) * elf_ex->e_phnum;
    if (size > ELF_MIN_ALIGN)
        goto out;
    elf_phdata = kmalloc(size, GFP_KERNEL);
    if (!elf_phdata)
        goto out;
    /* Read in the program headers */
    retval = kernel_read(elf_file, elf_ex->e_phoff,
                        (char *)elf_phdata, size);
    if (retval != size) {
        err = (retval < 0) ? retval : -EIO;
        goto out;
    }
    /* Success! */
    err = 0;
out:
    if (err) {
        kfree(elf_phdata);
        elf_phdata = NULL;
    }
    return elf_phdata;
}
```

这个函数`kernel_read`之前有很多关于`elf`文件的检测，

1. 判断`elf_ex->e_phentsize，sizeof(struct elf_phdr)`是否相等，这是`elf header`中必须要满足的条件。

2. 判断`elf_ex->e_phnum`的数目是否属于`[1, 65536/sizeof(struct elf_phdr)]`

3. `size`这里有一个小问题，由于上面 1 已经检测过了，所以使用`e_phentsize`和`sizeof(struct elf_phdr)`都可以。
