---
layout: post
title: "记一次本地权限提升漏洞"
date: 2015-07-05
description: ""
category: 
tags: []
---

我在 [Github](https://github.com/mudongliang/LinuxFlaw/tree/master/CVE-2015-1328) 上面提交有详细的代码和实验结果。可以去看一下，但是这个代码是别人写的，不是我自己的。另外我的实验环境是自己搭建的一个 `Linuxmint17.1` 服务器，还有一个就是我自己虚拟机中的 `Linuxmint17.2`。

最新的`Linuxmint17.1`，本地是可以直接执行成功的。最新的`Linuxmint17.2`，本地是不可以直接成功的，不过远程`ssh`的测试，却可以成功。

参考：

[1][CVE-2015-1328](http://cxsecurity.com/issue/WLB-2015060081)
