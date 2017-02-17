---
layout: post
title: "use dd to create live bootable usb"
date: 2017-02-17
description: ""
category: 
tags: [dd,debian]
---

1.use `lsblk` to show which device is your usb device, make sure you have found the right device.

```
$ lsblk
sda           8:0    1  29.1G  0 disk 
└─sda1        8:1    1  29.1G  0 part /media/mdl/U
nvme0n1     259:0    0 238.5G  0 disk 
├─nvme0n1p1 259:1    0    28G  0 part /
├─nvme0n1p2 259:2    0     1K  0 part 
├─nvme0n1p5 259:3    0  15.7G  0 part [SWAP]
└─nvme0n1p6 259:4    0 194.9G  0 part /home
```

2.if your usb is mounted, just umount it

```sh
sudo umount /dev/sdX
```

3.use `dd` to write image to your usb device

```sh
sudo dd if=/path/to/ubuntu.iso of=/dev/sdX bs=4M && sync
```
