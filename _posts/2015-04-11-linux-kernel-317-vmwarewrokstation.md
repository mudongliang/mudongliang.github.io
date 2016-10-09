---
layout: post
title: "为 Linux Kernel 3.17 打补丁，使 VMwareWrokstation 正常运行"
date: 2015-04-11
description: ""
category: 
tags: [linux kernel,3.17,vmware workstation,patch]
---

本人用的 fedora20，安装的是 vmware workstation 10.0.4。在升级内核之后，vmware 虚拟机无法使用，错误提示为 vmnet 模块无法正确编译。

### Step 1

    curl http://pastie.org/pastes/9636106/download -o /tmp/vmware-3.17.patch 

关于这个补丁的问题，我曾经查过，针对于不同的kernel，需要不同的补丁。
可以尝试去 archlinux 的官网找找！我也会在后续的文章中说一下这个问题。 

### Step 2

Rebuilding modules, then extract module sources,

    cd /usr/lib/vmware/modules/source; 
	for i in vmci vmmon vmnet vsock; 
	do 
		tar -xf $i.tar; 
	done 

### Step 3
 
Apply the patch,

	patch -p1 -i /tmp/vmware-3.17.patch 

### Step 4

Recreate the archives,

    for i in *-only; 
	do 
	    tar -cf ${i/-only}.tar $i; 
	done 

### Step 5

Remove leftovers,

    rm -r *-only 

### Step 6

Rebuild modules,

    vmware-modconfig --console --install-all 
Or
    reboot

It's OK.
