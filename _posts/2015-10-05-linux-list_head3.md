---
layout: post
title: "Linux内核之双向链表 - list_head(3)"
date: 2015-10-05
description: ""
category: 
tags: []
---

### list_entry

内核中的链表仅仅保存了`list_head`结构的地址，我们如何通过它获取一个链表节点真正的数据项的地址？

以下的list_entry宏可以完成这个目的，这个宏里面使用内核中比较重要的一个宏，[container_of](http://mudongliang.github.io/2015/10/05/linux-container_of.html) 。

`list_entry`宏：从链表项地址获得包含这个链表项的真正数据结构的地址！

```
/**
 * list_entry - get the struct for this entry
 * @ptr: the &struct list_head pointer.
 * @type: the type of the struct this is embedded in.
 * @member: the name of the list_head within the struct.
 */
#define list_entry(ptr, type, member) \
           container_of(ptr, type, member)
```

### list_first_entry & list_last_entry


获取第一个和最后一个元素所以真正数据结构的起始地址，可以用于遍历时初始循环变量和最后比对。

`list_first_entry`宏：获得链表第一个元素所在的真正数据结构的起始地址！

`list_last_entry`宏：获得链表最后一个元素所在的真正数据结构的起始地址！

```
/**
 * list_first_entry - get the first element from a list
 * @ptr: the list head to take the element from.
 * @type: the type of the struct this is embedded in.
 * @member: the name of the list_head within the struct.
 *
 * Note, that list is expected to be not empty.
 */
#define list_first_entry(ptr, type, member) \
             list_entry((ptr)->next, type, member)
/**
 * list_last_entry - get the last element from a list
 * @ptr: the list head to take the element from.
 * @type: the type of the struct this is embedded in.
 * @member: the name of the list_head within the struct.
 *
 * Note, that list is expected to be not empty.
 */
#define list_last_entry(ptr, type, member) \
           list_entry((ptr)->prev, type, member)
```

### list_next_entry & list_prev_entry

获取下一个和上一个元素所以真正数据结构的起始地址，可以用于遍历时初始循环变量向后或向前。

`list_next_entry`宏：获得链表下一个元素所在的真正数据结构的起始地址！

`list_prev_next`宏：获得链表上一个元素所在的真正数据结构的起始地址！

```
/**
 * list_next_entry - get the next element in list
 * @pos: the type * to cursor
 * @member: the name of the list_head within the struct.
 */
#define list_next_entry(pos, member) \
        list_entry((pos)->member.next, typeof(*(pos)), member)
/**
 * list_prev_entry - get the prev element in list
* @pos: the type * to cursor
 * @member: the name of the list_head within the struct.
 */
 #define list_prev_entry(pos, member) \
        list_entry((pos)->member.prev, typeof(*(pos)), member)
/**
 * list_first_entry_or_null - get the first element from a list
 * @ptr: the list head to take the element from.
 * @type: the type of the struct this is embedded in.
 * @member: the name of the list_head within the struct.
 *
 * Note that if the list is empty, it returns NULL.
 */
#define list_first_entry_or_null(ptr, type, member) \
       (!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)
```

### list_for_each

`head`是整个链表的头指针，同时`pos`是链表类型的指针，且通过`next`指针不停地往后移动。用于简单的链表循环。

```
/**
 * list_for_each - iterate over a list
 * @pos: the &struct list_head to use as a loop cursor.
 * @head: the head for your list.
 */
#define list_for_each(pos, head) \
        for (pos = (head)->next; pos != (head); pos = pos->next)
/**
 * list_for_each_safe - iterate over a list safe against removal of list entry
 * @pos: the &struct list_head to use as a loop cursor.
 * @n: another &struct list_head to use as temporary storage
 * @head: the head for your list.
 */
#define list_for_each_safe(pos, n, head) \
    for (pos = (head)->next, n = pos->next; pos != (head); \
            pos = n, n = pos->next)
```

### list_for_each_entry

`head`是整个链表的头指针，同时`pos`是真正数据结构类型的指针，且通过`next`指针和`list_next_entry`不停地 往后移动，而`member`是真正数据类型中链表类型的名字，这个变量真正需要用在`container_of`宏中。用于很好用的链表循环，无需自己使用`list_entry`来获得真正数据结构类型的起始地址。

```
/**
 * list_for_each_entry - iterate over list of given type
 * @pos: the type * to use as a loop cursor.
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 */
#define list_for_each_entry(pos, head, member)                     \
    for (pos = list_first_entry(head, typeof(*pos), member);        \
            &pos->member != (head);                            \
            pos = list_next_entry(pos, member))
list_for_each_entry(fmt, &formats, lh) {
    if (!try_module_get(fmt->module))
        continue;
    read_unlock(&binfmt_lock);
    bprm->recursion_depth++;
    retval = fmt->load_binary(bprm);
    read_lock(&binfmt_lock);
    ......
}
```

以上的代码的内容是遍历formats链接的双向链表，使用的就是list_for_each_entry.

### list_for_each_prev & list_for_each_prev_safe

```
/**
* list_for_each_prev - iterate over a list backwards
* @pos: the &struct list_head to use as a loop cursor.
 * @head: the head for your list.
 */
 #define list_for_each_prev(pos, head) \
        for (pos = (head)->prev; pos != (head); pos = pos->prev)

/**
 * list_for_each_prev_safe - iterate over a list backwards 
 * safe against removal of list entry
 * @pos: the &struct list_head to use as a loop cursor.
 * @n: another &struct list_head to use as temporary storage
 * @head: the head for your list.
 */
#define list_for_each_prev_safe(pos, n, head) \
    for (pos = (head)->prev, n = pos->prev; \
         pos != (head); \
         pos = n, n = pos->prev)
```
