---
layout: post
title: "Usenix 05 Data Attack"
date: 2015-04-16
description: ""
category: 
tags: []
---

Non-Control-Data Attack (Non-Control-Data Attacks Are Realistic Threats) 来自于Usenix 05！

## **简介**

首先，我们先要解释一下什么叫做Non-Control-Data Attack？

目前（2005年）大多数的内存破坏性攻击都遵循所谓的控制数据攻击（Control-Data Attack），因此很多防御技术都被设计成为保护程序的控制流完整性，而所谓的Non-Control-Data Attack在现实世界中是十分稀少。作者对于控制数据攻击（Control-Data Attack）下了一个简单的定义：它们改变目标程序的控制数据（就是那些在程序执行的某一点会被载入到程序计数器中的数据，比如返回地址和函数指针），为了执行注入的恶意代码或者非上下文的库代码（特别的就是return-to-libc attack）。

这篇文章算是一个引子，重点在于Non-Control-Data Attack对现实世界中的应用程序攻击的可行性，主要验证为未来做这方面研究的人打下一个基础。为了证明这个想法，作者对于很多现实中的很多应用程序，包括非常经典的FTP,SSH,HTTP Servers，进行试验、攻击，说明这些应用程序易受到这种攻击的影响。Non-Control-Data Attack破坏一系列的应用数据，比如说用户身份数据，配置数据，用户输入数据，决策数据。这些成功的攻击实例，受影响的应用程序的多样性和目标数据都暗示了其潜在攻击方式的多样性。

这篇论文的主要贡献是Non-Control-Data Attack和Control-Data Attack由于相同的安全漏洞而造成的安全漏洞的危害程度是相同的。

Non-Control-Data Attack的可行性宣称：很多现实中的软件应用程序是很容易被Non-Control-Data Attack影响的，并且其造成的安全漏洞的危害程度是和“Control-Data Attacks”等价的！

配置数据：通常，服务器应用程序处理配置文件来初始化一些内部数据结构在程序运行之前。同时在运行时，这些数据结构会被用于控制应用程序的行为，并且这些数据结构在服务器程序进入服务循环之后基本不会改变！所以破坏这些配置数据结构可以允许攻击者改变甚至是控制目标应用程序的行为。

用户输入：输入有效性检测是在很多应用程序中确保特定安全策略的一个关键的步骤。如果用户输入在有效性验证之后被改变了，攻击者可以攻入系统。我们使用法定的数据通过安全检查点，然后迫使程序使用已经被破坏的数据。这种攻击的方式是TOCTTOU (Time Of Check To Time Of Use)的一种。

用户身份数据：服务器应用通常在给予权力之前需要远程用户认证。这些特权程序在执行认证协议同时通常缓存用户身份信息，比如说用户ID，组ID和内存的访问权力。

> Decision-making Data：Decision-making routines rely on several Boolean variables (conjunction, disjunction, or combination of both) to reach the final verdict. No matter how many steps are involved in the authentication, eventually at a single point in the program control flow, there has to be a conditional branch instruction saying either yes or no to the remote client.

决策数据：决策例程依靠许多布尔变量（合取，析取或者两者的组合）去达成最终裁决。无论在认证中涉及多少步骤，最终在程序控制流的某一点，必然有一个条件分支结构来对远端说yes或者no。

## **实现**

在实现部分，作者对每一种数据进行了实验，证明这些类型都可以实行攻击！

像这种关于验证性的论文，其实现细节一般都是很碎的，所以要搞懂具体的细节，最好还是直接看论文。

## **问题讨论**

这种方案的限制在于以下两处：

1. 需要应用相关的语义知识，需要相当多的细节和基础知识。

2. 安全关键数据的生命周期。众所周知，数据都有自己的生命周期，生命周期的长短决定了它被修改的可能性大小！
