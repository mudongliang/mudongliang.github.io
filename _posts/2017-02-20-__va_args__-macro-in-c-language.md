---
layout: post
title: "__VA_ARGS__ macro in C language"
date: 2017-02-20
description: ""
category: 
tags: []
---

在 GNU C 中，宏可以接受可变数目的参数，就象函数一样，例如: 

```c
#define pr_debug(fmt,arg...) \ 
printk(KERN_DEBUG fmt, ##arg)
```

用可变参数宏(variadic macros)传递可变参数。你可能很熟悉在函数中使用可变参数，如:

```c
void printf(const char* format, ...);
```

C99 编译器标准允许你可以定义可变参数宏(variadic macros)，这样你就可以使用拥有可变参数的宏。可变参数宏就像下面这个样子:

```c
#define debug(...) printf(__VA_ARGS__)
```

缺省号代表一个可以变化的参数表。使用保留名 __VA_ARGS__ 把参数传递给宏。当宏的调用展开时，实际的参数就传递给 printf() 了。例如: 

```c
debug("Y = %d\n", y);
```

而预处理器会把宏的调用替换成: 

```c
printf("Y = %d\n", y);
```

因为debug()是一个可变参数宏，你能在每一次调用中传递不同数目的参数: 

```c
debug("test"); // 一个参数
```

可变参数宏不被 ANSI/ISO C++ 所正式支持。因此，你应当检查你的编译器，看它是否支持这项技术。

用 GCC 和 C99 的可变参数宏， 更方便地打印调试信息

GCC 的预处理提供的可变参数宏定义真是好用: 

```
#ifdef DEBUG 
#define dbgprint(format,args...) \ 
fprintf(stderr, format, ##args) 
#else 
#define dbgprint(format,args...) 
#endif
```

如此定义之后，代码中就可以用`dbgprint`了，例如`dbgprint("%s", __FILE__);`

下面是 C99 的方法: 

```c
#define dgbmsg(fmt,...)     printf(fmt, __VA_ARGS__)
```

新的 C99 规范支持了可变参数的宏, 具体使用如下:

以下内容为程序代码:

```c
#include <stdarg.h> 
#include <stdio.h> 
#define  

#ifdef DEBUG 
#define LOG(fm, ...) printf(fm, __VA_ARGS__)

/*
 * or choose to standard error output
 * #define LOG(fm, ...) fprintf(stderr, fm, __VA_ARGS__)
 */

#else
#define LOG(fm, ...)
#endif

int main() 
{ 
    LOG("hello, %d ", 10); 
    return 0; 
}
```
