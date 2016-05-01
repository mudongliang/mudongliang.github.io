---
layout: post
title: "Debian8 Configuration"
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

- fcitx googlepinyin sunpionyin cloudpinyin (sogoupinyin)

直接从搜狗的官网上面下载deb包安装，然后使用`im-config`来选择`fcitx`。
在`fcitx`的`config`中选择对应的中文输入法，`pinyin, sunpinyin,googlepinyin,sogoupinyin`。

最后，可以使用`im-config`来选择你使用的中文输入法！
	   
### 安装 flashplugin
可以直接使用新立得直接搜索并下载安装, 或 `apt-get install flashplugin-nonfree`

### 安装chrome浏览器
从 dl.google.com 下载，之后同步google账户上的书签及密码, application.

### 安装vmware
要安装linux-headers-$(uname -r)，这里面的意思就是安装和内核对应版本的headers。
	    sudo ./VMware-Workstation-Full-XXX.x86_64.bundle （lisence key直接在网上百度即可！）安装完成之后，sudo apt-get install linux-headers-$(uname -r) 可以安装对应版本的headers。

### 整理一下自己文件和分区
add another hard disk, 然后调整fstab文件。

### 安装Thunderbird
具体安装方法可以从这里http://wangye.org/blog/archives/609/拿到！也可以使用Icedove Debian版本，使用百度网盘上的feeds url来订阅消息。
		MyIcedoveFeeds-New Account.opml ：我导出来的rss订阅的配置文件。

### 按照之前截图的软件列表，将所有的软件安装齐全了。
		（如果没有以往的软件集合的话，可以跳过！）

### 安装faenza-icon-theme，然后在tweak tool中选择这个图标，这个图标还是很漂亮的！
		将顶部panel变为透明，修改/usr/share/gnome-shell/theme/gnome-shell.css文件，

		以下是许多好用的gnomeshell扩展：
		gnome-shell-extension-alternate-tab.noarch
		gnome-shell-extension-apps-menu.noarch
		gnome-shell-extension-auto-move-windows.noarch
		gnome-shell-extension-common.noarch
		gnome-shell-extension-cpu-temperature.noarch
		gnome-shell-extension-dock.noarch
		gnome-shell-extension-drive-menu.noarch
		gnome-shell-extension-gpaste.noarch
		gnome-shell-extension-icon-manager.noarch
		gnome-shell-extension-mediaplayers.noarch
		gnome-shell-extension-noim.noarch
		gnome-shell-extension-noripple.noarch
		gnome-shell-extension-pidgin.i686
		gnome-shell-extension-places-menu.noarch
		gnome-shell-extension-pomodoro.noarch
		gnome-shell-extension-presentation-mode.noarch
		gnome-shell-extension-remove-volume-icon.noarch
		gnome-shell-extension-righthotcorner.noarch
		gnome-shell-extension-systemMonitor.noarch
		gnome-shell-extension-theme-selector.noarch
		gnome-shell-extension-user-theme.noarch
		gnome-shell-extension-windowsNavigator.noarch
		gnome-shell-extension-workspace-indicator.noarch
		gnome-shell-extension-workspacesmenu.noarch
		gnome-shell-extension-xrandr-indicator.noarch
		你可以tweak-tool中打开一些自己喜欢的扩展，就比如说天气，这个非常不错的。NetSpeed       OpenWeather        UpTime Indicator        Text Translator
		EasyScreenCast     Caffeine

### 安装一下自己比较喜欢的程序。
	terminator（多窗口终端）
	wireshark（嗅探器）
	retext(markdown编辑工具)
	hexchat(irc聊天工具)
	texmaker（latex gui）
	hydra（破解密码）
	VLC(视频播放器)
	UGet(下载器)
	（以上软件均可以直接用apt-get安装）
	bcloud(百度云linux客户端) KWplayer(linux酷我客户端)
	（从github LiuLang的开源库中下deb包,这些软件记住要自己定期更新）
	sublime text
	wiznote
	(可以从ppa进行安装，关于debian ppa安装参见其他文章)
	kuaipan
	skype(only 32bit)
	（可以直接从安装包安装）

搞完收工，切记莫折腾，可以便好！
