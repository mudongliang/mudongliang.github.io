---
layout: post
title: "Linuxmint/Ubuntu/Debian添加Ubuntukylin源"
date: 2015-08-26
description: ""
category: 
tags: []
---

# Linuxmint/Ubuntu/Debian添加Ubuntukylin源

1.首先，在/etc/apt/sources.list.d/文件夹中创建一个list文件（命名如，ubuntukylin.list）。

内容很简单：

    deb http://archive.ubuntukylin.com:10006/ubuntukylin trusty main

2.更新系统

    sudo apt-get update

W: GPG error: http://archive.ubuntukylin.com trusty Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY D259B7555E1D3C58

从错误提示中你会发现一个问题： 没有对应的公钥。

3.添加公钥

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D259B7555E1D3C58

4.再次进行系统更新即可。
