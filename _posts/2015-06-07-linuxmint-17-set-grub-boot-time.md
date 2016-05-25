---
layout: post
title: "LinuxMint17 设置grub启动时间"
date: 2015-06-07
description: ""
category: 
tags: []
---

这是LinuxMint17Grub的配置文件/etc/default/grub的默认内容：

```
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
```

我们只需要将`GRUB_HIDDEN_TIMEOUT`相关设置直接删除就可以了.

不要忘了很重要的一步就是：

    sudo update-grub
