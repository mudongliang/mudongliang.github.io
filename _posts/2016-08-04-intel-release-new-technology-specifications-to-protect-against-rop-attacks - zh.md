---
layout: post
title: "因特尔发布新的技术规范去防御 ROP 攻击"
date: 2016-08-04
description: ""
category: 
tags: []
---

因特尔长期同软件社区合作，并且在对运行在现代电脑系统上的操作系统和软件的加固保护上有很大进展。因为这些防御发挥作用，敌人开始寻找创造性的替代攻击方法来绕过这些防御。Return Oriented Programming (也称为 ROP)和 Jump Oriented Programming(也称为 JOP)就是两种变得流行的这类技术。JOP 和 ROP 特别难以检测或防御，因为攻击者以一种创造性的方式使用在可执行内存中的已有代码来修改程序行为。ROP/JOP 难以防御的原因是攻击者使用在可执行内存中的已有代码的事实。很多基于软件的检测和防御技术已经被开发和部署，只是收效甚微。

[因特尔和微软已经意识到 ROP 攻击的危害性](http://twitter.com/home/?status=Intel%20and%20Microsoft%20recognized%20the%20seriousness%20of%20ROP%20attacks%20https%3A%2F%2Fblogs.intel.com%2Fevangelists%2F2016%2F06%2F09%2Fintel-release-new-technology-specifications-protect-rop-attacks%2F%20@IntelSWevents%20%23InfoSec) 以及开发防御 ROP/JOP 的方法的难度。总之，我们考虑过超多十项的技术创新来处理这些最近7年内新兴的威胁，并且将它缩小到 x86/x64 的 CET 标准来更有效地处理 ROP 威胁。基于之前定义 ISA(Instruction Set Architecture) 以及启用新 ISA 的挑战的经验，我们把目标定在拥有一个为 ROP/JOP 防御而设计的 ISA，并且它对于大部分设计良好的软件是透明，需要很小的，甚至零修改；然而允许撤销对于需要修改软件的能力。

我们也想确认这个解决方案并不只是适用于应用，还适用于操作系统内核，并且有益于用大多数编程语言写的软件。我们也想确保开启了 CET 的软件可以无修改地在老的平台系统（legacy platforms）上运行（虽然没有任何安全益处）。最终，也是最重要的，我们想去处理所有已经的 ROP/JOP 攻击。

虽然我们在这里包含一个 CET 的简答描述，但是没有什么能够替代仔细阅读[完整标准](https://software.intel.com/en-us/isa-extensions/cet-preview)。这里我们强调两个 ISA 关键的方面来帮助你开始，即是 shadow stack 和 indirect branch tracking. CET是这两者的结合，而这两者都是为了处理 ROP 和 JOP 而设计的。

除了用于控制转移和数据的传统栈，CET 定义第二个栈（shadow stack），专门用于控制转移操作。当CET 启用的时候，`CALL` 指令除了完成它把返回地址压入普通栈的正常行为（对于传统的栈操作没有改变）之外，还把返回地址压入到 shadow stack 中。return 指令（比如说，`RET`）会将 shadow stack 和传统栈上的返回地址弹出，同时只有当两个栈的返回地址相同时才会执行控制转移为弹出来的地址。对于 shadow stack 的写操作有诸多的限制使得攻击者通过修改页表来修改两个栈上的返回地址变得更加困难。因此限制 shadow stack 仅用于 call 和 return 操作就是为了只存储返回地址。通过防御无意识的或者恶意的切换 shadow stack 或者对于 shadow stack 的 overflow 和 underflow，shadow stack 的页表保护机制也是设计用于保护 shadow stack 的完整性。

ENDBRANCH 指令是为了标记一个间接分支或者跳转而新添加到 ISA 的指令。因此如果 ENDBRANCH 不是一个间接分支或者跳转的目标，CPU 生成一个表明无意识的或者恶意的行为异常。为了后向兼容和软件的提前启用，这个特定的指令已经在当前的 Intel 处理器被实现为 NOP 指令（类似于一些 MPX 指令）。 

正如我们过去有的，因特尔努力去最小化对安全特性的性能影响，CET也不例外，然而，请记住性能影响高度依赖于特定软件和工作负担。

最后，我们想承认一点，这个标准受益于同微软大量的合作。