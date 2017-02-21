---
layout: post
title: "深入C语言可变参数(va_arg,va_list,va_start,va_end)"
date: 2017-02-20
description: ""
category: 
tags: []
---

一、什么是可变参数

在C语言编程中有时会遇到一些参数个数可变的函数，例如`printf(),scanf()`函数，其函数原型为： 

```c
int printf(const char* format,…)
int scanf(const char *format,…)
```

它除了有一个参数format固定以外，后面跟着的参数的个数和类型是可变的(用三个点“…”做参数占位符)

二、简单的可变参数例子

```c
#include <stdio.h>
#include <stdarg.h>

void print_args(int count, ...);

int main(int argc, char* argv[]) {
	print_args(5,1,2,3,4,5);
	return 0; 
}

void print_args(int count, ...) {
	int i, value;
	va_list arg_ptr;
	va_start(arg_ptr, count);
	for(i=0; i<count; i++) {
		value = va_arg(arg_ptr,int);
		printf("position %d = %d\n", i+1, value);
	}
	va_end(arg_ptr);
}
```

三、对va_arg,va_list,va_start,va_end剖析

可变参数用到以下宏函数:

原型： void va_start(va_list arg_ptr, prev_param);
功能：以固定参数的地址为起点确定变参的内存起始地址，获取第一个参数的首地址

返回值：无

原型：va_list 类型的变量，va_list arg_ptr ,这个变量是指向参数地址的指针，因为得到参数的地址之后，再结合参数的类型，才能得到参数的值。

原型：type va_arg(va_list arg_ptr, type);
功能：获取下一个参数的地址
返回值：根据传入参数类型决定返回值类型

原型：void  va_end(va_list arg_ptr);
功能：将 arg_ptr 指针置0
返回值：无

对应于上面的实例，参见下面的示意图，即可明白，

```
|   5	|		|   5	|		/\	|   5	| <--arg_ptr
|   4	|		|   4	|		||	|   4	|
|   3	|		|   3	|		||	|   3	|
|   2	|		|   2	|		||	|   2	| 
|   1	|		|   1	| <-- arg_ptr	||	|   1	|
|   5	|   <-- count 	|   5	|   <-- count	||	|   5	|   <-- count
```

这三个宏的实现细节，可参见下面的 blog：

[1] [C中可变参数函数实现](http://blog.csdn.net/swell624/article/details/3211161)

[2] [内存对齐 _INTSIZEOF(n)](http://blog.csdn.net/swell624/article/details/3210779)
