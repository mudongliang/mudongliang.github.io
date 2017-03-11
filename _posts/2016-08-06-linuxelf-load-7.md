---
layout: post
title: "Linux内核中ELF加载解析（七）"
date: 2016-08-06
description: ""
category: 
tags: []
---

```
/*
 * Allow arch code to reject the ELF at this point, whilst it's
 * still possible to return an error to the code that invoked
 * the exec syscall.
 */
retval = arch_check_elf(&loc->elf_ex, !!interpreter, &arch_state);
if (retval)
    goto out_free_dentry;

/* Flush all traces of the currently running executable */
retval = flush_old_exec(bprm);
if (retval)
    goto out_free_dentry;

/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 may depend on the personality. */
SET_PERSONALITY2(loc->elf_ex, &arch_state);
if (elf_read_implies_exec(loc->elf_ex, executable_stack))
    current->personality |= READ_IMPLIES_EXEC;

if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
    current->flags |= PF_RANDOMIZE;

setup_new_exec(bprm);

/* Do this so that we can load the interpreter, if need be. We will
change some of these later */
retval = setup_arg_pages(bprm, randomize_stack_top(STACK_TOP),
                               executable_stack);
if (retval < 0)
    goto out_free_dentry;

current->mm->start_stack = bprm->p;
```
