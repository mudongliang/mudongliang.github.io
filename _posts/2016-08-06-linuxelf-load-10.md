---
layout: post
title: "Linux内核中ELF加载解析（十）"
date: 2016-08-06
description: ""
category: 
tags: []
---
```
set_binfmt(&elf_format);

#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
    retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
    if (retval < 0)
        goto out;
#endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */

install_exec_creds(bprm);
retval = create_elf_tables(bprm, &loc->elf_ex,
                           load_addr, interp_load_addr);
if (retval < 0)
    goto out;
/* N.B. passed_fileno might not be initialized? */
current->mm->end_code = end_code;
current->mm->start_code = start_code;
current->mm->start_data = start_data;
current->mm->end_data = end_data;
current->mm->start_stack = bprm->p;

if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
    current->mm->brk = current->mm->start_brk =
        arch_randomize_brk(current->mm);
#ifdef compat_brk_randomized
       current->brk_randomized = 1;
#endif
}

    if (current->personality & MMAP_PAGE_ZERO) {
    /* Why this, you ask??? Well SVr4 maps page 0 as read-only,
      and some applications "depend" upon this behavior.
      Since we do not have the power to recompile these, we
      emulate the SVr4 behavior. Sigh. */
    error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
                                MAP_FIXED | MAP_PRIVATE, 0);
    }
start_thread(regs, elf_entry, bprm->p);
retval = 0;
```
