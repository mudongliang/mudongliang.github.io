---
layout: post
title: "Linux 常用软件列表"
date: 2018-12-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

注：本人喜欢使用DEB系的Linux发行版，所以以下软件的安装方法仅提供deb包的安装方法。 

## 网络应用

### 网络浏览器

#### Chrome

- 介绍

Chrome 浏览器是一款专为现代互联网开发的网络浏览器，高速、简约而且安全。

- 下载位置

[Download](https://www.google.com/chrome/)

- 安装方法

```
# 1. Install through deb package
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb

# 2. Install through software repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install google-chrome-stable

# Or 
sudo apt-get install google-chrome-beta
sudo apt-get install google-chrome-unstable
```

- 卸载方法

```
sudo apt-get purge google-chrome-stable

sudo apt-get purge google-chrome-beta

sudo apt-get purge google-chrome-unstable
sudo rm -rf /etc/apt/sources.list.d/google.list'
```


#### Firefox

- 介绍

自由、拓展性强大的浏览器

- 下载位置

[Download](http://www.firefox.com.cn/download/)

[PPA ubuntu-mozilla-daily](https://code.launchpad.net/~ubuntu-mozilla-daily/+archive/ubuntu/ppa)

- 安装方法

```
# 1. Firefox
sudo apt-get install firefox firefox-locale-zh-hans

# 2. Firefox PPA
sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
sudo apt-get update
sudo apt-get install firefox-trunk
```

- 卸载方法

```
# 1. Firefox
sudo apt-get purge firefox firefox-locale-zh-hans

# 2. Firefox PPA
sudo apt-get purge firefox-trunk
sudo add-apt-repository -r ppa:ubuntu-mozilla-daily/ppa
sudo apt-get update
```


#### Chromium

- 介绍

Google Chrome浏览器的开源版本

- 下载位置

[Download](http://www.chromium.org/getting-involved/download-chromium)

[PPA chromium-daily](https://launchpad.net/~chromium-daily/+archive/ubuntu/stable)

- 安装方法

```
# 1. Chromium
sudo apt-get install chromium

# 2. Chromium PPA for Ubuntu/LinuxMint
sudo add-apt-repository  ppa:chromium-daily/stable
sudo apt-get update
sudo apt-get install chromium-browser
```

- 卸载方法

```
# 1. Chromium
sudo apt-get purge chromium

# 2. Chromium PPA
sudo apt-get purge chromium-browser
sudo add-apt-repository -r ppa:chromium-daily/stable
sudo apt-get update
```


#### Opera

- 介绍

来自挪威的浏览器

- 下载位置

[Download](http://www.opera.com/computer/linux)

- 安装方法

```
# 1. Add source in /etc/apt/sources.list
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install opera-stable

# 2. Add source in /etc/apt/sources.list.d/opera.list
sudo sh -c 'echo "deb https://deb.opera.com/opera-stable/ stable non-free" >> /etc/apt/sources.list.d/opera.list'
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install opera-stable
```

- 卸载方法

```
# 1. Add source in /etc/apt/sources.list
sudo apt-get purge opera-stable
sudo add-apt-repository -r 'deb https://deb.opera.com/opera-stable/ stable non-free'
sudo apt-get update

# 2. Add source in /etc/apt/sources.list.d/opera.list
sudo apt-get purge opera-stable
sudo rm -rf /etc/apt/sources.list.d/opera.list
sudo apt-get update
```


#### Vivaldi

#### Maxthon

- 介绍

功能丰富、界面简洁的浏览器

- 下载位置

[Download](http://www.maxthon.cn/)

- 安装方法

```
sudo gdebi maxthon-browser-stable_XXX_amd64.deb
```

- 卸载方法

```
sudo dpkg -r maxthon-browser-stable
```


### 邮件客户端

#### Thunderbird

- 介绍

专注于电子邮件管理的强大邮件客户端

- 下载位置

[Download](https://www.mozilla.org/zh-CN/thunderbird/)

- 安装方法

```
# 1. Thunderbird
sudo apt-get install thunderbird

# 2. Thunderbird PPA
sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
sudo apt-get update
sudo apt-get install thunderbird-trunk
```

- 卸载方法

```
# 1. Thunderbird
sudo apt-get purge thunderbird

# 2. Thunderbird PPA
sudo add-apt-repository -r ppa:ubuntu-mozilla-daily/ppa
sudo apt-get update
```


#### Evolution

- 介绍

提供邮件收发、日历和通讯录的个人信息解决方案

- 下载位置

[Download](https://wiki.gnome.org/Apps/Evolution)

- 安装方法

```
sudo apt-get install evolution
```

- 卸载方法

```
sudo apt-get purge evolution
```

#### Geary

#### Mutt

- 介绍

类Unix系统下基于文本的邮件客户端

- 下载位置

[Download](http://www.mutt.org/)

- 安装方法

```
sudo apt-get install mutt
```

- 卸载方法

```
sudo apt-get install mutt
```

### 即时聊天

#### QQ

- 介绍

支持在线聊天、视频电话、点对点断点续传文件的强大聊天软件

- 安装方法

[Wine QQ](http://phpcj.org/wineqq/)


#### WeChat

- 介绍

微信，是一个生活方式

- 安装方法

1. 用 Chrome 浏览器 打开 [Webchat](https://chrome.google.com/webstore/detail/wechat/ckhliaadcjmdjbhdlkpjkffidcifglba?utm_source=chrome-app-launcher-info-dialog) 应用；
2. 添加到 Chrome 之后，你就可以找到这个 Webchat 应用了或者在 Chrome 浏览器中输入 "chrome://apps/"，找到对应的应用；


#### Skype

- 介绍

最清晰的免费网络电话，提供文字、声音和视频聊天

- 下载位置

[Download](https://www.skype.com/en/download-skype/skype-for-linux/)

- 安装方法

```
wget https://go.skype.com/skypeforlinux-64.deb
sudo gdebi skypeforlinux-64.deb
```

- 卸载方法

```
sudo dpkg -r skypeforlinux
```

- 备注

目前只支持 64 位版本的 `deb` 和 `rpm` 安装包。

#### Skype WebPage

- 介绍

最清晰的免费网络电话，提供文字、声音和视频聊天

- 安装方法

使用 Skype 的[网页版本](https://web.skype.com)

#### BearyChat

- 介绍

BearyChat, better communication service that brings your team on the same page

- 下载位置

[Download](https://bearychat.com/downloads)

- 安装方法

```
tar -xvf BearyChat-linux-x64.tar.gz
cd BearyChat-linux-x64/
./BearyChat
```

- 卸载方法

```
rm -rf BearyChat-linux-x64/ BearyChat-linux-x64.tar.gz
```

#### Telegram Desktop

- 介绍

Fast and secure desktop app, perfectly synced with your mobile phone.

- 下载位置

[Download](https://desktop.telegram.org/)

- 安装方法

```
sudo apt-get install telegram-desktop
```

- 卸载方法

```
sudo apt-get purge telegram-desktop
```

#### Empathy

- 介绍

支持多协议的强大聊天软件

- 下载位置

[Download](https://wiki.gnome.org/action/show/Apps/Empathy?action=show&redirect=Empathy)

[Github Empathy](https://github.com/GNOME/empathy)

- 安装方法

```
sudo apt-get install empathy
```

- 卸载方法

```
sudo apt-get purge empathy
```

#### Pidgin

- 介绍

跨平台、支持多种协议的聊天软件

- 下载位置

[Download](https://pidgin.im/download/linux/)

- 安装方法

```
sudo apt-get install pidgin
```

- 卸载方法

```
sudo apt-get purge pidgin
```

#### HexChat

- 介绍

跨平台的 IRC 聊天软件

- 下载位置

[Download](https://hexchat.github.io/downloads.html)

- 安装方法

```
sudo apt-get install hexchat
```

- 卸载方法

```
sudo apt-get purge hexchat
```

#### Corebird

- 介绍

Native Gtk+ Twitter client for the Linux desktop

- 下载位置

[Download](https://github.com/baedert/corebird/releases)

- 安装方法

```
sudo apt-get install corebird
```

- 卸载方法

```
sudo apt-get purge corebird
```

### 文件传输

#### FlareGet

- 介绍

支持多协议，多线程的下载软件

- 下载位置

[Download](https://flareget.com/download)

- 安装方法

```
sudo gdebi flareget_4.3-95_amd64.deb
```

- 卸载方法

```
sudo dpkg -r flareget
```

#### UGet

- 介绍

轻量级的全能下载管理器

- 下载位置

[Download](http://ugetdm.com/downloads)

- 安装方法

```
sudo apt-get install uget
```

- 卸载方法

```
sudo apt-get purge uget
```

#### Wget

- 介绍

运行在命令行下的多协议下载软件

- 下载位置

[Download](http://www.gnu.org/software/wget/)

- 安装方法

```
sudo apt-get install wget
```

- 卸载方法

```
sudo apt-get purge wget
```

#### Transmission

- 介绍

一种BitTorrent客户端，特点是一个跨平台的后端和其上的简洁的用户界面

- 下载位置

[Download](http://www.transmissionbt.com/download/)

- 安装方法

```
sudo apt-get install transmission
```

- 卸载方法

```
sudo apt-get purge transmission
```

#### qBittorrent

- 介绍

A BitTorrent client in Qt

- 下载位置

[Download](https://github.com/qbittorrent/qBittorrent)

- 安装方法

```
sudo apt-get install qbittorrent
```

- 卸载方法

```
sudo apt-get purge qbittorrent
```
#### Aria2

- 介绍

运行在命令行下的轻量级下载软件

- 下载位置

[Download](http://sourceforge.net/projects/aria2/files/stable/aria2-1.15.2/)

- 安装方法

```
sudo apt-get install aria2
```

- 卸载方法

```
sudo apt-get purge aria2
```

#### Filezilla

- 介绍

免费、开源的最强FTP客户端软件

- 下载位置

[Download](https://filezilla-project.org/)

- 安装方法

```
sudo apt-get install filezilla
```

- 卸载方法

```
sudo apt-get purge filezilla
```

### 云存储

#### 坚果云

- 介绍

任何设备，随时随地实现文件共享

- 下载位置

[DEB包](https://www.jianguoyun.com/static/exe/installer/debian/nautilus_nutstore_amd64.deb)

- 安装方法

```
sudo gdebi nautilus_nutstore_amd64.deb
```

- 卸载方法

```
sudo dpkg -r nautilus_nutstore
```

#### Dropbox

- 介绍

我用的最好的的文件托管服务

- 下载位置

[Dropbox安装](https://www.dropbox.com/install-linux)

- 安装方法

```
sudo apt install nautilus-dropbox
```

- 卸载方法

```
sudo apt purge nautilus-dropbox
```

#### OwnCloud

- 介绍

The last cloud collaboration/file sharing/file syncing/data privacy platform you'll ever need.

- 下载位置

[下载](https://owncloud.org/download/#owncloud-desktop-client-linux)

- 安装方法

```
# Debian 10
su root
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Debian_10/ /' > /etc/apt/sources.list.d/isv:ownCloud:desktop.list
wget -nv https://download.opensuse.org/repositories/isv:ownCloud:desktop/Debian_10/Release.key -O Release.key
apt-key add - < Release.key
apt-get update
apt-get install owncloud-client

# Debian 9
su root
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Debian_9.0/ /' > /etc/apt/sources.list.d/isv:ownCloud:desktop.list
wget -nv https://download.opensuse.org/repositories/isv:ownCloud:desktop/Debian_9.0/Release.key -O Release.key
apt-key add - < Release.key
apt-get update
apt-get install owncloud-client
```

- 卸载方法

```
sudo apt-get remove owncloud-client
```

#### Google Drive

- 介绍

Google巨人开发的文件存储和同步服务

- 安装方法

使用Google Drive的[网页版本](https://drive.google.com)

#### 百度网盘

- 介绍

记录每一份热爱，让美好永远陪伴。为你电脑/手机中的文件提供云备份、预览、分享等服务，帮你更便捷安全地管理数据。

- 下载位置

[安装包下载](https://pan.baidu.com/download#pan)

- 安装方法

```
sudo gdebi baidunetdisk_*.deb
```

- 卸载方法

```
sudo dpkg -r baidunetdisk
```


### 网络支付

#### 支付宝

- 介绍

全球领先的独立第三方支付平台

- 下载位置
	- 首先进入[支付宝](https://www.alipay.com/)首页；
	- 点击登录按钮之后，下载支付宝控件；

- 安装方法

```
$ tar -xvf aliedit.tar.gz
aliedit.sh

$ ./aliedit.sh
Restart   firefox   to complete your changes
Successfully installed Alipay Security Control
Press any key to quit...
```

- 卸载方法

无

## 图像影音

### 音乐播放

#### Spotify

- 介绍

Spotify: Music for everyone

- 下载位置

[下载](https://www.spotify.com/us/download/linux/)

- 安装方法

```
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client
```

- 卸载方法

```
sudo apt-get purge spotify-client
```

#### FeelUOwn

- 介绍

网易云音乐的linux客户端

- 下载位置

[FeelUOwn源码](https://github.com/cosven/FeelUOwn)

- 安装方法

[安装方法](https://github.com/cosven/FeelUOwn#安装方法)

#### 网易云音乐官方客户端

#### Banshee

- 介绍

高度自定义的音乐播放器

- 下载位置

[安装包下载](http://banshee.fm/download/)

- 安装方法

```
sudo apt-get install banshee
```

- 卸载方法

```
sudo apt-get purge banshee
```

#### Rhythmbox

- 介绍

Gnome桌面中默认带的音乐播放器，提供音乐管理与播放的强大播放器

- 下载位置

[下载位置](https://wiki.gnome.org/Apps/Rhythmbox)

- 安装方法

```
sudo apt-get install rhythmbox
```

- 卸载方法

```
sudo apt-get purge rhythmbox
```

### 视频播放

#### SMPlayer

- 介绍

一个基于mplayer2的视频播放器，可能是Linux下最方便的视频播放器

- 下载位置

[Download](http://smplayer.sourceforge.net/)

- 安装方法

```
sudo apt-get install smplayer
```

- 卸载方法

```
sudo apt-get purge smplayer
```

#### VLC

- 介绍

全平台的自由多媒体解决方案

- 下载位置

[下载位置](http://www.videolan.org/)

- 安装方法

```
sudo apt-get install vlc
```

- 卸载方法

```
sudo apt-get purge vlc
```

#### mpv

- 介绍

专注与视频播放质量和体验。GUI？我们不需要，配置文件更高效。

- 下载位置

[Official website](https://mpv.io/)

[GitHub](https://github.com/mpv-player/mpv)

- 安装方法

```
sudo apt-get install mpv
```

- 卸载方法

```
sudo apt-get purge mpv
```

#### KODI(原XBMC)

- 介绍

全平台的媒体库解决方案，插件丰富是它的最大特点

- 下载位置

[Download](http://kodi.tv/download/)  

- 安装方法

```
sudo add-apt-repository ppa:team-xbmc/ppa
sudo apt-get update
sudo apt-get install kodi
```

- 卸载方法

```
sudo apt-get purge kodi
```

注: 中文插件 [xbmc-addons-chinese](https://github.com/taxigps/xbmc-addons-chinese)


### 屏幕录制

#### SimpleScreenRecorder

- 介绍

基于QT的Linux原生屏幕录制软件

- 下载位置

[Download](https://www.maartenbaert.be/simplescreenrecorder/#download)  

- 安装方法

```
sudo apt-get install simplescreenrecorder
```

- 卸载方法

```
sudo apt-get purge simplescreenrecorder
```


### 音频编辑

#### Audacity

- 介绍

简单易用的跨平台多轨音频编辑器

- 下载位置

[官方网站](https://www.audacityteam.org/)

- 安装方法

```
sudo apt-get install audacity
```

- 卸载方法

```
sudo apt-get purge audacity
```


### 图像浏览

#### Eye of GNOME(EOG)

- 介绍

Gnome桌面中默认的图片查看器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/EyeOfGnome)

- 安装方法

```
sudo apt-get install eog
```

- 卸载方法

```
sudo apt-get purge eog
```

#### gThumb

- 介绍

Gnome桌面中的图片查看器及浏览器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/gthumb)

- 安装方法

```
sudo apt-get install gthumb
```

- 卸载方法

```
sudo apt-get purge gthumb
```


### 图像编辑

#### GIMP

- 介绍

支持多种操作系统（Linux，Windows，MacOS等）的跨平台的图片编辑软件

- 下载位置

[官方网站](https://www.gimp.org/)

- 安装方法

```
sudo apt-get install gimp
```

- 卸载方法

```
sudo apt-get purge gimp
```

#### Inkscape

- 介绍

支持多种操作系统（Linux，Windows，MacOS）的矢量图片编辑软件

- 下载位置

[官方网站](https://inkscape.org/)

- 安装方法

```
sudo apt-get install inkscape
```

- 卸载方法

```
sudo apt-get purge inkscape
```


### 截图工具

#### shutter

- 介绍

Shutter is a feature-rich screenshot program for Linux based operating systems.

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/gthumb)

- 安装方法

```
sudo apt-get install shutter
```

- 卸载方法

```
sudo apt-get purge shutter
```

#### Gnome Screenshot

- 介绍

GNOME Screenshot is a small utility that takes a screenshot of the whole desktop; the currently focused window; or an area of the screen.

- 下载位置

[官方网站](https://github.com/GNOME/gnome-screenshot)

- 安装方法

```
sudo apt-get install gnome-screenshot
```

- 卸载方法

```
sudo apt-get purge gnome-screenshot
```


### 画图工具

#### Dia

- 介绍

GNOME桌面环境中的画图软件

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Dia)

- 安装方法

```
sudo apt-get install dia
```

- 卸载方法

```
sudo apt-get purge dia
```



## 游戏娱乐

### 游戏平台

#### Steam

- 介绍

目前全球最大的综合性数字发行平台

- 下载位置

[官方网站](http://store.steampowered.com/)

- 安装方法

```
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install steam
```

- 卸载方法

```
sudo apt-get purge steam
```

### Gnome自带小游戏

#### gnome-2048

- 介绍

2048小游戏

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/2048)

- 安装方法

```
sudo apt-get install gnome-2048
```

- 卸载方法

```
sudo apt-get purge gnome-2048
```

#### Gnomine

- 介绍

扫雷

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Mines)

- 安装方法

```
sudo apt-get install gnomine
```

- 卸载方法

```
sudo apt-get purge gnomine
```

#### Sudoku

- 介绍

数独

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Sudoku)

- 安装方法

```
sudo apt-get install gnome-sudoku
```

- 卸载方法

```
sudo apt-get purge gnome-sudoku
```

#### Quadrapassel

- 介绍

俄罗斯方块，原名为Gnometris

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Quadrapassel)

- 安装方法

```
sudo apt-get install quadrapassel
```

- 卸载方法

```
sudo apt-get purge quadrapassel
```



## 文件管理

### 文件管理

#### Nautilus

- 介绍

GNOME桌面的简单文件管理器

- 下载位置

[Files](https://wiki.gnome.org/Apps/Nautilus)

- 安装方法

```
sudo apt-get install nautilus
```

- 卸载方法

```
sudo apt-get purge nautilus
```


### 压缩打包

#### FileRoller

- 介绍

GNOME桌面使用的解压工具

- 下载位置

[FileRoller](https://wiki.gnome.org/Apps/FileRoller)

- 安装方法

```
sudo apt-get install file-roller
```

- 卸载方法

```
sudo apt-get purge file-roller
```

#### UnZip

- 介绍

UnZip is an extraction utility for archives compressed in .zip format

- 下载位置

[Unzip](https://packages.debian.org/buster/unzip)

- 安装方法

```
sudo apt-get install unzip
```

- 卸载方法

```
sudo apt-get purge unzip
```

#### Unrar

- 介绍

WinRAR的Linux版本

- 下载位置

[官方网站](https://www.rarlab.com/)

- 安装方法

```
sudo apt-get install unrar
```

- 卸载方法

```
sudo apt-get purge unrar
```

## 办公应用

### 输入法

#### ibus + pinyin/sunpinyin

- 介绍

为Linux/Unix系统开发的全新输入法框架

- 下载位置

[官方网站](https://github.com/ibus/ibus/wiki)

- 安装方法

```
sudo apt-get install ibus ibus-pinyin ibus-sunpinyin
```

- 卸载方法

```
sudo apt-get purge ibus ibus-pinyin ibus-sunpinyin
```


#### fcitx + sunpinyin/googlepinyin

- 介绍

为Linux 提供的轻量的输入法框架

- 下载位置

[官方网站](https://fcitx-im.org/wiki/Fcitx)

- 安装方法

```
sudo apt-get install fcitx fcitx-googlepinyin fcitx-sunpionyin
```

- 卸载方法

```
sudo apt-get purge fcitx fcitx-googlepinyin fcitx-sunpionyin
```


#### fcitx + sogoupinyin

- 介绍

- 下载位置

[官方网站](https://pinyin.sogou.com/)

[下载位置](https://pinyin.sogou.com/linux/?r=pinyin)

- 安装方法

```
sudo gdebi sogoupinyin_*_amd64.deb
```

- 卸载方法

```
sudo dpkg -r sogoupinyin
```

### 文档阅读

#### Evince

- 介绍

GNOME中默认的pdf阅读器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Evince)

- 安装方法

```
sudo apt-get install evince
```

- 卸载方法

```
sudo apt-get purge evince
```

#### Okular

- 介绍

More than a reader

- 下载位置

[官方网站](https://okular.kde.org/)

- 安装方法

```
sudo apt-get install okular
```

- 卸载方法

```
sudo apt-get purge okular
```

#### Foxit Reader

- 介绍

The PDF Reader for the Connected World

- 下载位置

[下载位置](https://www.foxitsoftware.com/pdf-reader/)

- 安装方法

```
tar zxvf FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
cd FoxitReader.enu.setup.2.4.4.0911.x64.run/
./FoxitReader.enu.setup.2.4.4.0911\(r057d814\).x64.run
```

- 卸载方法

```
rm -rf ~/opt/foxitsoftware/foxitreader
```

### 办公套件

#### Libre Office

Ship by default

#### WPS Office

- 介绍

Bringing **The World’s Best Office Experience** To Linux

- 下载位置

[下载位置](https://linux.wps.cn/)，点击对应的架构与包格式（如X64）下载对应的安装包

- 安装方法

```
sudo gdebi wps-office_*_amd64.deb
```

- 卸载方法

```
sudo dpkg -r wps-office
```

### 笔记记事

#### Google Keep

- 介绍

Google 巨人开发的笔记服务

- 下载位置

[网页](https://keep.google.com/)

#### WizNote

为知笔记 [linux版源代码](https://github.com/WizTeam/WizQTClient)

#### NixNote

[Evernote 开源版本](https://sourceforge.net/projects/nevernote/)

## 教育科学

### 教育软件

#### Texmaker

- 介绍

Free cross-platform LaTeX editor(Windows, MacOsX, Linux)

- 下载位置

[下载位置](https://www.xm1math.net/texmaker/download.html)

- 安装方法
 
```
sudo apt-get install texmaker
```

- 卸载方法

```
sudo apt-get purge texmaker
```

#### Latexila

- 介绍

GNOME LaTeX is a LaTeX editor for the GNOME desktop. It is a free/libre software (GPLv3+ license).

- 下载位置

[下载位置](https://wiki.gnome.org/Apps/GNOME-LaTeX)

- 安装方法

```
sudo apt-get install latexila
```

- 卸载方法

```
sudo apt-get purge latexila
```

#### Lyx

- 介绍

LyX combines the power and flexibility of TeX/LaTeX with the ease of use of a graphical interface.

- 下载位置

[下载位置](https://www.lyx.org/Download#toc5)

- 安装方法

```
sudo apt-get install lyx
```

- 卸载方法

```
sudo apt-get install lyx
```

#### TeXstudio

- 介绍

TeXstudio is an integrated writing environment for creating LaTeX documents

- 下载位置

[下载位置](https://www.texstudio.org/)

- 安装方法

```
sudo apt-get install texstudio
```

- 卸载方法

```
sudo apt-get purge texstudio
```

#### Texlive

- 介绍

TeX Live: metapackage pulling in all components of TeX Live

- 下载位置

[下载位置](https://packages.debian.org/buster/texlive-full)

- 安装方法

```
sudo apt-get install texlive-full
```

- 卸载方法

```
sudo apt-get purge texlive-full
```

## 科学软件

#### Mendeley

- 介绍

Mendeley brings your research to life, so you can make an impact on tomorrow

- 下载位置

[下载位置](https://www.mendeley.com/download-desktop/)

- 安装方法

```
wget https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest -O mendeleydesktop.deb
sudo dpkg -i mendeleydesktop.deb
```

- 卸载方法

```
sudo dpkg -r mendeleydesktop
```



## 虚拟化

### 虚拟机

#### VMware Workstation

- 介绍

VMware Workstation Pro is the industry standard for running multiple operating systems as virtual machines (VMs) on a single Linux or Windows PC. IT professionals, developers and businesses who build, test or demo software for any device, platform or cloud rely on Workstation Pro.

- 下载位置

[官方网站](https://www.vmware.com/products/workstation-pro.html)

[下载位置](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)

- 安装方法

```
chmod +x VMware-Workstation-Full-*.x86_64.bundle
sudo ./VMware-Workstation-Full-*.x86_64.bundle
```

- 卸载方法

```
sudo vmware-installer -u vmware-workstation
```

#### VirtualBox

- 介绍

Sun公司开发的完全开源的x86模拟器

- 下载位置

[官方网站](https://www.virtualbox.org/) [下载位置](https://www.virtualbox.org/wiki/Linux_Downloads)

- 安装方法

```
# 1. Install from deb package
# Ubuntu 18.04 / 18.10 / 19.04 / Debian 10
wget https://download.virtualbox.org/virtualbox/6.0.8/virtualbox-6.0_6.0.8-130520~Ubuntu~bionic_amd64.deb -O virtualbox.deb
# Debian 9
https://download.virtualbox.org/virtualbox/6.0.8/virtualbox-6.0_6.0.8-130520~Debian~stretch_amd64.deb -O virtualbox.deb
sudo gdebi virtualbox.deb

# 2. Install through software repo
sudo sh -c 'echo "deb https://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list'
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-6.0
```

- 卸载方法

```
sudo apt-get purge virtualbox-6.0
```

#### Vagrant

- 介绍

Vagrant 提供了一个易于配置，可重复使用，兼容的环境，通过一个单一的工作流程来控制，帮助你和团队最大化生产力和灵活性。

- 下载位置

[官方网站](https://www.vagrantup.com/)

[下载位置](https://www.vagrantup.com/downloads.html)

- 安装方法

```
# 1. install from downloaded package
wget https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
sudo gdebi vagrant_2.2.2_x86_64.deb

# 2. install from apt-get
sudo apt install vagrant
```

- 卸载方法

```
# 1. uninstall from downloaded package
sudo dpkg -r vagrant

# 2. uninstall from apt-get
sudo apt-get purge vagrant
```

#### Docker

- 介绍

Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

- 下载位置

[官方网站](https://www.docker.com/)

[下载位置](https://docs.docker.com/install/linux/docker-ce/debian/)

- 安装方法

```
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce
```

- 卸载方法

```
sudo apt-get purge docker-ce
```

#### Boxes

- 介绍

A simple GNOME application to view, access, and manage remote and virtual systems.

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Boxes)

- 安装方法

```
sudo apt-get install gnome-boxes
```

- 卸载方法

```
sudo apt-get purge gnome-boxes
```

#### QEMU & QEMU-KVM

- 介绍

The **FAST!** processor emulator


- 下载位置

[下载位置](https://www.qemu.org/download/)

- 安装方法

```
sudo apt-get install qemu qemu-kvm
```
- 卸载方法

```
sudo apt-get purge qemu qemu-kvm
```

## 监视和控制

### 硬件查询

#### CPU-G

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo add-apt-repository ppa:atareao/atareao
sudo apt-get update
sudo apt-get install cpu-g
```

- 卸载方法

```
sudo apt-get purge cpu-g
```

#### Hardinfo

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install hardinfo
```

- 卸载方法

```
sudo apt-get purge hardinfo
```

#### I-Nex

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install cpu-g
```

- 卸载方法

```
sudo apt-get install cpu-g
```

#### Psensor

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install psensor
```

- 卸载方法

```
sudo apt-get purge psensor
```

### 系统监视

#### System Monitor

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install gnome-system-monitor
```
- 卸载方法

```
sudo apt-get purge gnome-system-monitor
```

#### Htop

- 介绍

Htop is an ncursed-based process viewer similar to top, but it allows one to scroll the list vertically and horizontally to see  all processes and their full command lines.

- 下载位置

[官方网站](https://hisham.hm/htop/)

- 安装方法

```
sudo apt-get install htop
```

- 卸载方法

```
sudo apt-get purge htop
```

### 远程控制

#### TeamViewer

- 介绍

- 下载位置

[官方网站](https://www.teamviewer.cn/cn/)

[下载位置](https://download.teamviewer.com/download/linux/teamviewer_amd64.deb)

- 安装方法

```
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -O teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb
```

- 卸载方法

```
sudo dpkg -r teamviewer
```

#### Remmina

- 介绍

通过 Linux 来随时随地访问任何操作系统

- 下载位置

[官方网站](https://remmina.org/)

[下载位置](https://remmina.org/how-to-install-remmina/)

- 安装方法

```
sudo apt-get install remmina
```

- 卸载方法

```
sudo apt-get purge remmina
```

#### AnyDesk

- 介绍

随时随地 AnyDesk

- 下载位置

[官方网站](https://anydesk.com/en)

[下载位置](https://anydesk.com/en/downloads/linux)

- 安装方法

```
wget https://download.anydesk.com/linux/anydesk_5.1.2-1_amd64.deb -O anydesk_amd64.deb
sudo gdebi anydesk_amd64.deb
```

- 卸载方法

```
sudo dpkg -r anydesk
```

#### Putty

- 介绍

- 下载位置

[官方网站](https://www.putty.org/)

[下载位置](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

- 安装方法

```
sudo apt-get install putty
```

- 卸载方法

```
sudo apt-get purge putty
```

## 系统安全

### 密码管理

#### KeePass2

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install keepass2
```

- 卸载方法

```
sudo apt-get purge keepass2
```

#### KeePassX

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install keepassx
```

- 卸载方法

```
sudo apt-get purge keepassx
```

### 杀毒软件

#### ClamAV/ClamTk

- 介绍

ClamAV 是一个开源的跨平台命令行防病毒工具，用于检测木马、病毒和其他恶意代码。而 ClamTk 则是它的前端 GUI。

- 下载位置

[官方网站](https://www.clamav.net/)

- 安装方法

```
sudo apt-get install clamav clamtk
```

- 卸载方法

```
sudo apt-get purge clamav clamtk
```

## 系统工具

### 终端模拟器

#### Gnome Terminal
 
- 介绍

Gnome Terminal 是 Gnome 桌面环境中的终端模拟软件

- 下载位置

[Official Website](https://help.gnome.org/users/gnome-terminal/stable/index.html.en)

[GitHub](https://github.com/GNOME/gnome-terminal)

- 安装方法

```
sudo apt-get install gnome-terminal
```

- 卸载方法

```
sudo apt-get purge gnome-terminal
```

#### Terminator

- 介绍

Terminator 是一个程序，它可让用户自由地排布多个 GNOME 终端，而不用通过窗口管理器来实现，比较适合需要同时打开多个终端的用户

- 下载位置

[Official Website](http://gnometerminator.blogspot.com/p/introduction.html)

- 安装方法

```
sudo apt-get install terminator
```

- 卸载方法

```
sudo apt-get purge terminator
```

#### tmux

- 介绍

GNU screen 类似的程序，可作为 screen 的替代品使用

- 下载位置

[Official Website](http://sourceforge.net/projects/tmux/)

- 安装方法

```
sudo apt-get install tmux
```

- 卸载方法

```
sudo apt-get purge tmux
```

### Shell

#### Zsh

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

```
sudo apt-get install zsh
```

- 卸载方法

```
sudo apt-get purge zsh
```

### 启动盘制作工具

#### UNetbootin

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

- 卸载方法

### 包管理器

#### Gdebi

- 介绍

用于安装你自己手动下载的包的GUI程序

- 下载位置

[Official Website](https://packages.debian.org/stretch/gdebi)

- 安装方法

```
sudo apt-get install gdebi
```

- 卸载方法

```
sudo apt-get purge gdebi
```

#### Synaptic

- 介绍

apt系的图形化安装软件

- 下载位置

[Official Website](https://www.nongnu.org/synaptic/)

- 安装方法

```
sudo apt-get install synaptic
```

- 卸载方法

```
sudo apt-get purge synaptic
```

## 系统管理

### 配置工具

#### Tweak Tool

- 介绍

Previously known as Tweak Tool. Graphical interface for advanced GNOME 3 settings.

- 下载位置

[官方网站](https://wiki.gnome.org/action/show/Apps/Tweaks?action=show&redirect=Apps%2FGnomeTweakTool)

- 安装方法

```
sudo apt-get install gnome-tweak-tool
```

- 卸载方法

```
sudo apt-get purge gnome-tweak-tool
```

#### Font Manager

- 介绍

Gnome桌面中管理，添加和去除系统字体

- 下载位置

[Debian Package](https://packages.debian.org/buster/font-manager)

- 安装方法

```
sudo apt-get install font-manager
```

- 卸载方法

```
sudo apt-get purge font-manager
```

### SSH Server/Client

#### Openssh Server

- 介绍

Secure Shell 的开源实现，目前已经成为 SSH Server 的首选

- 下载位置

[Official Website](http://www.openssh.com/)

- 安装方法

```
sudo apt-get install openssh-server
```

- 卸载方法

```
sudo apt-get purge openssh-server
```

#### Openssh Client

- 介绍

Secure Shell 的开源实现，目前已经成为 SSH Server 的首选

- 下载位置

[Official Website](http://www.openssh.com/)

- 安装方法

```
sudo apt-get install openssh-client
```

- 卸载方法

```
sudo apt-get purge openssh-client
```

## 程序开发

### 版本控制

#### Git

- 介绍

Linus为管理Linux内核而开发的分布式版本管理工具

- 下载位置

[官方网站](https://git-scm.com/)

[下载位置](https://git-scm.com/download/linux)

- 安装方法

```
sudo apt-get install git
```

- 卸载方法

```
sudo apt-get purge git
```

#### SVN

- 介绍

Apache开发的集中式版本管理工具

- 下载位置

[官方网站](https://subversion.apache.org/)

[下载位置](https://subversion.apache.org/packages.html)

- 安装方法

```
sudo apt-get install subversion
```

- 卸载方法

```
sudo apt-get install subversion
```

### 本文编辑器

#### Sublime Text

- 介绍

A sophisticated text editor for code, markup and prose

- 下载位置

[官方网站](https://www.sublimetext.com/)

[下载位置](https://www.sublimetext.com/3)

- 安装方法

```
sudo apt-get install apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

# Stable
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Dev
echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update
sudo apt-get install sublime-text
```

- 卸载方法

```
sudo apt-get purge sublime-text
```

#### Visual Studio Code

- 介绍

微软开发可以跨Linux，Windows，Mac OS的编辑器

- 下载位置

[官方网站](https://code.visualstudio.com/) [下载位置](https://code.visualstudio.com/Download)

- 安装方法

```
# 1. Install from deb package
# Download deb package from https://code.visualstudio.com/
sudo gdebi code_*_amd64.deb

# 2. Install from software repo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code
```

- 卸载方法

```
# 1.
sudo dpkg -r code
# 2.
sudo apt-get purge code
```

#### gedit

- 介绍

GNOME桌面环境的默认文本编辑器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Gedit)

[下载位置](https://wiki.gnome.org/Apps/Gedit#Download)

- 安装方法

```
sudo apt-get install gedit
```

- 卸载方法

```
sudo apt-get purge gedit
```

#### Atom

- 介绍

**A hackable text editor for the 21st Century**

- 下载位置

[官方网站](https://atom.io/) [Github仓库](https://github.com/atom/atom)

- 安装方法

```
# 1. install from package
# Download deb package from https://atom.io/
sudo gdebi atom-amd64.deb

# 2. install from source list
curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt-get update
sudo apt-get install atom

# Or
sudo apt-get install atom-beta
```

- 卸载方法

```
# 1.
sudo dpkg -r atom
# 2.
sudo apt-get purge atom
```

#### Vim

- 介绍

Unix/Linux平台下的高度可配置的文本编译器，可以说Linux下非常好的文本编译器，也是我默认使用的编译器。

- 下载位置

[下载位置](https://github.com/vim/vim.git)

- 安装方法

```
sudo apt-get install vim
```

- 卸载方法

```
sudo apt-get purge vim
```

#### Emacs

- 介绍

An extensible, customizable, free/libre text editor — and more

- 下载位置

[下载位置](https://www.gnu.org/software/emacs/download.html)

- 安装方法

```
sudo apt-get install emacs
```

- 卸载方法

```
sudo apt-get purge emacs
```

#### Nano

- 介绍

类Unix系统上基于命令行接口的文本编辑器

- 下载位置

[官方网站](https://www.nano-editor.org/)

- 安装方法

```
sudo apt-get install nano
```

- 卸载方法

```
sudo apt-get purge nano
```

### 集成开发环境

#### Eclipse IDE

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

- 卸载方法

#### JetBrains IDE

- 介绍

- 下载位置

[官方网站]()

[下载位置]()

- 安装方法

- 卸载方法

#### Wireshark

- 介绍

世界第一以及使用最广泛的网络协议分析器

- 下载位置

[官方网站](https://www.wireshark.org/)

[下载位置](https://www.wireshark.org/download.html)

- 安装方法

```
sudo apt-get install wireshark
```

- 卸载方法

```
sudo apt-get purge wireshark
```

#### Code Blocks

- 介绍

Codeblocks is a cross-platform IDE built around wxWidgets, designed to be extensible and configurable. 

- 下载位置

[官方网站](http://www.codeblocks.org/)

[下载位置](http://www.codeblocks.org/downloads)

- 安装方法

```
sudo apt-get install codeblocks
```

- 卸载方法

```
sudo apt-get purge codeblocks
```

## 其他

### Caffeine

- 介绍

Caffeine prevents the desktop from becoming idle when an application is running full-screen.

- 下载位置

[Debian Package](https://packages.debian.org/buster/caffeine)

- 安装方法

```
sudo apt-get install caffeine
```

- 卸载方法

```
sudo apt-get purge caffeine
```

