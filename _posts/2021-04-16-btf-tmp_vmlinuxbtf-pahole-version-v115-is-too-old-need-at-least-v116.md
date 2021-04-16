---
layout: post
title: "BTF: .tmp_vmlinux.btf: pahole version v1.15 is too old, need at least v1.16"
date: 2021-04-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem Statement

```
BTF: .tmp_vmlinux.btf: pahole version v1.15 is too old, need at least v1.16
Failed to generate BTF for vmlinux
Try to disable CONFIG_DEBUG_INFO_BTF
make: *** [Makefile:1199: vmlinux] Error 1
```

## Solutions

1. Disable `CONFIG_DEBUG_INFO_BTF`, and recompile Linux kernel.

2. Install the higher version of dwarves deb package (v1.17) on Ubuntu 20.04 LTS.

```
wget http://archive.ubuntu.com/ubuntu/pool/universe/d/dwarves-dfsg/dwarves_1.17-1_amd64.deb
sudo gdebi dwarves_1.17-1_amd64.deb
```

## References
[1] <https://askubuntu.com/questions/1280414/btf-tmp-vmlinux-btf-pahole-version-v1-15-is-too-old-need-at-least-v1-16>
