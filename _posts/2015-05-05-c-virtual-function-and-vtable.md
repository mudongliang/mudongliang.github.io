---
layout: post
title: "C++ Virtual Function and Vtable"
date: 2015-05-05
description: ""
category: 
tags: []
---

# C++中的虚函数与VTABLE

在面向对象的编程中，首先会针对数据进行抽象（确定基类）和继承（确定派生类），构成类层次。这个类层次的使用者在使用它们的时候，如果仍然在需要基类的时候写针对基类的代码，在需要派生类的时候写针对派生类的代码，就等于类层次完全暴露在使用者面前。如果这个类层次有任何的改变（增加了新类），都需要使用者"知道"（针对新类写代码）。这样就增加了类层次与其使用者之间的耦合，有人把这种情况列为程序中的 "bad smell" 之一。

什么是虚函数呢，我们先来看看微软的解释：
虚函数是指一个类中你希望重载的成员函数，当你用一个基类指针或引用指向一个继承类对象的时候，你调用一个虚函数，实际调用的是继承类的版本。

编译器是如何针对虚函数产生可以再运行时刻确定被调用函数的代码呢？也就是说，虚函数实际上是如何被编译器处理的呢？ Lippman 在深度探索`C++`对象模型中的不同章节讲到了几种方式，这里把"标准的"方式简单介绍一下。
"标准"方式，也就是所谓的 "VTABLE" 机制。编译器发现一个类中有被声明为 virtual 的函数，就会为其搞一个虚函数表，也就是`VTABLE`。`VTABLE`实际上是一个函数指针的数组，每个虚函数占用这个数组的一个`slot`。一个类只有一个`VTABLE`，不管它有多少个实例。派生类有自己的`VTABLE`，但是派生类的`VTABLE`与基类的`VTABLE`有相同的函数排列顺序，同名的虚函数被放在两个数组的相同位置上。在创建类实例的时候，编译器还会在每个实例的内存布局中增加一个`vptr`字段，该字段指向本类的`VTABLE`。通过这些手段，编译器在看到一个虚函数调用的时候，就会将这个调用改写。

注意：
1.`override`是指派生类重写基类的虚函数。重写的函数必须有一致的参数表和返回值（C++标准允许返回值不同的情况，但是很少编译器支持这个`feature`）。这个单词好象一直没有什么合适的中文词汇来对应，有人译为"覆盖"，还贴切一些。
`overload`约定成俗的被翻译为"重载"。是指编写一个与已有函数同名但是参数表不同的函数。例如一个函数即可以接受整型数作为参数，也可以接受浮点数作为参数。
2.基类的析构函数都必须是`virtual`的。
3.要虚函数发挥作用，必须用基类的指针（或引用）指向派生类的对象，并用指针（或引用）调用虚函数。也就是说，只有用地址才能体现运行多态性。因为不论是指向基类还是指向派生类的指针（引用），大小都是一样的，这样才能用基类指针指向派生类对象。这时，指针提供的信息是不完全的，在编译阶段不知道应该调用虚函数的哪个版本。而如果用对象调用虚函数，由于类型已经确定了，因此编译系统很可能采用预绑定。指向基类的指针，可以指向它的公有派生的对象，但不能指向私有派生的对象；只能利用它直接访问派生类从基类继承来的成员，不能直接访问公有派生类中特定的成员；不能将指向派生类对象的指针指向其基类的一个对象。

转载自[http://sftp.bokee.com/290252.html](http://sftp.bokee.com/290252.html)