---
layout: post
title: "CISCN2017 - babydriver (2)"
date: 2022-02-24
description: ""
category: 
tags: []
---
* TOC
{:toc}

## 遗留问题

之前的漏洞利用分析中其实遗留有一个问题：fork 中分配的 [task_struct](https://elixir.bootlin.com/linux/v4.4.72/source/kernel/cred.c#L251) 和 babaydriver_ioctl 中分配的 object 为什么会重合？

```
fork (kernel/fork.c#L1819)
  -> _do_fork (kernel/fork.c#L1724)
    -> copy_process (kernel/fork.c#L1268)
      -> copy_creds (kernel/cred.c#L322)
        -> prepare_creds (kernel/cred.c#L243)
          -> kmem_cache_alloc
```

```
babyioctl
  -> kmalloc
```

为什么会有这个问题呢？因为我发现 `kmem_cache_alloc` 分配的是 `dedicated cache` 或者说 `special cache`。而 `kmalloc` 分配的是 `general cache` or `general purpose cache`。而这两种 cache 是不能交叉使用的，换句话说，kmem_cache_free 执行之后立即执行 `kmalloc` 之后，那块被回收的 object 不会被重新分配。例如，`fork` 中分配的 `special cache` 为下图中的 `cred_jar`, 而 dma_kmalloc-<8k...8>, kmalloc-<8k...8> 属于 `genreal cache`.

```
## tested on Ubuntu 20.04 LTS
# cat /proc/slabinfo
slabinfo - version: 2.1
proc_dir_entry      2310   2310    192   42    2 : tunables    0    0    0 : slabdata     55     55      0
proc_inode_cache   14160  14160    672   48    8 : tunables    0    0    0 : slabdata    295    295      0
shmem_inode_cache   3634   3634    712   46    8 : tunables    0    0    0 : slabdata     79     79      0
kernfs_node_cache  91944  92032    128   32    1 : tunables    0    0    0 : slabdata   2876   2876      0
inode_cache        43038  43038    600   54    8 : tunables    0    0    0 : slabdata    797    797      0
......
cred_jar           17220  17220    192   42    2 : tunables    0    0    0 : slabdata    410    410      0
dma-kmalloc-8k         0      0   8192    4    8 : tunables    0    0    0 : slabdata      0      0      0
......
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc-8k          1060   1084   8192    4    8 : tunables    0    0    0 : slabdata    271    271      0
......
kmalloc-8          29696  29696      8  512    1 : tunables    0    0    0 : slabdata     58     58      0
```

那么，现在问题来了？为什么之前帖子中的漏洞利用可以正常工作呢？

经过重新检查 CISCN2017 babydriver 中的虚拟机，我发现 `slabinfo` 中并没有 `cred_jar`。

```
/ # cat /proc/slabinfo | grep "cred_jar"
```

## References

[1] [WCTF 2018 klist解题思路](http://p4nda.top/2018/11/27/wctf-2018-klist/)
