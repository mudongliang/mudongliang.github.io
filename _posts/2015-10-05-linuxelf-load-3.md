---
layout: post
title: "Linux内核中ELF加载解析（三）"
date: 2015-10-05
description: ""
category: 
tags: []
---

`shell`会执行`evecve()`进行系统调用，如下所示

**execve -> sys_execve -> do_execve -> do_execveat_common -> exec_binprm -> search_binary_handler**

在`do_execveat_common`函数中，主要需要分析的位置在：

```
retval = exec_binprm(bprm);
if (retval < 0)
    goto out;
```

在`exec_binprm`函数中，主要需要分析的位置在：

```
rcu_read_lock();
old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
rcu_read_unlock();

ret = search_binary_handler(bprm);
```

在`search_binary_handler`函数中，主要需要分析的位置在：

```
read_lock(&binfmt_lock);
list_for_each_entry(fmt, &formats, lh) {
    if (!try_module_get(fmt->module))
        continue;
    read_unlock(&binfmt_lock);
    bprm->recursion_depth++;
    retval = fmt->load_binary(bprm);
    read_lock(&binfmt_lock);
    put_binfmt(fmt);
    bprm->recursion_depth--;
    if (retval < 0 && !bprm->mm) {
        /* we got to flush_old_exec() and failed after it */
        read_unlock(&binfmt_lock);
        force_sigsegv(SIGSEGV, current);
        return retval;
    }
    if (retval != -ENOEXEC || !bprm->file) {
        read_unlock(&binfmt_lock);
        return retval;
    }
}
read_unlock(&binfmt_lock);
```

**分析：**

`search_binary_handle()`遍历`formats`链表(所有注册的二进制格式)，依次尝试二进制格式的`load_binary()`.

这段代码 `retval = fmt->load_binary(bprm);` 的意思是从对应的二进制格式变量中使用`load_binary`调用对应的加载函数。对应于`elf`文件，这个函数指针指向`load_elf_binary()`,具体内容可以参见[Linux内核中ELF加载解析（二）](http://mudongliang.github.io/2015/10/05/linuxelf-load-2.html)
