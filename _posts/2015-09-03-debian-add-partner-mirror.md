---
layout: post
title: "Debian add partner mirror"
date: 2015-09-03
description: ""
category: 
tags: []
---

# Debian添加Partner源

为什么没有linuxmint和Ubuntu 呢？因为默认两者都已经有了这个软件源。

1.首先，在/etc/apt/sources.list.d/文件夹中创建一个list文件（命名如，partner.list）。

内容很简单：

    # trusty is codename of Ubuntu 14.04 LTS
    deb http://archive.canonical.com/ubuntu/ trusty partner

2.更新系统

    sudo apt-get update

W: GPG 错误：http://archive.canonical.com trusty Release: 由于没有公钥，无法验证下列签名： NO_PUBKEY 40976EAF437D05B5 NO_PUBKEY 3B4FE6ACC0B21F32

从错误提示中你会发现一个问题： 没有对应的公钥。

3.添加公钥

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 3B4FE6ACC0B21F32

4.再次进行系统更新即可。
