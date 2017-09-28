---
layout: post
title: "How to install Ubuntu in GUI with virt manager"
date: 2017-09-21
description: ""
category: 
tags: []
---
* TOC
{:toc}

This article is a continuation of our previous tutorial about [installing QEMU/KVM and virt-manager in Ubuntu]({{site.url}}/2017/09/27/how-to-install-qemu-kvm-qemu-kvm-and-gui-virt-manager-in-ubuntu.html).

## 1. Add New VM

First step, press **A New Virtual Machine** button. This invokes a new window. Select Choose how: Local install media then select Architecture: `i686`. Press **Forward** button. 

![add_new_vm]({{site.url}}/images/add_new_vm.png)

## 2. Add Ubuntu ISO

Second step, locate the ISO image of Ubuntu operating system you want to install. See picture below: 
- (1) press **Browse** button
- (2) select directory source
- (3) select the ISO
- (4) press **Choose Volume** button. 
Remember that it is better if the ISO file is in the same partition as your `$HOME` directory.

![add iso]({{site.url}}/images/add_iso.png)

## 3. Add RAM and CPU Amounts

Third step, adding virtual memory and CPU amounts. We choose **700 MB RAM** and **1 cpu**. This depends on your own hardware capability. It is better to give the guest OS appropriate RAM but leave the host OS handles the most. It is better to don't give guest OS more than half of your total RAM. You may choose more or less. Press **Forward** button. 

![cpu]({{site.url}}/images/cpu.png)

## 4. Add Virtual Disk Storage

Fourth step, create new or select already prepared virtual storage (virtual hard disk). If this is your first time to use KVM, press **Manage** button then follow the next picture.

![disk]({{site.url}}/images/disk.png)

A new window Choose Storage Volume appears. See picture below:

- (1) press green plus button then Add a Storage Volume window appears
- (2) choose the name for the virtual disk storage
- (3) set the storage size
- (4) press Finish button
- (5) select the generic.qcow file just created and press **Choose Volume** button.

![select]({{site.url}}/images/select.png)

## 5. Creating Virtual Machine

Fifth step, you give the name for your virtual machine. For example, we name it Xenial because it runs Ubuntu Xenial Xerus. Select NAT for the Network selection option. 

![create]({{site.url}}/images/create.png)

While pressing **Finish** button, a small dialog appears indicating a progress of creating virtual machine. 

![processing]({{site.url}}/images/processing.png)

## 6. Boot Ubuntu Operating System

After the fifth step, you should find Virtual Machine Manager with QEMU/KVM runs your Ubuntu as virtual OS. See the title bar "Xenial on QEMU/KVM" indicating it is a virtual machine named Xenial running in QEMU/KVM virtualization solution. You find this as Ubuntu OS running another Ubuntu OS. Xenial running Xenial. In this picture, it shows the first step of Ubuntu installation. 

![vm boot]({{site.url}}/images/vm_boot.png)


## References

http://www.ubuntubuzz.com/2016/05/how-to-install-ubuntu-in-qemukvm-virtual-machine.html
