---
layout: post
title: "Debian8 配置"
date: 2015-04-13
description: ""
category: 
tags: [linux kernel,3.17,vmware workstation,patch]
---

### 添加较快源
国内比较快速和稳定的源应该是

- [USTC源](http://mirrors.ustc.edu.cn/),同样是 [ftp.cn.debian.org](http://ftp.cn.debian.org/);
- [163源](http://mirrors.163.com);
- [阿里云的源](http://mirrors.aliyun.com);

以 USTC 源为例：

```
deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free
deb http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-backports/ jessie-backports main contrib non-free 
deb-src http://mirrors.ustc.edu.cn/debian-backports/ jessiee-backports main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ iessie/updates main non-free contrib
deb-src http://mirrors.ustc.edu.cn/debian-security/ jessie/updates main non-free contrib
```

### 添加sudo权限
首先，如果没有安装`sudo`的话，`apt-get install sudo`;
然后，编辑`/etc/sudoers`，`vim /etc/sudoers`;

	root ALL=(ALL) ALL
	<your_user_name> ALL=(ALL) ALL //replace your username

### 安装中文输入法

- ibus ibus-pinyin ibus-sunpinyin

```
apt-get install ibus ibus-pinyin ibus-sunpinyin
```

![ibus1]({{site.url}}/images/ibus1.png)

这里`ibus-googlepinyin`安装不上，完全没有这个软件包。使用`ibus-setup`可以对`ibus`进行图形设置，在输入法的选择适合自己的输入法。

![ibus2]({{site.url}}/images/ibus2.png)

![ibus3]({{site.url}}/images/ibus3.png)

- fcitx googlepinyin sunpionyin cloudpinyin (sogoupinyin)

直接从搜狗的官网上面下载deb包安装，然后使用`im-config`来选择`fcitx`。

![sogou]({{site.url}}/images/sougou.png)

在`fcitx`的`config`中选择对应的中文输入法，`pinyin, sunpinyin,googlepinyin,sogoupinyin`。
最后，可以使用`im-config`来选择你使用的中文输入法。

![im-config]({{site.url}}/images/im-config.png)
	   
### 安装 flashplugin
可以直接使用新立得直接搜索并下载安装, 或 `apt-get install flashplugin-nonfree`

### 安装chrome浏览器
从[下载页](https://dl.google.com)下载 Chrome 对应的安装包，同步google账户上的书签，插件，应用程序等。

### 安装vmware

    sudo apt-get install linux-headers-$(uname -r)

这命令的意思就是安装和内核对应版本的headers

    sudo ./VMware-Workstation-Full-*.x86_64.bundle 

安装包可以在 VMware 官网上下载（lisence key直接在网上百度）

### 整理一下自己文件和分区
添加一个新的硬盘,然后调整fstab文件进行自动挂载。

### 安装Thunderbird
~~具体安装方法可以从这里http://wangye.org/blog/archives/609/拿到,也可以使用Icedove Debian版本。~~
因为Firefox，Thunderbird马上就要进入Debian了，取代原来的Iceweasel，Icedove。
使用百度网盘上的feeds url来订阅消息,[MyIcedoveFeeds-New Account.opml](http://pan.baidu.com/s/1c0TSshU),它是我以前导出来的rss订阅的配置文件。

### 安装其他软件
按照之前截图的软件列表，将所有的软件安装齐全了。（如果没有以往的软件集合的话，可以跳过。）

![Debian8-1.png]({{site.url}}/images/Debian8-1.png)
![Debian8-2.png]({{site.url}}/images/Debian8-2.png)
![Debian8-3.png]({{site.url}}/images/Debian8-3.png)
![Debian8-4.png]({{site.url}}/images/Debian8-4.png)
![Debian8-5.png]({{site.url}}/images/Debian8-5.png)

### 安装faenza-icon-theme
在 tweak tool 中选择这个图标，这个图标还是很漂亮的。同时将顶部 panel 变为透明，修改`/usr/share/gnome-shell/theme/gnome-shell.css`文件，

### Gnome Shell Extensions

我喜欢的 Gnome 桌面扩展列在[My Favourite Gnome Extensions](http://mudongliang.github.io/2017/03/12/my-favourite-gnome-extensions.html)

### 安装一些自己喜欢的程序

**Installed by apt-get**

- terminator（多窗口终端）
- wireshark（嗅探器）
- retext(markdown编辑工具)
- hexchat(irc聊天工具)
- texmaker（latex gui）
- hydra（破解密码）
- VLC(视频播放器)
- UGet(下载器)

**Installed by downloaded deb package**
	
- bcloud(百度云linux客户端) 
- KWplayer(linux酷我客户端)
- Skype(only bit)

**Installed by ppa**

- Sublime text
- wiznote

搞完收工，切记莫折腾，可以便好！
