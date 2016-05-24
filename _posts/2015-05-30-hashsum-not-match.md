---
layout: post
title: "Hash 校验和不符问题解决"
date: 2015-05-30
description: ""
category: 
tags: []
---

# Hash 校验和不符问题解决

主要的包管理工具
- dpkg      – Debian 包安装工具
- apt-get   – APT 的命令行前端
- aptitude  – APT 的高级的字符和命令行前端
- synaptic  – 图形界面的 APT 前端
- dselect   – 使用菜单界面的包管理工具
- tasksel   – Task 安装工具

这些工具不是用来取代对方的，比如 dselect 同时使用 APT 和 dpkg。

APT 使用 /var/lib/apt/lists/* 来跟踪可用的软件包，而 dpkg 使用的是 /var/lib/dpkg/available。

而解决Hash 校验和不符的问题，很简单，执行下面的命令就行，

```sh
# rm -rf /var/lib/apt/lists/*
# apt-get update && apt-get upgrade 
```
