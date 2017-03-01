---
layout: post
title: "Linux内核之双向链表 - list_head(1)"
date: 2015-10-05
description: ""
category: 
tags: []
---

链表是一种常用的组织有序数据的数据结构，它通过指针将一系列数据节点连接成一条数据链，是线性表的一种重要实现方式。相对于数组，链表具有更好的动态性，建立链表时无需预先知道数据总量，可以随机分配空间，可以高效地在链表中的任意位置实时插入或删除数据。链表的开销主要是访问的顺序性和组织链的空间损失。

通常链表数据结构至少应包含两个域：数据域和指针域，数据域用于存储数据，指针域用于建立与下一个节点的联系。而在`linux`内核中，链表结构只包含指针域，链表的使用方法：作为某个数据结构的一个字段，利用链表结构来链接相同类型的数据。即，这个结构经常作为成员与其他数据类型一起组成一个新的结构体。

很多情况，这个链表结构是数据结构的第一个字段，那么链表的地址就是这个数据结构的起始地址；如果不是的话，可以使用 [container_of](http://mudongliang.github.io/2015/10/05/linux-container_of.html) 来寻找这个数据结构的起始地址。

就比如说`struct linux_binfmt`，`lh`的类型是`struct list_head`，`lh`的起始地址就是`linux_binfmt`的起始地址，

```
struct linux_binfmt {
    struct list_head lh;
    struct module *module;
    int (*load_binary)(struct linux_binprm *);
    int (*load_shlib)(struct file *);
    int (*core_dump)(struct coredump_params *cprm);
    unsigned long min_coredump;     /* minimal dump size */
};

formats  -> |      lh      | -> |     lh       |
         <- |   module     | <- |    module    |
            | load_binary  |    | load_binary  |
            |   ........   |    |  ..........  |
```

在`linux`内核中，双向链表的定义非常简单，定义在 `include/linux/types.h` ：

```
struct list_head {
    struct list_head *next, *prev;
};
```

而双向链表的主要操作定义在 `include/linux/list.h` 。

### 链表初始化

`LIST_HEAD`宏：声明变量，并初始化链表头；

`INIT_LIST_HEAD`函数：初始化链表头。

```
#define LIST_HEAD_INIT(name) { &(name), &(name) }

#define LIST_HEAD(name) \
    struct list_head name = LIST_HEAD_INIT(name)

static inline void INIT_LIST_HEAD(struct list_head *list)
{
    list->next = list;
    list->prev = list;
}
```

**分析：**

```
static LIST_HEAD(formats);
```

展开其中的宏之后，可以得到以下的初始化内容：

```
static struct list_head formats = {&formats, &formats};
```

### 添加元素

`list_add`宏：在链表头结点后添加元素。它可实现栈的添加元素。

`list_add_tail`宏：在链表头结点（链表尾部）前添加元素。它后者可实现队列的添加元素。

```
/**
 * list_add - add a new entry
 * @new: new entry to be added
 * @head: list head to add it after
 *
 * Insert a new entry after the specified head.
 * This is good for implementing stacks.
 */
static inline void list_add(struct list_head *new, struct list_head *head)
{
    __list_add(new, head, head->next);
}
```

```
            head     [head->next]
last ele <- prev   <-    prev
            next   ->    next   -> head
```

执行`list_add(new, head)`之后，

```
            head         new      [head->next]
last ele <- prev   <-    prev   <-    prev
            next   ->    next   ->    next    -> head
```
```
/**
 * list_add_tail - add a new entry
 * @new: new entry to be added
 * @head: list head to add it before
 *
 * Insert a new entry before the specified head.
 * This is useful for implementing queues.
 */
static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
    __list_add(new, head->prev, head);
}
```
```
            head     [head->next]
last ele <- prev   <-    prev
            next   ->    next   -> head
```

执行`list_add_tail(new, head)`之后，

```
            head     [head->next]     new      
last ele <- prev   <-    prev   <-    prev
            next   ->    next   ->    next    -> head
```

这里面有循环链表的内涵，`head`的`prev`指向链表最后一个元素，最后一个元素的`next`指向链表的`head`。

```
static inline void __list_add(struct list_head *new,
                            struct list_head *prev,
                            struct list_head *next)
{
    next->prev = new;
    new->next = next;
    new->prev = prev;
    prev->next = new;
}
```

**分析：**

```
write_lock(&binfmt_lock);
insert ? list_add(&fmt->lh, &formats) :
 list_add_tail(&fmt->lh, &formats);
write_unlock(&binfmt_lock);
```

以上的代码是注册`linux_binfmt`，通过`insert`这个`boolean`值来确定是在formats后面

```
static inline void register_binfmt(struct linux_binfmt *fmt)
{
     __register_binfmt(fmt, 0);
}

static inline void insert_binfmt(struct linux_binfmt *fmt)
{
     __register_binfmt(fmt, 1);
}
```

```
          |formats|             [list_add] | [list_add_tail] 
          list_head    list_head    list_head    list_head
last ele <- prev   <-    prev   <-    prev    <-   prev
            next   ->    next   ->    next    ->   next   -> head
```


### 删除元素

`list_del`宏：从链表中删除某一个元素，被删除元素的`prev`和`next`指向特殊值；

`list_del_init`宏：从链表中删除某一个元素，被删除元素初始化为一个链表。

```
/**
 * list_del - deletes entry from list.
 * @entry: the element to delete from the list.
 * Note: list_empty() on entry does not return true after this, the entry is
 * in an undefined state.
 */
static inline void __list_del_entry(struct list_head *entry)
{
    __list_del(entry->prev, entry->next);
}

static inline void list_del(struct list_head *entry)
{
    __list_del(entry->prev, entry->next);
    entry->next = LIST_POISON1;
    entry->prev = LIST_POISON2;
}

/*
 * These are non-NULL pointers that will result in page faults
 * under normal circumstances, used to verify that nobody uses
 * non-initialized list entries.
 */
#define LIST_POISON1 ((void *) 0x00100100 + POISON_POINTER_DELTA)
#define LIST_POISON2 ((void *) 0x00200200 + POISON_POINTER_DELTA)
```

`prev、next`指针分别被设为`LIST_POSITION2`和`LIST_POSITION1`两个特殊值，这样设置是为了保证不在链表中的节点项不可访问（对`LIST_POSITION1`和`LIST_POSITION2`的访问都将引起页故障）。

**分析：**

```
write_lock(&binfmt_lock);
list_del(&fmt->lh);
write_unlock(&binfmt_lock);
```

以上的代码是注销`linux_binfmt`，这里面就是引用了`list_del`来删除链表中的某一项。

```
/**
 * list_del_init - deletes entry from list and reinitialize it.
 * @entry: the element to delete from the list.
 */
static inline void list_del_init(struct list_head *entry)
{
    __list_del_entry(entry);
    INIT_LIST_HEAD(entry);
}
```

这是一种新的删除操作，对于被删除的元素，重新初始化为一个新的链表头。
