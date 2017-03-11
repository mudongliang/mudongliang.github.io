---
layout: post
title: "Linux内核中ELF加载解析（九）"
date: 2016-08-06
description: ""
category: 
tags: []
---
```
loc->elf_ex.e_entry += load_bias;
elf_bss += load_bias;
elf_brk += load_bias;
start_code += load_bias;
end_code += load_bias;
start_data += load_bias;
end_data += load_bias;

/* Calling set_brk effectively mmaps the pages that we need
 * for the bss and break sections. We must do this before
 * mapping in the interpreter, to make sure it doesn't wind
 * up getting placed where the bss needs to go.
 */
retval = set_brk(elf_bss, elf_brk);
if (retval)
	goto out_free_dentry;
if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
	retval = -EFAULT; /* Nobody gets to see this, but.. */
	goto out_free_dentry;
}

if (elf_interpreter) {
	unsigned long interp_map_addr = 0;

	elf_entry = load_elf_interp(&loc->interp_elf_ex,
			interpreter,
			&interp_map_addr,
			load_bias, interp_elf_phdata);
	if (!IS_ERR((void *)elf_entry)) {
		/*
		 * load_elf_interp() returns relocation
		 * adjustment
		 */
		interp_load_addr = elf_entry;
		elf_entry += loc->interp_elf_ex.e_entry;
	}
	if (BAD_ADDR(elf_entry)) {
		retval = IS_ERR((void *)elf_entry) ?
			(int)elf_entry : -EINVAL;
		goto out_free_dentry;
	}
	reloc_func_desc = interp_load_addr;

	allow_write_access(interpreter);
	fput(interpreter);
	kfree(elf_interpreter);
} else {
	elf_entry = loc->elf_ex.e_entry;
	if (BAD_ADDR(elf_entry)) {
		retval = -EINVAL;
		goto out_free_dentry;
	}
}
```
