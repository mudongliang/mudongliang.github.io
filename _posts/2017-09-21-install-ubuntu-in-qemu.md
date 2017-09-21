---
layout: post
title: "install ubuntu in qemu"
date: 2017-09-21
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Installation

Creating a disk image of 10G to hold ubuntu

```
 $ qemu-img create -f qcow2 Ubuntu_Xenial-amd64.img 30G
```

Confirm both disk image and ubuntu’s iso image at same directory

```
$ qemu-system-x86_64 -hda Ubuntu_Xenial-amd64.img -boot d 
  -cdrom ubuntu-16.04.3-server-amd64.iso -m 512 -enable-kvm
```

- `qemu-system-x86_64` – normal qemu command represented for x86_64 machine

- `-hda` – refers to hard disk, here I used the 30G hard disk image

- `-boot [ a | c | d | n ]` – boot from floppy disk(a), hard disk(c), cdrom(d), or etherboot(n). You may note that I used cdrom here. `-cdrom` – use iso image as cdrom to install ubuntu.

- `-m 512` – allocate RAM of 512 MB for the virtual machine.

- `-enable-kvm` – enable KVM virtualization.

## References

[1] [https://en.wikibooks.org/wiki/QEMU/Images](https://en.wikibooks.org/wiki/QEMU/Images)

[2] [https://smdaudhilbe.wordpress.com/2013/04/11/how-to-install-ubuntu-inside-qemu-emulator-and-make-a-virtual-machine/](https://smdaudhilbe.wordpress.com/2013/04/11/how-to-install-ubuntu-inside-qemu-emulator-and-make-a-virtual-machine/)
