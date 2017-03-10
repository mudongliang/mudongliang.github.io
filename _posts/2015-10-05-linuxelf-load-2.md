---
layout: post
title: "Linux内核中ELF加载解析（二）"
date: 2015-10-05
description: ""
category: 
tags: []
---

Linux支持很多二进制格式：`a.out`，`elf`，`coff`等。

`struct linux_binfmt`这个结构体用来支持多种二进制格式，`struct linux_binfmt`对象必须要提供以下三个方法： 

- load_binary
- load_shlib
- core_dump

```
/*
 * This structure defines the functions 
 * that are used to load the binary formats that linux accepts.
 */
struct linux_binfmt {
    struct list_head lh;
    struct module *module;
    int (*load_binary)(struct linux_binprm *);
    int (*load_shlib)(struct file *);
    int (*core_dump)(struct coredump_params *cprm);
    unsigned long min_coredump;     /* minimal dump size */
};
```

函数定义在`include/linux/binfmts.h`

所有的`linux_binfmt`对象都包含在一个双向链表（`list_head`）中，并且第一个元素的地址存储在`formats`这个变量中。所有的元素都通过调用`register_binfmt()`和`unregister_binfmt()`来插入和删除元素。当系统启动编译入内核中的每一个执行格式，`register_binfmt()`函数被执行。当一个实现了新的执行模式的模块被加载的时候，这个函数也会被调用，同时当这个模块被卸载的时候，`unregister_binfmt()`函数会被调用。

```
formats  -> |      lh      | -> |     lh       | 
         <- |   module     | <- |    module    | 
            | load_binary  |    | load_binary  | 
            | load_shlib   |    | load_shlib   | 
            | core_dump    |    | core_dump    | 
            | min_coredump |    | min_coredump |
```

```
/* Registration of default binfmt handlers */
static inline void register_binfmt(struct linux_binfmt *fmt)
{
    __register_binfmt(fmt, 0);
} /* Same as above, but adds a new binfmt at the top of the list */
static inline void insert_binfmt(struct linux_binfmt *fmt)
{
    __register_binfmt(fmt, 1);
}
```

函数定义在`include/linux/binfmts.h`

```
static LIST_HEAD(formats);
static DEFINE_RWLOCK(binfmt_lock);
void __register_binfmt(struct linux_binfmt * fmt, int insert)
{
    BUG_ON(!fmt);
    if (WARN_ON(!fmt->load_binary))
        return;
    write_lock(&binfmt_lock);
    insert ? list_add(&fmt->lh, &formats) :
    list_add_tail(&fmt->lh, &formats);       //添加元素
    write_unlock(&binfmt_lock);
}
```

变量，函数定义在fs/exec.c

```
void unregister_binfmt(struct linux_binfmt * fmt)
{
    write_lock(&binfmt_lock);
    list_del(&fmt->lh);    //删除链表中一项
    write_unlock(&binfmt_lock);
}
```

函数定义在`fs/exec.c`

这里面有一些关于链表的操作，比如说`LIST_HEAD,list_del, list_add, list_add_tail`。详细分析见[Linux内核中ELF加载解析](http://mudongliang.github.io/2015/10/05/linux-list_head1.html)。

以下是`elf`格式的`linux_binfmt`的变量内容：

```
static struct linux_binfmt elf_format = {
    .module         = THIS_MODULE,
    .load_binary    = load_elf_binary,
    .load_shlib     = load_elf_library,
    .core_dump      = elf_core_dump,
    .min_coredump   = ELF_EXEC_PAGESIZE,
    .hasvdso        = 1
};

static int __init init_elf_binfmt(void)
{
    register_binfmt(&elf_format);
    return 0;
}

static void __exit exit_elf_binfmt(void)
{
    /* Remove the COFF and ELF loaders. */
    unregister_binfmt(&elf_format);
}
core_initcall(init_elf_binfmt);
module_exit(exit_elf_binfmt);
MODULE_LICENSE("GPL");
```

而`struct linux_binprm`保存要要执行的文件相关的信息

```
/*
* This structure is used to hold the arguments 
* that are used when loading binaries.
*/
struct linux_binprm {
    char buf[BINPRM_BUF_SIZE];
#ifdef CONFIG_MMU
    struct vm_area_struct *vma;
    unsigned long vma_pages;
#else
    # define MAX_ARG_PAGES  32
    struct page *page[MAX_ARG_PAGES];
#endif
    struct mm_struct *mm;
    unsigned long p; /* current top of mem */
    unsigned int
    cred_prepared:1,
/* true if creds already prepared (multiple
 * preps happen for interpreters) */
    cap_effective:1;
/* true if has elevated effective capabilities,
 * false if not; except for init which inherits
 * its parent's caps anyway */
#ifdef __alpha__
    unsigned int taso:1;
#endif
    unsigned int recursion_depth; 
/* only for search_binary_handler() */
    struct file * file;
    struct cred *cred; /* new credentials */
    int unsafe;        
/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
    unsigned int per_clear; 
/* bits to clear in current->personality */
    int argc, envc;
    const char * filename;   
/* Name of binary as seen by procps */
    const char * interp;    
/* Name of the binary really executed. Most
 of the time same as filename, but could be
 different for binfmt_{misc,script} */
    unsigned interp_flags;
    unsigned interp_data;
    unsigned long loader, exec;
};
```
