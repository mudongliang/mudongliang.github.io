---
layout: post
title: "Syzkaller stretch image troubleshooting"
date: 2019-02-08
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem

I cannot normally boot stretch image when seting up latest syzkaller, and encounter **"You are in emergency mode"**.

The problem is in the issue : [tools/create-image.sh: image does not boot in qemu](https://github.com/google/syzkaller/issues/760)

## Solution

The solution to this problem is add two configurations:

```
CONFIG_CONFIGFS_FS=y
CONFIG_SECURITYFS=y
```

See details in [Syzkaller features](https://github.com/google/syzkaller/blob/master/docs/linux/kernel_configs.md#syzkaller-features)
