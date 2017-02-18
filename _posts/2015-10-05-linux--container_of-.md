---
layout: post
title: "Linux 内核之 container_of 宏分析"
date: 2015-10-05
description: ""
category: 
tags: []
---

```c
/**
 * container_of - cast a member of a structure out to the containing structure
 * @ptr: the pointer to the member.
 * @type: the type of the container struct this is embedded in.
 * @member: the name of the member within the struct.
 *
 */
#define container_of(ptr, type, member) ({                   \
     const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
     (type *)( (char *)__mptr - offsetof(type,member) );})

```

首先这个宏包含两条语句。

第一句：`const typeof( ((type *)0)->member ) *__mptr = (ptr);`

首先将 0 转化成 type 类型的指针变量（这个指针变量的地址为 0x0 ），然后再引用 member 成员（对应就是 `((type *)0)->member )` ）。注意这里的 typeof(x)，是返回 x 的数据类型，那么 typeof( ((type *)0)->member ) 其实就是返回 member 成员的数据类型。那么这条语句整体就是将 __mptr 强制转换成 member 成员的数据类型，再将 ptr 的值赋给它（而 ptr 本身就是指向 member 的指针）。

第二句：`(type *)( (char *)__mptr - offsetof(type,member) );})`

我们先了解 offsetof 是什么？它也是一个宏,被定义在 linux/include/stddef.h 中，原型为：

```sh
#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
```

下面这个例子想大家说明一下这个 offsetof 这个宏的功能！

```C
struct container{
    int field1;
    char field2;
    char field3;
};

int main()
{
    printf("%p\n", &((struct container*)0)->field3);
    return 0;
}
```

运行结果：

```
0x5
```

这个宏可以获得结构体某一个字段的偏移。

使用第一句话得到的链表数据的地址，同时偏移利用这个 offsetof 宏得到的偏移，将可以获得真正数据结构的起始地址。

总之，container_of 实现了根据一个结构体变量中的一个域成员变量的指针来获取指向整个结构体变量的指针的功能。
