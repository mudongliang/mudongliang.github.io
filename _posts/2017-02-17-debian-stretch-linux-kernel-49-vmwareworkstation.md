---
layout: post
title: "Debian Stretch 为 Linux Kernel 4.9 打补丁，使 VMwareWorkstation 正常运行"
date: 2017-02-17
description: ""
category: 
tags: [linux kernel,4.9,vmware workstation,patch]
---

VMware Workstation 虽然已经更新到了 12.5.2, 但是 linux 版本安装之后仍然无法成功编译对应的模块。

首先，从 log 或者图形界面上，可以看出来是 vmnet 模块出了问题，尝试修复这个错误（最好切换成 root，因为后面的关键操作基本都需要 root 权限）：

```sh
cd /usr/lib/vmware/modules/source
tar -xf vmnet.tar
cd vmnet-only
```

In `vmnet-only/userif.c`, around **line 113**, change

```C
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0)
    retval = get_user_pages(addr, 1, 1, 0, &page, NULL);
#else
    retval = get_user_pages(current, current->mm, addr,
                1, 1, 0, &page, NULL);
#endif
```

to

```C
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 9, 0)
     retval = get_user_pages(addr, 1, 0, &page, NULL);
#else
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0)
     retval = get_user_pages(addr, 1, 1, 0, &page, NULL);
#else
     retval = get_user_pages(current, current->mm, addr,
                 1, 1, 0, &page, NULL);
#endif
#endif
```

```sh
tar -cf vmnet.tar vmnet-only 
rm -r vmnet-only 
vmware-modconfig --console --install-all
```

再次尝试编译之后，还是发现无法成功编译，但是现在不是 vmnet 模块的问题，而是 vmmon 模块的错误。

```sh
cd /usr/lib/vmware/modules/source
tar -xf vmmon.tar
cd vmmon-only
```

In `vmmon-only/linux/hostif.c`, around **line 1162**, change


```C
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0)
   retval = get_user_pages((unsigned long)uvAddr, numPages, 0, 0, ppages, NULL);
#else
   retval = get_user_pages(current, current->mm, (unsigned long)uvAddr,
                           numPages, 0, 0, ppages, NULL);
#endif
```

to

```C
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 9, 0)
   retval = get_user_pages((unsigned long)uvAddr, numPages, 0, ppages, NULL);
#else
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0)
   retval = get_user_pages((unsigned long)uvAddr, numPages, 0, 0, ppages, NULL);
#else
   retval = get_user_pages(current, current->mm, (unsigned long)uvAddr,
                           numPages, 0, 0, ppages, NULL);
#endif
#endif
```

```sh
tar -cf vmmon.tar vmmon-only 
rm -r vmmon-only
vmware-modconfig --console --install-all
```

现在就没有问题了，Enjoy Your Own Virtual Machines！
