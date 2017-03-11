---
layout: post
title: "Linux内核中ELF加载解析（六）"
date: 2016-08-06
description: ""
category: 
tags: []
---

```
elf_ppnt = elf_phdata;
for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++)
    switch (elf_ppnt->p_type) {
    case PT_GNU_STACK:
        if (elf_ppnt->p_flags & PF_X)
            executable_stack = EXSTACK_ENABLE_X;
        else
            executable_stack = EXSTACK_DISABLE_X;
        break;
    case PT_LOPROC ... PT_HIPROC:
        retval = arch_elf_pt_proc(&loc->elf_ex, elf_ppnt,
                                  bprm->file, false,
                                  &arch_state);
        if (retval)
            goto out_free_dentry;
       break;
}
```

```
int executable_stack = EXSTACK_DEFAULT;
```

```
elf_ppnt = elf_phdata;
for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++)
    switch (elf_ppnt->p_type) {
    case PT_GNU_STACK:
        if (elf_ppnt->p_flags & PF_X)
            executable_stack = EXSTACK_ENABLE_X;
        else
            executable_stack = EXSTACK_DISABLE_X;
        break;
    ......
    }
```

根据`ELF`文件中的`GNU_STACK`段的存在性，以及对应的标识位来确定是否要使栈可执行。还有所谓的默认，根据体系框架来确定。详见[ELF文件可执行栈的深入分析](http://mudongliang.github.io/2015/10/23/elf.html)。

```
/* Some simple consistency checks for the interpreter */
if (elf_interpreter) {
      retval = -ELIBBAD;
    /* Not an ELF interpreter */
    if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
              goto out_free_dentry;
    /* Verify the interpreter has a valid arch */
    if (!elf_check_arch(&loc->interp_elf_ex))
             goto out_free_dentry;

    /* Load the interpreter program headers */
    interp_elf_phdata = load_elf_phdrs(&loc->interp_elf_ex,
                                       interpreter);
   if (!interp_elf_phdata)
           goto out_free_dentry;

    /* Pass PT_LOPROC..PT_HIPROC headers to arch code */
    elf_ppnt = interp_elf_phdata;
    for (i = 0; i < loc->interp_elf_ex.e_phnum; i++, elf_ppnt++)
        switch (elf_ppnt->p_type) {
        case PT_LOPROC ... PT_HIPROC:
    retval = arch_elf_pt_proc(&loc->interp_elf_ex,
                              elf_ppnt, interpreter,
                              true, &arch_state);
       if (retval)
                goto out_free_dentry;
        break;
    }
}
```
