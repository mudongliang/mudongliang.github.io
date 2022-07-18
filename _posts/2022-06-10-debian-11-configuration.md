---
layout: post
title: "Debian 11 配置"
date: 2022-06-10
description: ""
category: 
tags: []
---
* TOC
{:toc}

## 添加sudo权限
首先，Debian 镜像默认没有安装`sudo`(`apt-get install sudo`)
然后，编辑`/etc/sudoers`(`gedit /etc/sudoers`)

```
root ALL=(ALL) ALL
<your_user_name> ALL=(ALL) ALL
```

## 添加较快源
国内比较快速和稳定的源有以下两种：

- [ftp.cn.debian.org](http://ftp.cn.debian.org/)
- [中科大开源软件镜像](http://mirrors.ustc.edu.cn/)
- [清华大学开源软件镜像站](http://mirrors.tuna.tsinghua.edu.cn/);
- [华为开源镜像站](http://mirrors.huaweicloud.com/);

以中科大开源镜像站为例(以下内容的生成可参考[List Generator](https://mudongliang.github.io/listgenerator/) 或者[Debian 源使用帮助](http://mirrors.ustc.edu.cn/help/debian.html))：

```
deb http://mirrors.ustc.edu.cn/debian bullseye main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian bullseye main contrib non-free
deb http://mirrors.ustc.edu.cn/debian bullseye-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian bullseye-updates main contrib non-free
```
将上述内容写入到 `/etc/apt/sources.list`, 然后 `apt-get update`

## 转换到 Debian Rolling Testing (可选)

将 bullseye 改成 testing 即可，执行 `sudo apt update`

```
deb http://mirrors.ustc.edu.cn/debian testing main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian testing main contrib non-free
deb http://mirrors.ustc.edu.cn/debian testing-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian testing-updates main contrib non-free
```

## 系统清理

### 删除无用软件

```
sudo apt-get purge gnome-2048 aisleriot atomix gnome-chess five-or-more \
hitori iagno gnome-klotski lightsoff gnome-mahjongg gnome-mines \
gnome-nibbles quadrapassel four-in-a-row gnome-robots gnome-sudoku \
swell-foop tali gnome-taquin gnome-tetravex
sudo apt-get purge goldendict anthy kasumi
sudo apt-get autoremove
```

## 美化

### 安装字体

```
sudo apt-get install ttf-freefont ttf-mscorefonts-installer
```

### 去除GNOME难看的边框
 
删除Firefox, Gnome terminal 标题下面的**非常难看**的边框, 

![ugly border line]({{site.url}}/images/noxEnD4.png)

参考本站内的[教程](https://mudongliang.github.io/2016/06/29/remove-the-ugly-border-in-gnome-320.html)

## 安装常用软件

### 安装Openssh server

参见本站内的[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#openssh-server)

### 安装中文输入法 Fcitx

- sogoupinyin (搜狗输入法) 和 googlepinyin (谷歌输入法)

参见[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#fcitx--sogoupinyin)

然后在`fcitx`的`config`中选择对应的中文输入法，`sogoupinyin`。

![sogou]({{site.url}}/images/sougou.png)

最后，可以使用`im-config`来选择你使用的中文输入法。

![im-config]({{site.url}}/images/im-config.png)

**注意：在搜狗输入法的使用过程中，我经常发现搜狗的进程占用100%CPU导致系统非常卡，所以我一般使用Google pinyin**

### 安装Chrome浏览器

从[下载页](https://dl.google.com)下载 Chrome 对应的安装包，同步google账户上的书签，插件，应用程序等。

或者根据本站内的[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#chrome)来通过软件仓库安装。

### 安装 Vagrant 和 VirtualBox

根据本站内的[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#vagrant)来安装 Vagrant 和 VirtualBox。

### 安装一些自己喜欢的应用程序

**Installed by apt-get**

- [Terminator](https://mudongliang.github.io/2018/12/16/popular-software.html#terminator)(多窗口终端)
- [Wireshark](https://mudongliang.github.io/2018/12/16/popular-software.html#wireshark)(嗅探器)
- [Hexchat](https://mudongliang.github.io/2018/12/16/popular-software.html#hexchat)(irc聊天工具)
- [VLC](https://mudongliang.github.io/2018/12/16/popular-software.html#vlc)(视频播放器)
- [UGet](https://mudongliang.github.io/2018/12/16/popular-software.html#uget)(下载器)

**Installed by downloaded deb package**
	
- [Skype](https://mudongliang.github.io/2018/12/16/popular-software.html#skype)(即时通讯工具)
- [VSCode](https://mudongliang.github.io/2018/12/16/popular-software.html#visual-studio-code)(编辑器)

## 磁盘管理

### 整理一下自己文件和分区
添加一个新的硬盘,然后调整fstab文件进行自动挂载。

## Gnome Shell Extensions

我喜欢的 Gnome 桌面扩展列在[My Favourite Gnome Extensions](http://mudongliang.github.io/2017/03/12/my-favourite-gnome-extensions.html)

搞完收工，切记莫折腾，可以便好！
