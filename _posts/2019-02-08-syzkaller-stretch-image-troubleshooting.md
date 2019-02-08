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

I cannot normally boot stretch image when setting up latest syzkaller, and encounter **"You are in emergency mode"**.

The problem is in the issue : [tools/create-image.sh: image does not boot in qemu](https://github.com/google/syzkaller/issues/760)

## Solution

The solution of this problem is to add two configurations:

```
CONFIG_CONFIGFS_FS=y
CONFIG_SECURITYFS=y
```

See details in [Syzkaller features](https://github.com/google/syzkaller/blob/master/docs/linux/kernel_configs.md#syzkaller-features)

**Note:** if you only enable such two configurations, you will encounter "Failed to start Raise network interfaces" when booting the image. However, if you add kernel configurations listed in the syzkaller setup page, it will work perfectly. I don't know why, but it works.
