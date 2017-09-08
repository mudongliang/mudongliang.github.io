---
layout: post
title: "how to install driver for TP Link WN722N (EU) V2 on Ubuntu 14.04"
date: 2017-09-06
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Hardware Information

Without driver for this hardware device, you cannot see the property of wireless usb device here.
```
$ lsusb
...
Bus 001 Device 004: ID 2357:010c <= idVendor=2357, idProduct=010c
...
$ sudo lshw -C network
<= No information about such device
```

With driver, you will see notification light turning on and the following message:

```
$ lsusb
...
Bus 001 Device 004: ID 2357:010c <= idVendor=2357, idProduct=010c
...
$ sudo lshw -C network
  *-network
       description: Wireless interface
       physical id: 1
       bus info: usb@1:8
       logical name: wlan1
       serial: d4:6e:0e:08:17:d0
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=r8188eu ip=XXX.XXX.XXX.XXX 
       multicast=yes wireless=IEEE 802.11gn
```

See more information for [TP-LINK TL-WN722N v2](https://wikidevi.com/wiki/TP-LINK_TL-WN722N_v2)

## Install Kernel Module for TP Link WN722N (EU) V2

Make sure that you have install correct compile tool and kernel headers.

```
sudo apt install build-essential linux-headers-$(uname -r) git dkms
```

You could have two methods to compile source code of driver:

- clone driver repository

```
$ git clone https://github.com/lwfinger/rtl8188eu.git
$ cd rtl8188eu
$ make all
$ sudo make install
$ sudo reboot
```
**or**
```
git clone https://github.com/lwfinger/rtl8188eu.git
sudo dkms add ./rtl8188eu
sudo dkms install 8188eu/1.0
sudo modprobe 8188eu
``` 

**The following method is not working in my Ubuntu 14.04.5 LTS. Please try the first method.**

> - Download from website

>     $ wget http://static.tp-link.com/TL-WN722N\(EU\)_V2_161112_Linux.zip
>     $ unzip TL-WN722N\(EU\)_V2_161112_Linux.zip 
>     $ cd rtl8188EUS_linux_v4.3.0.8_13968.20150417/
>     $ make all
>     $ sudo make install
>     $ sudo reboot

See more details in [information webpage for TL-WN722N V2](http://www.tp-link.com/en/download/TL-WN722N_V2.html#Driver); And in the **Driver** tab of this information webpage, you could download source code of driver for `TL-WN722N V2`. I have provided the download link in the Reference section.

## References

[Source Code of Driver for TL-WN722N(EU) V2](http://static.tp-link.com/TL-WN722N(EU)_V2_161112_Linux.zip)

[REAME.md for rtl8188eu](https://github.com/lwfinger/rtl8188eu/blob/master/README.md)

[How to install driver for TP-Link TL-WN722N(EU)V2 on Ubuntu 17.04 Kylin](https://askubuntu.com/questions/900783/how-to-install-driver-for-tp-link-tl-wn722neuv2-on-ubuntu-17-04-kylin)

[TL-WN722N is not recognized](https://askubuntu.com/questions/912498/tl-wn722n-is-not-recognized)
