---
layout: post
title: "Difference between C++ Vector wand Array"
date: 2015-04-30
description: ""
category: 
tags: []
---

# C++ Vector与Array 区别

1. array定义后的空间是固定的了，不能改变；而vector要灵活得多，可再加或减.且只能包含整型字面值常量，枚举常量或者用常量
表达式初始化的整型const对象，非const变量以及需要到运行阶段才知道其值的const变量都不能用来定义数组的维度.

2. 数组和vector不同，一个数组不能用另一个数组初始化，也不能将一个数组赋值给另一个数组；

3. 在用下标访问元素时，vector 使用 vector::size_type 作为下标的类型，而数组下标的正确类型则是 size_t；

4. vector 是STL中的容器类，包含多种通用算法,长度可变，使用灵活，但效率稍低.

5. vector有一系列的函数操作，非常方便使用.和vector不同，数组不提供push——back或者其他的操作在数组中添加新元素，数组一经定义就不允许添加新元素；
若需要则要充许分配新的内存空间，再将员数组的元素赋值到新的内存空间。

6. 和vector不同，数组不提供 push——back或者其他的操作在数组中添加新元素，数组一经定义就不允许添加新元素；
若需要则要充许分配新的内存空间，再将员数组的元素赋值到新的内存空间。
