---
layout: post
title: "Patch for Linux Kernel 3.17"
date: 2015-04-11
description: ""
category: 
tags: [linux kernel,3.17,vmware workstation,patch]
---

为 Linux Kernel 3.17 打补丁，使 VMwareWrokstation 正常运行"
本人用的fedora20，安装的是vmware workstation 10.0.4。在升级内核之后，vmware 虚拟机无法使用，错误提示为 vmnet 模块无法正确编译！
步骤 1:

curl http://pastie.org/pastes/9636106/download -o /tmp/vmware-3.17.patch 
很遗憾这个需要翻墙 如果无法下载，可以到我CSDN中的个人资源vmare-patch里面去下载！ 
关于这个补丁的问题，我曾经查过，针对于不同的kernel，需要不同的补丁！
可以尝试去archlinux 的官网找找！我也会在后续的文章中说一下这个问题！ 

步骤 2:

Rebuilding modules, Extract module sources:

cd /usr/lib/vmware/modules/source for i in vmci vmmon vmnet vsock; do tar -xf $i.tar; done 

步骤 3 :

Apply the patch:

 patch -p1 -i /tmp/vmware-3.17.patch 

 步骤 4

 Recreate the archives:

  for i in *-only; do tar -cf ${i/-only}.tar $i; done 

  步骤 5

  Remove leftovers:

   rm -r *-only 

   步骤 6

   Rebuild modules:

   vmware-modconfig --console --install-all 
   或者直接重启一下就可以了！ 然后就成功了!!!
