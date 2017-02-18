---
layout: post
title: "Debian 源码安装 NVIDIA 显卡驱动"
date: 2016-02-22
description: ""
category: 
tags: []
---

在安装好系统之后，显卡驱动是开源显卡驱动，想要官方的闭源驱动，而安装官方 `NVIDIA` 显卡驱动会使显示效果更好，今天就以64位的 `Debian Jessie` 和 `GeForce GTX 650` 为例介绍下如何通过源码安装 `NVIDIA` 官方的驱动。

### 安装前的准备工作
         
I. 去 `NVIDIA` 驱动页去下载与自己的显卡相匹配的驱动 [NVIDIA-Linux-x86_64-361.28.run](http://cn.download.nvidia.com/XFree86/Linux-x86_64/361.28/NVIDIA-Linux-x86_64-361.28.run)

II. 安装 build-essential 编译工具；

III. 安装 linux-headers-$(uname -r)；

上述的几步都是非常重要的，少一个都可能导致最后安装不成功。准备工作做好后就可以开始正式安装了。

### 正式安装

1.安装显卡驱动需要在控制台下面进行，第一步就是把当前的X-window(比如gnome等图形界面)停掉.

```sh
#sudo /etc/init.d/gdm3 stop
```

2.进入控制台`Ctrl+Alt+F1`，把驱动的权限设置为可执行的，然后执行该驱动,进入安装界面，

```sh
# sudo chmod -c 777 NVIDIA-Linux-x86_64-319.60.run
# sudo sh NVIDIA-Linux-x86_64-319.60.run
```

### 安装界面

1. 接受 (Accept)；
2. 提示安装出现 error，是因为电脑上已经安装的有驱动，选择 OK；
3. 提示对于一些情况，可以通过写一些配置文件将之前安装的驱动禁止掉，是否愿意让 NVIDIA 执行，这一步选择 Yes；
4. 提示安装失败，需要重启电脑重新安装；
5. 重启后，执行安装程序继续安装，全部选择 Yes。过一会就安装完成；
6. 在最后一步的时候选择是，让 NVIDIA 产品 xconfig 自动更新 xorg.conf 文件 ,至此已完成 NVIDIA 显卡驱动安装；
7. 重启电脑；
