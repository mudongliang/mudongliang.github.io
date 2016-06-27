---
layout: post
title: "StackArmor: Comprehensive Protection from Stack-based Memory Error Vulnerabilities for Binaries"
date: 2015-05-28
description: ""
category: 
tags: []
---

StackArmor Comprehensive Protection from Stack-based Memory Error Vulnerabilities for Binaries来自于NDSS 15！

1.简介

![StackArmor]({{site.url}}/images/sdd.png)

StackArmor的整体架构需要三个分析模块，一个二进制重写工具，一个安全分配器！分析模块为二进制重写提供支持，同时分配器被应用去确定栈帧分配的不可预测性。这三个分析模块静态地分析二进制中的每一个函数，并且决定它需要什么类型的保护。

栈保护（SP）分析器保守地决定哪个函数不能被证明免受空间或者时间（Use-after-free）上的攻击，所以需要随机化和隔离的栈帧。

确定赋值（DA）分析器列出来所有无法证明免受为初始化读攻击的函数。当这样的函数被调用之后，StackArmor将相关的栈对象以0初始化。

![DA unsafe functions]({{site.url}}/images/abcd.png)

缓存引用（BR）分析器确定栈上缓存（和它们的引用）都可以安全地重定位。这个策略被用于隔离原栈上可能有漏洞的栈缓存，并且防止栈帧内部的空间攻击。

StackArmor使用能够二进制重写工具来插桩所有不能被证明安全的函数。它将为每一个函数和每一个栈缓存创建一个新的栈帧，同时栈帧分配器保证运行时栈帧会以一种不可预测的形式被分配。

这样我们的最终程序就生成了！

2.实现

具体实现

3.问题讨论

抛出问题
