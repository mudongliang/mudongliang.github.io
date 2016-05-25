---
layout: post
title: "Fedora21 编译 Linux Kernel 4.0"
date: 2015-06-06
description: ""
category: 
tags: []
---

我使用的是Fedora21,其中内核版本（缩略）为：

```sh
#uname -a
Linux 4.0.4-202.fc21.x86_64 #1 SMP x86_64 x86_64 x86_64 GNU/Linux
```

## 1. 安装依赖软件

    # yum install gcc ncurses ncurses-devel

## 2. 下载源代码

    # cd /tmp/
    # wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.0.tar.xz 

## 3. 解压tar压缩包

文件下载好后我们在/usr/src/文件夹下用以下命令解压。

    # tar -xf linux-4.0.tar.xz -C /usr/src/kernels/
    # cd /usr/src/kernels/linux-4.0/

## 4. 配置

配置Linux内核有两种选择的。我们可以创建一个新的自定义配置文件或者使用已有的配置文件来构建和安装Linux内核。这都取决于你自己的需要。
配置新的内核

现在我们在shell或终端中运行make menuconfig命令来配置Linux内核。我们执行以下命令后会显示一个包含所有菜单的弹出窗口。在这里我们可以选择我们新的内核配置。如果你不熟悉这些菜单，那就敲击ESC键两次退出。

    # make config 
    # make menuconfig 基于ncurse库编制的图形界面工具
    # make xconfig 基于X11的图形工具
    # make gconfig 基于gtk+图形工具

已有的配置

如果你想用已有的配置文件配置你最新的内核，那就输入下面的命令。如果你对配置有任何调整，你可以选择Y或者N，或者仅仅是按Enter键继续。

    # make oldconfig 使用旧的配置文件配置新的代码树

在linux内核根目录的README文件中，说明make oldconfig的作用：所有问题都基于已有的.config文件，只对新特性和新设定提出询问；经过做实验发现，使用“make oldconfig”和“make menuconfig”默认生成的.config文件是一致的。实验的方法是使用diff来比对两者默认生成.config！make menuconfig 就是make oldconfig的图形版本，它会将原来oldconfig的选项按照原来的进行标识，新的选项全部使用默认选项标识。在将新的设定更新 到.config中去的同时，将原来的.config文件保存为.config.old。

（P.S. 为什么这里面的编译没有产生询问呢？因为fedora21目前所用内核版本为linux4.0.4，所以你使用旧的config去编译4.0的时候，就不会出现询问，但是如果你使用低于4.0的版本，在编译的时候就会产生很多的询问，可以直接默认，如果你感觉看不懂想要跳过去的话，可以去使用`make menuconfig`）

## 5. 编译Linux内核

下一步，我们会执行make命令来编译内核4.0。取决于你的系统配置，编译至少需要20-30分钟。

**注**：如果编译内核的时候出现`bc command not found`的错误，你可以用`yum install bc`命令安装bc修复这个错误。

    # make

## 6. 安装Linux内核4.0

编译完成后，我们终于要在你的Linux系统上安装内核了。下面的命令会在/boot目录下创建文件并且在Grub 菜单中新建一个内核条目。

    # make modules_install install

## 7. 验证内核

安装完最新的内核4.0后我们希望能验证它。做这些我们只需要在终端中输入以下命令。如果所有都进展顺利，我们会看到内核版本，例如4.0出现在输出列表中。

    # uname -r
