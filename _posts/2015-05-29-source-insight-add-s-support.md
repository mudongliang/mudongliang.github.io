---
layout: post
title: "source insight add *.S support"
date: 2015-05-25
description: ""
category: 
tags: []
---

# Source Insight 添加 *.S支持

为了用source insight能搜索到.S的汇编文件，必须把该文件添加进来。方法如下所示：

1. 在创建工程前先特别设置好source insight 。设置如下：
Options->Document Options->Doucment Types->选择x86 Assemble，再在右边File Filter里输入*.S。这样以后再new一个工程，在添加文件时，就可以把文件夹中的*.S添加进去了。
2. 如果之前已经创建好工程的，而又想把*.S文件添加进来。如下：
打开创建好的工程，Options->Document Options->Doucment Types->选择x86 Assemble，再在右边File Filter里输入*.S。然后project-->add and remove project files,再重新把工程的所有文件夹添加一遍，这样就可以把*.S文件添加进来了（注：原来的*.c等文件不会被重复添加），然后重新rebuild就可以了。
其他文件如Makefile，也可以采用如上方法添加支持！
