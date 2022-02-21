---
layout: post
title: "How to contribute to openEuler kernel project"
date: 2021-07-08
description: ""
category: 
tags: []
---
* TOC
{:toc}

1. Develop patches for security vulnerabilities

2. Generate patches with `git format-patch`

3. Send your patches to openEuler mailing list with `git send-email`

For more information, please refer other posts [1](https://mudongliang.github.io/2018/03/20/setting-up-git-send-email-with-gmail-to-send-linux-kernel-patch.html) [2](https://mudongliang.github.io/2018/03/20/one-simple-patch-to-linux-kernel.html) ...

4. Mark "v1, v2, v3 ..." in your patch subject if you have multiple versions
   to send out, and write the changelog below "---"

5. Upstream your kernel patch to kernel community is strongly recommended.
   openEuler will sync up with kernel master timely.

## References

[1] https://gitee.com/openeuler/kernel/tree/kernel-4.19/

[2] https://git-scm.com/docs/git-send-email
