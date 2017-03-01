---
layout: post
title: "Linux内核之双向链表 - list_head(4)"
date: 2015-10-05
description: ""
category: 
tags: []
---

### list_for_each_entry_reverse

```
/**
 * list_for_each_entry_reverse - iterate backwards over list of given type.
 * @pos: the type * to use as a loop cursor.
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 */
#define list_for_each_entry_reverse(pos, head, member)                  \
     for (pos = list_last_entry(head, typeof(*pos), member);         \
            &pos->member != (head);                                    \
          pos = list_prev_entry(pos, member))

/**
 * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
 * @pos: the type * to use as a start point
 * @head: the head of the list
 * @member: the name of the list_head within the struct.
 *
 * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
*/
#define list_prepare_entry(pos, head, member) \
        ((pos) ? : list_entry(head, typeof(*pos), member))
```

### list_for_each_entry_continue

```
/**
 * list_for_each_entry_continue - continue iteration over list of given type
 * @pos: the type * to use as a loop cursor.
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 *
 * Continue to iterate over list of given type, continuing after
 * the current position.
 */
#define list_for_each_entry_continue(pos, head, member)                 \
    for (pos = list_next_entry(pos, member);                        \
          &pos->member != (head);                                    \
          pos = list_next_entry(pos, member))

 /**
 * list_for_each_entry_continue_reverse - iterate backwards from the given point
 * @pos: the type * to use as a loop cursor.
 * @head: the head for your list.
* @member: the name of the list_head within the struct.
*
 * Start to iterate over list of given type backwards, continuing after
 * the current position.
*/
#define list_for_each_entry_continue_reverse(pos, head, member)         \
       for (pos = list_prev_entry(pos, member);                        \
           &pos->member != (head);                                    \
           pos = list_prev_entry(pos, member))
```

### list_for_each_entry_from 

```
/**
 * list_for_each_entry_from - iterate over list of given type from the current point
 * @pos: the type * to use as a loop cursor.
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 *
 * Iterate over list of given type, continuing from current position.
 */
#define list_for_each_entry_from(pos, head, member)          \
      for (; &pos->member != (head);                     \
          pos = list_next_entry(pos, member))

 /**
 * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
 * @pos: the type * to use as a loop cursor.
  * @n: another type * to use as temporary storage
 * @head: the head for your list.
  * @member: the name of the list_head within the struct.
 */
#define list_for_each_entry_safe(pos, n, head, member)                  \
        for (pos = list_first_entry(head, typeof(*pos), member),        \
               n = list_next_entry(pos, member);                       \
            &pos->member != (head);                                    \
             pos = n, n = list_next_entry(n, member))
```

### list_for_each_entry_safe_continue & list_for_each_entry_safe_from

```
/**
 * list_for_each_entry_safe_continue - continue list iteration safe against removal
 * @pos: the type * to use as a loop cursor.
 * @n: another type * to use as temporary storage
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 *
 * Iterate over list of given type, continuing after current point,
 * safe against removal of list entry.
 */
#define list_for_each_entry_safe_continue(pos, n, head, member)       \
    for (pos = list_next_entry(pos, member),                        \
         n = list_next_entry(pos, member);                          \
         &pos->member != (head);                                 \
         pos = n, n = list_next_entry(n, member))
 /**
 * list_for_each_entry_safe_from - iterate over list from current point safe against removal
 * @pos: the type * to use as a loop cursor.
 * @n: another type * to use as temporary storage
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 *
 * Iterate over list of given type from current point, safe against
 * removal of list entry.
 */
#define list_for_each_entry_safe_from(pos, n, head, member)                     \
    for (n = list_next_entry(pos, member);                                  \
        &pos->member != (head);                                            \
        pos = n, n = list_next_entry(n, member))
```

### list_for_each_entry_safe_reverse & list_safe_reset_next

```
/**
 * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
 * @pos: the type * to use as a loop cursor.
 * @n: another type * to use as temporary storage
 * @head: the head for your list.
 * @member: the name of the list_head within the struct.
 *
 * Iterate backwards over list of given type, safe against removal
 * of list entry.
 */
#define list_for_each_entry_safe_reverse(pos, n, head, member)      \
    for (pos = list_last_entry(head, typeof(*pos), member),        \
           n = list_prev_entry(pos, member);                      \
           &pos->member != (head);                             \
           pos = n, n = list_prev_entry(n, member))
 /**
 * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
 * @pos: the loop cursor used in the list_for_each_entry_safe loop
 * @n: temporary storage used in list_for_each_entry_safe
 * @member: the name of the list_head within the struct.
 *
 * list_safe_reset_next is not safe to use in general if the list may be
 * modified concurrently (eg. the lock is dropped in the loop body). An
 * exception to this is if the cursor element (pos) is pinned in the list,
 * and list_safe_reset_next is called after re-taking the lock and before
 * completing the current iteration of the loop body.
 */
#define list_safe_reset_next(pos, n, member)                \
    n = list_next_entry(pos, member)
```
