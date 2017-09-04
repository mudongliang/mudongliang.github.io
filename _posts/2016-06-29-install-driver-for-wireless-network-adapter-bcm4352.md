---
layout: post
title: "Install driver for Wireless Network Adapter BCM4352"
date: 2016-06-29
description: ""
category: 
tags: []
---

## Check type of wireless network adapter

A small tip to check the type of wireless network adapter:

```
$ lspci -k | grep -i "wireless"
02:00.0 Network controller: Broadcom Corporation BCM4352 802.11ac
Wireless Network Adapter (rev 03)
        Subsystem: Dell BCM4352 802.11ac Wireless Network Adapter
```

For this wireless network adapter `BCM4352`, we need Broadcom wireless LAN driver (wl, aka broadcom-sta). The proprietary Broadcom wireless LAN driver (wl, aka broadcom-sta) provides support for some Broadcom-based PCI/PCIe hardware. It includes a binary-only component targeted for the x86 or x86-64 architecture. Supported devices are listed as follows:

Supported Devices : **Broadcom BCM4311, BCM4312, BCM4313, BCM4321, BCM4322, BCM43224, BCM43225, BCM43227, BCM43228, BCM43142, BCM4331, `BCM4352`, BCM4360**

## wl installation


### Add a "non-free" component to /etc/apt/sources.list

Add "non-free" component to the mirror file - `/etc/apt/sources.list` for your Debian version

```
# Debian 8 "Jessie"
deb http://httpredir.debian.org/debian/ jessie main contrib non-free
```

```
# Debian 9 "stretch"
deb http://httpredir.debian.org/debian/ stretch main contrib non-free
```
### Install linux-image, linux-headers and broadcom-sta-dkms packages

```
# apt-get update
# apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

This will also install the recommended wireless-tools package.
DKMS will build the wl module for your system.
```

### Unload conflicting modules

```
# modprobe -r b44 b43 b43legacy ssb brcmsmac bcma
```

### Load the wl module

```
# modprobe wl
```

### Configure your wireless interface as appropriate.

## References

[Debian Wiki: wl](https://wiki.debian.org/wl)
