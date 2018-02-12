---
layout: post
title: "Install driver for Wireless Network Adapter BCM4352 on Ubuntu"
date: 2017-12-12
description: ""
category:
tags: []
---
* TOC
{:toc}

## Problem
How do we install driver for `Broadcom BCM4352 802.11ac with PCID [14e4:43b1] (rev 03)` on Debian?

## Solution

The most likely driver is `bcmwl-kernel-source`. Let's try again:

```
sudo apt-get update
sudo apt-get install bcmwl-kernel-source
sudo modprobe wl
```

## References

[1] [https://askubuntu.com/questions/590442/how-can-i-install-broadcom-wireless-adapter-bcm4352-802-11ac-pcid-14e443b1-r](https://askubuntu.com/questions/590442/how-can-i-install-broadcom-wireless-adapter-bcm4352-802-11ac-pcid-14e443b1-r)
