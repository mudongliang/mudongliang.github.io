---
layout: post
title: "Debian Stretch 为 Linux Kernel 4.7 打补丁，使 VMwareWrokstation 正常运行"
date: 2016-10-09
description: ""
category: 
tags: [linux kernel,3.19,vmware workstation,patch]
---

本人用的是Debian Stretch，安装的是 vmware workstation 12.1.1。在升级软件和内核之后，vmware 虚拟机无法使用，错误提示是 GCC 5.4.1 not found。  
问题的原因是这样的，Debian Stretch 默认的 GCC 版本已经成为了 6。你需要做的就是安装 GCC-5，同时使用update-alternatives 使得默认的 GCC 版本为 5。

```
sudo apt-get install gcc-5 g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 20

gcc --version
gcc (Debian 5.4.1-1) 5.4.1 20160803
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

```

解决了这个问题之后，vmware还是无法正常启动，错误提示为 vmnet 模块无法正确编译。

```
cd /usr/lib/vmware/modules/source; 
tar -xf vmnet.tar
cd vmnet-only
sed -i -e 's/dev->trans_start = jiffies/netif_trans_update(dev)/g' netif.c
tar -cf vmnet.tar vmnet-only 
rm -r vmnet-only 
vmware-modconfig --console --install-all 
```

现在就好了。
