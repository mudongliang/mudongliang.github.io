---
layout: post
title: "Debian9 配置"
date: 2018-12-16
description: ""
category: 
tags: []
---

* TOC
{:toc}

## 添加较快源
国内比较快速和稳定的源有以下两种：

**Official**

- [ftp.cn.debian.org](http://ftp.cn.debian.org/)
- [USTC源](http://mirrors.ustc.edu.cn/)
- [清华大学开源软件镜像站](mirrors.tuna.tsinghua.edu.cn);
- [华为开源镜像站](http://mirrors.huaweicloud.com);
- [163源](http://mirrors.163.com);

**Unofficial**

- [阿里云的源](http://mirrors.aliyun.com);

以 USTC 源为例(以下内容的生成可参考[List Generator](https://mudongliang.github.io/listgenerator/) 或者[Debian 源使用帮助](http://mirrors.ustc.edu.cn/help/debian.html))：

```
deb http://mirrors.ustc.edu.cn/debian stretch main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian stretch main contrib non-free
deb http://mirrors.ustc.edu.cn/debian stretch-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian stretch-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ stretch/updates main non-free contrib
deb-src http://mirrors.ustc.edu.cn/debian-security/ stretch/updates main non-free contrib
```
将上述内容写入到 `/etc/apt/sources.list`, 然后 `apt-get update`

## 添加sudo权限
首先，Debian 镜像默认没有安装`sudo`(`apt-get install sudo`)
然后，编辑`/etc/sudoers`(`vim /etc/sudoers`)

```
root ALL=(ALL) ALL
<your_user_name> ALL=(ALL) ALL
```

## 安装驱动

### 安装无线网卡驱动

参照本站内的[另一篇博文](ihttps://mudongliang.github.io/2017/02/17/install-driver-for-intel-corporation-wireless-8260-in-debian-jessie-and-stretch.html)来安装无线网卡驱动

## 系统清理

### 删除无用软件

```
sudo apt-get purge gnome-2048 aisleriot atomix gnome-chess five-or-more \
hitori iagno gnome-klotski lightsoff gnome-mahjongg gnome-mines \
gnome-nibbles quadrapassel four-in-a-row gnome-robots gnome-sudoku \
swell-foop tali gnome-taquin gnome-tetravex
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

### 安装中文输入法 IBUS 或 Fcitx

- ibus-pinyin ibus-sunpinyin

参见本站内的[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#ibus--pinyinsunpinyin)

![ibus1]({{site.url}}/images/ibus1.png)

这里`ibus-googlepinyin`安装不上，完全没有这个软件包。使用`ibus-setup`可以对`ibus`进行图形设置，在输入法的选择适合自己的输入法。

![ibus2]({{site.url}}/images/ibus2.png)

![ibus3]({{site.url}}/images/ibus3.png)


- googlepinyin sunpionyin sogoupinyin

参见[教程1](https://mudongliang.github.io/2018/12/16/popular-software.html#fcitx--sunpinyingooglepinyin)和[教程2](https://mudongliang.github.io/2018/12/16/popular-software.html#fcitx--sogoupinyin)

然后在`fcitx`的`config`中选择对应的中文输入法，`pinyin, sunpinyin,googlepinyin,sogoupinyin`。

![sogou]({{site.url}}/images/sougou.png)

最后，可以使用`im-config`来选择你使用的中文输入法。

![im-config]({{site.url}}/images/im-config.png)

**注意：在搜狗输入法的使用过程中，我经常发现搜狗的进程占用100%CPU导致系统非常卡，所以我一般使用Google pinyin**
 
<!--
### ~~安装 flashplugin~~
~~可以直接使用新立得直接搜索并下载安装, 或 `apt-get install flashplugin-nonfree`~~
-->

### 安装Anyconnect

根据本站内的[教程](https://pennstate.service-now.com/sp?id=kb_article_view&sys_kb_id=ee330252db212788a318fb671d961981&sysparm_tsqueryId=5d397a69db1ea34497c9ffe61d961965&sysparm_rank=1#Linux%20Install)安装Anyconnect。教程讲解地十分详细。

### 安装Chrome浏览器

从[下载页](https://dl.google.com)下载 Chrome 对应的安装包，同步google账户上的书签，插件，应用程序等。

或者根据本站内的[教程](https://mudongliang.github.io/2018/12/16/popular-software.html#chrome)来通过软件仓库安装。

### 安装vmware workstation

根据本站内的[教程](ihttps://mudongliang.github.io/2017/02/17/install-and-uninstall-vmware-workstation.html)来安装 VMware Workstation Pro。

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

<!--
### 安装其他软件
按照之前截图的软件列表，将所有的软件安装齐全了。（如果没有以往的软件集合的话，可以跳过。）

![Debian8-1.png]({{site.url}}/images/Debian8-1.png)
![Debian8-2.png]({{site.url}}/images/Debian8-2.png)
![Debian8-3.png]({{site.url}}/images/Debian8-3.png)
![Debian8-4.png]({{site.url}}/images/Debian8-4.png)
![Debian8-5.png]({{site.url}}/images/Debian8-5.png)
-->

## 磁盘管理

### 整理一下自己文件和分区
添加一个新的硬盘,然后调整fstab文件进行自动挂载。

<!--
## 安装faenza-icon-theme
在 tweak tool 中选择这个图标，这个图标还是很漂亮的。
-->

## Gnome Shell Extensions

我喜欢的 Gnome 桌面扩展列在[My Favourite Gnome Extensions](http://mudongliang.github.io/2017/03/12/my-favourite-gnome-extensions.html)

搞完收工，切记莫折腾，可以便好！
