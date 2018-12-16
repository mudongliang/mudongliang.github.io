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

[Download](http://www.google.cn/intl/zh-CN/chrome/browser/)

- 安装方法

```
# 1. install through deb package
sudo gdebi google-chrome-stable_current_amd64.deb

# 2. install through software repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install google-chrome-stable

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

    sudo apt-get install evolution

- 卸载方法

    sudo apt-get purge evolution


#### Geary

#### Mutt

- 介绍

类Unix系统下基于文本的邮件客户端

- 下载位置

[Download](http://www.mutt.org/)

- 安装方法

    sudo apt-get install mutt

- 卸载方法

    sudo apt-get install mutt


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

    sudo gdebi skypeforlinux-64.deb

- 卸载方法

    sudo dpkg -r skypeforlinux

- 备注

目前只支持 64 位版本的 `deb` 和 `rpm` 安装包。


#### Skype WebPage

- 介绍

最清晰的免费网络电话，提供文字、声音和视频聊天

- 安装方法

使用 Skype Beta 的[网页版本](https://web.skype.com)


#### BearyChat

#### Telegram

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

    sudo apt-get install pidgin

- 卸载方法

    sudo apt-get purge pidgin


#### XChat

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

#### ~~XwareDesktop~~

#### FlareGet

- 介绍

支持多协议，多线程的下载软件

- 下载位置

[Download](https://flareget.com/download)

- 安装方法

    sudo gdebi flareget_4.3-95_amd64.deb

- 卸载方法

    sudo dpkg -r flareget


#### UGet

- 介绍

轻量级的全能下载管理器

- 下载位置

[Download](http://ugetdm.com/downloads)

- 安装方法

    sudo apt-get install uget

- 卸载方法

    sudo apt-get purge uget


#### Wget

- 介绍

运行在命令行下的多协议下载软件

- 下载位置

[Download](http://www.gnu.org/software/wget/)

- 安装方法

    sudo apt-get install wget

- 卸载方法

    sudo apt-get purge wget


#### Transmission

- 介绍

一种BitTorrent客户端，特点是一个跨平台的后端和其上的简洁的用户界面

- 下载位置

[Download](http://www.transmissionbt.com/download/)

- 安装方法

    sudo apt-get install transmission

- 卸载方法

    sudo apt-get purge transmission


#### qBittorrent

#### Aria2

- 介绍

运行在命令行下的轻量级下载软件

- 下载位置

[Download](http://sourceforge.net/projects/aria2/files/stable/aria2-1.15.2/)

- 安装方法

    sudo apt-get install aria2

- 卸载方法

    sudo apt-get purge aria2


#### Filezilla

- 介绍

免费、开源的最强FTP客户端软件

- 下载位置

[Download](https://filezilla-project.org/)

- 安装方法

    sudo apt-get install filezilla

- 卸载方法

    sudo apt-get purge filezilla


### 云存储

#### ~~金山快盘~~

#### ~~bcloud(百度云)~~

- 介绍

百度网盘的linux桌面客户端

- 下载位置

[bcloud源码](https://github.com/LiuLang/bcloud)  
[bcloud安装包](https://github.com/LiuLang/bcloud-packages)

- 安装方法

```
git clone https://github.com/LiuLang/bcloud-packages
cd bcloud-packages/
sudo gdebi bcloud_XXX_all.deb
cd ..
rm -rf bcloud-packages
```
 
- 卸载方法

    sudo dpkg -r bcloud


#### 坚果云


#### Dropbox

#### OwnCloud

#### Google Drive

#### NextCloud

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

### 远程控制

#### TeamViewer

#### Remmina

#### AnyDesk

## 图像影音

### 音乐播放

#### ~~kwplayer~~

- 介绍

酷我音乐盒的 Linux 客户端

- 下载位置

[kwplayer源码](https://github.com/LiuLang/kwplayer)  
[kwplayer安装包](https://github.com/LiuLang/kwplayer-packages)

- 安装方法

```
git clone https://github.com/LiuLang/kwplayer-packages
cd kwplayer-packages/
sudo gdebi kwplayer_XXX_all.deb
cd ..
rm -rf kwplayer-packages
```

- 卸载方法

    sudo dpkg -r kwplayer


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

[官方网站](http://banshee.fm/)

[安装包下载](http://banshee.fm/download/)

- 安装方法

    sudo apt-get install banshee

- 卸载方法

    sudo apt-get purge banshee


#### Rhythmbox

- 介绍

Gnome桌面中默认带的音乐播放器，提供音乐管理与播放的强大播放器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Rhythmbox)

- 安装方法

    sudo apt-get install rhythmbox

- 卸载方法

    sudo apt-get purge rhythmbox


### 视频播放

#### SMPlayer

- 介绍

一个基于mplayer2的视频播放器，可能是Linux下最方便的视频播放器

- 下载位置

[Download](http://smplayer.sourceforge.net/)

- 安装方法

    sudo apt-get install smplayer

- 卸载方法

    sudo apt-get purge smplayer


#### VLC

- 介绍

全平台的自由多媒体解决方案

- 官方网站

[Official website](http://www.videolan.org/)

- 安装方法

    sudo apt-get install vlc

- 卸载方法

    sudo apt-get purge vlc


#### mpv

- 介绍

专注与视频播放质量和体验。GUI？我们不需要，配置文件更高效。

- 官方网站

[Official website](https://mpv.io/)
[GitHub](https://github.com/mpv-player/mpv)

- 安装方法

    sudo apt-get install mpv

- 卸载方法

    sudo apt-get purge mpv


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

    sudo apt-get purge kodi
    
- 中文插件

[xbmc-addons-chinese](https://github.com/taxigps/xbmc-addons-chinese)


### 图像浏览

#### Eye of GNOME(EOG)

- 介绍

Gnome桌面中默认的图片查看器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/EyeOfGnome)

- 安装方法

    sudo apt-get install eog

- 卸载方法

    sudo apt-get purge eog


#### gThumb

- 介绍

Gnome桌面中的图片查看器及浏览器

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/gthumb)

- 安装方法

    sudo apt-get install gthumb

- 卸载方法

    sudo apt-get purge gthumb


## 游戏娱乐

### 游戏平台

#### Steam

- 介绍

目前全球最大的综合性数字发行平台

- 下载位置

[官方网站](http://store.steampowered.com/)

- 安装方法

    sudo apt-get install steam

- 卸载方法

    sudo apt-get purge steam


### Gnome自带小游戏

#### gnome-2048

- 介绍

2048小游戏

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/2048)

- 安装方法

    sudo apt-get install gnome-2048

- 卸载方法

    sudo apt-get purge gnome-2048


#### Gnomine

- 介绍

扫雷

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Mines)

- 安装方法

    sudo apt-get install gnomine

- 卸载方法

    sudo apt-get purge gnomine


#### Sudoku

- 介绍

数独

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Sudoku)

- 安装方法

    sudo apt-get install gnome-sudoku

- 卸载方法

    sudo apt-get purge gnome-sudoku


#### Quadrapassel

- 介绍

俄罗斯方块，原名为Gnometris

- 下载位置

[官方网站](https://wiki.gnome.org/Apps/Quadrapassel)

- 安装方法

    sudo apt-get install quadrapassel

- 卸载方法

    sudo apt-get purge quadrapassel


## 文件管理

### 文件管理

#### Nautilus

### 压缩打包

#### fileroller

#### unzip/zip

## 办公应用

### 输入法

#### ibus + sunpinyin

#### fcitx + sunpinyin/googlepinyin

#### fcitx + sogoupinyin

### 文档阅读

#### Evince

#### Okular

#### Foxit Reader

### 办公套件

#### Libre Office

#### WPS Office

### 笔记记事

#### Google Keep

记事和清单

#### WizNote

为知笔记 [linux版源代码](https://github.com/WizTeam/WizQTClient)

#### NixNote

[Evernote 开源版本](https://sourceforge.net/projects/nevernote/)

## 教育科学

### 教育软件

#### Texmaker

#### Latexila

#### Lyx

#### TeXstudio

#### Texlive

## 科学软件

#### Mendeley

## 虚拟化

### 虚拟机

#### VMware Play/Workstation

#### VirtualBox

#### Boxes

## 监视和控制

### 硬件查询

#### CPU-G

#### Hardinfo

#### I-Nex

#### Psensor

### 系统监视

#### System Monitor

#### Htop

### 远程控制

#### TeamViewer

#### Chrome Remote Desktop

#### Remmina

#### AnyDesk

#### Putty

## 系统安全

### 密码管理

#### KeePass2

#### KeePassX

### 杀毒软件

#### ClamAV

## 系统工具

### 终端模拟器

#### Gnome Terminal
 
- 介绍

Gnome Terminal 是 Gnome 桌面环境中的终端模拟软件

- 官方网站

[Official Website](https://help.gnome.org/users/gnome-terminal/stable/index.html.en)
[GitHub](https://github.com/GNOME/gnome-terminal)

- 安装方法

    sudo apt-get install gnome-terminal

- 卸载方法

    sudo apt-get purge gnome-terminal


#### Terminator

- 介绍

Terminator 是一个程序，它可让用户自由地排布多个 GNOME 终端，而不用通过窗口管理器来实现，比较适合需要同时打开多个终端的用户

- 官方网站

[Official Website](http://gnometerminator.blogspot.com/p/introduction.html)

- 安装方法

    sudo apt-get install terminator

- 卸载方法

    sudo apt-get purge terminator


#### tmux

- 介绍

GNU screen 类似的程序，可作为 screen 的替代品使用

- 官方网站

[Official Website](http://sourceforge.net/projects/tmux/)

- 安装方法

    sudo apt-get install tmux

- 卸载方法

    sudo apt-get purge tmux


### Shell

### 启动盘制作工具

#### UNetbootin

#### dd

## 系统管理

### 配置工具

#### Tweak Tool

## 程序开发

### 版本控制

#### Git

#### SVN

### 本文编辑器

#### Sublime Text

#### Visual Studio Code

#### gedit

#### Atom

#### Vim

#### Emacs

### 集成开发环境

#### Eclipse IDE

#### JetBrains IDE

#### Wireshark

#### Code Blocks

## 其他
