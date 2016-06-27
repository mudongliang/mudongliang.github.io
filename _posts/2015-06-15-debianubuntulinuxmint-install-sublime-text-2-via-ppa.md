---
layout: post
title: "Debian/Ubuntu/LinuxMint 通过 PPA 安装 sublime text 2"
date: 2015-06-15
description: ""
category: 
tags: []
---

安装sublime-text-2 需要添加 WebUpd8team 的 [PPA](https://launchpad.net/~webupd8team/+archive/ubuntu/sublime-text-2)。

    $ sudo add-apt-repository ppa:webupd8team/sublime-text-2
    $ sudo apt-get update
    $ sudo apt-get install sublime-text

关于这里面可能出现的“add-apt-repository：command not found ”,请参考我的另一篇文章：[解决Debian找不到add-apt-repository的问题](http://mudongliang.github.io/2015/06/14/debian-add-apt-repository-command-not-found.html)

注意，当你在进行更新的时候会发现，Debian 系统会出现一个错误：

    W: Failed to fetch http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu/dists/stretch/main/binary-amd64/Packages  404  Not Found

为什么呢？是因为这个安装程序在写入list文件的时候估计默认为当前的系统是Ubuntu系统。所以使用的是 `/ubuntu/dists/stretch/`，这肯定无法找到对应的安装包！

下面是 webupd8team-sublime-text-2-stretch.list (在/etc/apt/sources.list.d中) 的内容：

    $ cat webupd8team-sublime-text-2-stretch.list 
       deb http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu stretch main 
       # deb-src http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu stretch main

其中，`stretch`是我Debian系统的名字！

解决的方法很简单，将`stretch`改成`trusty`,这个是Ubuntu的名字Ubuntu 14.04.2 LTS (Trusty Tahr)
