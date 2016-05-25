---
layout: post
title: "Linux删除手动编译内核"
date: 2015-06-04
description: ""
category: 
tags: []
---

继 [Fedora21编译 Linux Kernel 4.0](http://mudongliang.github.io/2015/06/06/fedora21-compile-linux-kernel.html) 和[Debian8/LinuxMint17 编译 Linux Kernel 4.0](http://mudongliang.github.io/2015/06/06/debian-compile-linux-kernel-40.html) 之后，我们想着删除自己手动编译的内核！

## 1. 删除编译生成的内核文件

```sh
sudo rm -rf /lib/modules/4.0.0 
sudo rm -rf /usr/src/linux-4.0 # (LinuxMint17) 
sudo rm -rf /usr/src/kernels/linux-4.0 (Fedora21) 
sudo rm /boot/*4.0.0* 
```

## 2. 重新生成grub.cfg配置文件

- Redhat 阵营

```
    sudo grub2-mkconfig 
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

- Debian 阵营

```
    sudo grub-mkconfig （Debian Jessie Stable）
    sudo grub-update (Ubuntu14 LinuxMint17)
```
