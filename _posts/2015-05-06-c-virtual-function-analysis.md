---
layout: post
title: "C++ Virtual Function Analysis"
date: 2015-05-06
description: ""
category: 
tags: []
---
# C++ 虚函数解析
具体内容请参见[陈浩博客之C++Vtable解析](http://blog.csdn.net/haoel/article/details/1948051/)

我只是为了更加理解这里面说明的要点，所以自己编写了几个对应与他博客内容的几个小demo，大家可以按照这几个demo来进行实验，这样更加方便的理解这里面的知识。如果有什么疑问，大家可以在当前位置提问，或者可以去github上new一个Issue！

这几个demo的对应关系如下所示：

- [testvtable.cpp](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvtable.cpp) ： 没有继承关系的虚函数表的简单分析

- [testvtable1.cpp](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvtable1.cpp) ： 一般继承（无虚函数覆盖）的虚函数表的简单分析

- [testvtable2.cpp](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvtable2.cpp) ： 一般继承（有虚函数覆盖）的虚函数表的简单分析

- [testvtable3.cpp](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvtable3.cpp)： 多重继承（无虚函数覆盖）的虚函数表的简单分析

- [testvtable4.cpp](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvtable4.cpp)： 多重继承（有虚函数覆盖）的虚函数表的简单分析
