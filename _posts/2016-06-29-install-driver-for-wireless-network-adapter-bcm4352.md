---
layout: post
title: "Install driver for Wireless Network Adapter BCM4352"
date: 2016-06-29
description: ""
category: 
tags: []
---

From [Debian Wiki: wl](https://wiki.debian.org/wl)

A small tip to check the type of wireless network adapter:

    #lspci -k | grep -i "wireless"
    02:00.0 Network controller: Broadcom Corporation BCM4352 802.11ac Wireless Network Adapter (rev 03)
            Subsystem: Dell BCM4352 802.11ac Wireless Network Adapter


Supported Devices : **Broadcom BCM4311, BCM4312, BCM4313, BCM4321, BCM4322, BCM43224, BCM43225, BCM43227, BCM43228, BCM43142, BCM4331, `BCM4352`, BCM4360**

## Installation:


#### 1. Add a "non-free" component to /etc/apt/sources.list for your Debian version, for example:

    # Debian 8 "Jessie"
    deb http://httpredir.debian.org/debian/ jessie main contrib non-free

#### 2. Update the list of available packages. Install the relevant/latest linux-image, linux-headers and broadcom-sta-dkms packages:

    # apt-get update
    # apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms

    This will also install the recommended wireless-tools package. DKMS will build the wl module for your system.

#### 3. Unload conflicting modules:

    # modprobe -r b44 b43 b43legacy ssb brcmsmac bcma

#### 4. Load the wl module:

    # modprobe wl

### 5. Configure your wireless interface as appropriate.
