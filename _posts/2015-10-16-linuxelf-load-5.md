---
layout: post
title: "Linux内核中ELF加载解析（五）"
date: 2015-10-16
description: ""
category: 
tags: []
---

```
for (i = 0; i < loc->elf_ex.e_phnum; i++) {
    if (elf_ppnt->p_type == PT_INTERP) {
        /* This is the program interpreter used for
         * shared libraries - for now assume that this
         * is an a.out format binary
         */
        retval = -ENOEXEC;
        if (elf_ppnt->p_filesz > PATH_MAX || 
            elf_ppnt->p_filesz < 2)
            goto out_free_ph;

        retval = -ENOMEM;
        elf_interpreter = kmalloc(elf_ppnt->p_filesz,
                                          GFP_KERNEL);
        if (!elf_interpreter)
            goto out_free_ph;

        retval = kernel_read(bprm->file, elf_ppnt->p_offset,
                                         elf_interpreter,
                                         elf_ppnt->p_filesz);
        if (retval != elf_ppnt->p_filesz) {
            if (retval >= 0)
                retval = -EIO;
                goto out_free_interp;
        }
        /* make sure path is NULL terminated */
        retval = -ENOEXEC;
        if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
            goto out_free_interp;

        interpreter = open_exec(elf_interpreter);
        retval = PTR_ERR(interpreter);
        if (IS_ERR(interpreter))
            goto out_free_interp;

        /*
         * If the binary is not readable then enforce
         * mm->dumpable = 0 regardless of the interpreter's
         * permissions.
         */
        would_dump(bprm, interpreter);

        retval = kernel_read(interpreter, 0, bprm->buf,
                             BINPRM_BUF_SIZE);
        if (retval != BINPRM_BUF_SIZE) {
            if (retval >= 0)
                retval = -EIO;
                goto out_free_dentry;
            }

            /* Get the exec headers */
            loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
            break;
       }
       elf_ppnt++;
}
```

本段代码是对于`program header table`中的`PT_INTERP`项进行分析，检查，并加载。

我们来一点点分析这一段代码：

首先是一个大循环，遍历所有的`program header entry`，从第一个`if`语句可以看出，它主要是找`PR_INTERP`项，然后处理。

具体的处理工作是：

1.首先使用`kernel_read`，根据`program header entry`中的`Offset`和`FileSize`将对应的文件中的内容填充到一个数组`elf_interpreter`中，关于这个数组的内容，我使用`hexedit`进行查看发现，这是一个`ld`程序详细路径。

```
/lib64/ld-linux-x86-64.so.2

2F 6C 69 62  36 34 2F 6C  64 2D 6C 69  6E 75 78 2D
78 38 36 2D  36 34 2E 73  6F 2E 32 00
```

2.`open_exec`函数会将对应的文件打开，并返回对应的`file`对象，代表着读入的可执行文件映像。之后读入这个的前 128 (`BINPRM_BUF_SIZE`)个字节，并设置`interp_elf_ex`指针指向这个数组
