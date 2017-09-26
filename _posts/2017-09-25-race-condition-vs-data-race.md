---
layout: post
title: "Race Condition vs Data Race"
date: 2017-09-25
description: ""
category: 
tags: []
---
* TOC
{:toc}

A race condition is a flaw that occurs when the timing or ordering of events affects a program’s correctness. Generally speaking, some kind of external timing or ordering non-determinism is needed to produce a race condition; typical examples are context switches, OS signals, memory operations on a multiprocessor, and hardware interrupts.

A data race happens when there are two memory accesses in a program where both:

* target the same location
* are performed concurrently by two threads
* are not reads or at least one write
* are not synchronization operations

There are other definitions but this one is fine; it’s from Sebastian Burckhardt at Microsoft Research. Two aspects of the definition require a bit of care. “Concurrently” means there wasn’t anything like a lock that forced one operation to happen before or after the other. “Are not synchronization operations” refers to the fact that a program probably contains special memory operations, such as those used to implement locks, that are not themselves synchronized. By definition, these do not trigger data races.

In practice there is considerable overlap: many race conditions are due to data races, and many data races lead to race conditions. On the other hand, we can have race conditions without data races and data races without race conditions. Let’s start with a simple function for moving money between two bank accounts:

```
transfer1 (amount, account_from, account_to) {
  if (account_from.balance < amount) return NOPE;
  account_to.balance += amount;
  account_from.balance -= amount;
  return YEP;
}
```

Of course this is not how banks really move money, but the example is useful anyway because we understand intuitively that account balances should be non-negative and that a transfer must not create or lose money. When called from multiple threads without external synchronization, this function admits both data races (multiple threads can concurrently try to update an account balance) and race conditions (in a parallel context it will create or lose money). We can try to fix it like this:

```
transfer2 (amount, account_from, account_to) {
  atomic {
    bal = account_from.balance;
  }
  if (bal < amount) return NOPE;
  atomic {
    account_to.balance += amount;
  }
  atomic {
    account_from.balance -= amount;
  }
  return YEP;
}
```

Here “atomic” is implemented by the language runtime, perhaps simply by acquiring a thread mutex at the start of the atomic block and releasing it at the end, perhaps using some sort of transaction, or perhaps by disabling interrupts — for purposes of the example it doesn’t matter as long as the code inside the block executes atomically.

transfer2 has no data races when called by multiple threads, but obviously it is an extremely silly function containing race conditions that will cause it to create or lose money almost as badly as the unsynchronized function. From a technical point of view, the problem with transfer2 is that it permits other threads to see memory states where a key invariant — conservation of money — is broken.

To preserve the invariant, we have to use a better locking strategy. As long as atomic’s semanatics are to end the atomic section on any exit from the block, the solution can be blunt:

```
transfer3 (amount, account_from, account_to) {
  atomic {
    if (account_from.balance < amount) return NOPE;
    account_to.balance += amount;
    account_from.balance -= amount;
    return YEP;
  }
}
```

This function is free of data races and also of race conditions. Can we change it a bit to make an example that has data races but no race conditions? That is simple:

```
transfer4 (amount, account_from, account_to) {
  account_from.activity = true;
  account_to.activity = true;
  atomic {
    if (account_from.balance < amount) return NOPE;
    account_to.balance += amount;
    account_from.balance -= amount;
    return YEP;
  }
}
```

Here we are setting flags indicating that some sort of activity occurred on the accounts. Are the data races on these flags harmful? Perhaps not. For example, in the evening we might shut down all transaction-processing threads and then select 10 random accounts that are flagged as having had activity for manual auditing. For this purpose, the data races are entirely harmless.

We’ve ended up covering all possibilities:

|                   | Data race   | No data race |
| :---------------: | :---------: | :----------: |
| Race condition    | transfer1   | transfer2    |
| No race condition | transfer4   | transfer3    |


The point of this exercise was to look at transfer2 and transfer4, which illustrate that freedom from data races is a very weak property that is neither necessary nor sufficient for establishing the concurrency correctness of a computer program. Why does anyone care about data races at all? As far as I can tell, there are two reasons. First, a data-race-free program can, with some care, be shown to be independent of the whims of whatever weak memory model it sits on. This lets us breathe easier because reasoning about racy programs running on weak memory models is near impossible for humans. Second, data races are easy to find automatically — notice from the definition that it simply requires memory accesses to be monitored; no knowledge of application semantics is required. Race conditions, on the other hand, are intimately tied to application-level invariants, making them far thornier to reason about (quick — what are all the invariants in Firefox? In Linux? In MySQL?).

Everything in this post is pretty obvious, but I’ve observed real confusion about the distinction between data race and race condition by people who should know better (for example because they are doing research on concurrency correctness). Muddying the waters further, even when people are perfectly clear on the underlying concepts, they sometimes say “race condition” when the really mean “data race.” Certainly I’ve caught myself doing this.

## Reference

[1] [https://blog.regehr.org/archives/490](https://blog.regehr.org/archives/490)
