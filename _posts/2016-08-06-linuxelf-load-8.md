---
layout: post
title: "Linux内核中ELF加载解析（八）"
date: 2016-08-06
description: ""
category: 
tags: []
---

```
/* Now we do a little grungy work by mmapping the ELF image into
 the correct location in memory. */
for(i = 0, elf_ppnt = elf_phdata;
    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
    int elf_prot = 0, elf_flags;
    unsigned long k, vaddr;
    unsigned long total_size = 0;

   if (elf_ppnt->p_type != PT_LOAD)
       continue;
   if (unlikely (elf_brk > elf_bss)) {
       unsigned long nbyte;

    /* There was a PT_LOAD segment with p_memsz > p_filesz
      before this one. Map anonymous pages, if needed,
      and clear the area. */
            retval = set_brk(elf_bss + load_bias,
                              elf_brk + load_bias);
                if (retval)
                        goto out_free_dentry;
                    nbyte = ELF_PAGEOFFSET(elf_bss);
                 if (nbyte) {
                          nbyte = ELF_MIN_ALIGN - nbyte;
                          if (nbyte > elf_brk - elf_bss)
                                nbyte = elf_brk - elf_bss;
                       if (clear_user((void __user *)elf_bss +
                                           load_bias, nbyte)) {
           /*
  * This bss-zeroing can fail if the ELF
  * file specifies odd protections. So
  * we don't check the return value
  */
                                 }
                         }
                 }

                 if (elf_ppnt->p_flags & PF_R)
                         elf_prot |= PROT_READ;
             if (elf_ppnt->p_flags & PF_W)
                       elf_prot |= PROT_WRITE;
               if (elf_ppnt->p_flags & PF_X)
                     elf_prot |= PROT_EXEC;

               elf_flags = MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE;

              vaddr = elf_ppnt->p_vaddr;
               if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
                      elf_flags |= MAP_FIXED;
                } else if (loc->elf_ex.e_type == ET_DYN) {
                       /* Try and get dynamic programs out of the way of the
  * default mmap base, as well as whatever program they
  * might try to exec. This is because the brk will
  * follow the loader, and is not movable. */
       load_bias = ELF_ET_DYN_BASE - vaddr;
       if (current->flags & PF_RANDOMIZE)
        load_bias += arch_mmap_rnd();
              load_bias = ELF_PAGESTART(load_bias);
        total_size = total_mapping_size(elf_phdata,
                                        loc->elf_ex.e_phnum);
                         if (!total_size) {
                                retval = -EINVAL;
                                 goto out_free_dentry;
                         }
                 }

                 error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
                                 elf_prot, elf_flags, total_size);
                 if (BAD_ADDR(error)) {
                         retval = IS_ERR((void *)error) ?
                                 PTR_ERR((void*)error) : -EINVAL;
                         goto out_free_dentry;
                 }

                 if (!load_addr_set) {
                         load_addr_set = 1;
                         load_addr = (elf_ppnt->p_vaddr - elf_ppnt->p_offset);
                         if (loc->elf_ex.e_type == ET_DYN) {
                                 load_bias += error -
                                              ELF_PAGESTART(load_bias + vaddr);
                                 load_addr += load_bias;
                                 reloc_func_desc = load_bias;
                         }
                 }
                 k = elf_ppnt->p_vaddr;
                 if (k < start_code)
                         start_code = k;
                 if (start_data < k)
                         start_data = k;

                 /*
  * Check to see if the section's size will overflow the
  * allowed task size. Note that p_filesz must always be
  * <= p_memsz so it is only necessary to check p_memsz.
  */
                 if (BAD_ADDR(k) || elf_ppnt->p_filesz > elf_ppnt->p_memsz ||
                     elf_ppnt->p_memsz > TASK_SIZE ||
                     TASK_SIZE - elf_ppnt->p_memsz < k) {
                         /* set_brk can never work. Avoid overflows. */
                         retval = -EINVAL;
                         goto out_free_dentry;
                 }

                 k = elf_ppnt->p_vaddr + elf_ppnt->p_filesz;

          if (k > elf_bss)
              elf_bss = k;
          if ((elf_ppnt->p_flags & PF_X) && end_code < k)
               end_code = k;
          if (end_data < k)
                end_data = k;
     k = elf_ppnt->p_vaddr + elf_ppnt->p_memsz;
      if (k > elf_brk)
               elf_brk = k;
}
```
