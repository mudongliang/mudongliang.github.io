---
layout: post
title: "Debian/Ubuntu/LinuxMint 安装openyoudao，换下有道linux版"
date: 2015-05-08
description: ""
category: 
tags: []
---

# Debian/Ubuntu/LinuxMint 安装openyoudao，换下有道linux版

**Linux 有道**

- 精美的界面设计

关于图形界面这个东西，在debian jessie中有外部空的边框，很难看。LinuxMint还好！

- 精准的多语言翻译

吐槽，无法和中文输入法配合，我用的fcitx（google，sougou，...）无法在主界面的查询框中输入中文。我在Debian/Ubuntu/LinuxMint三个发行版上都测了一下，都不可以，这个实在是让我很无语！

- 海量的网络词汇与专业词汇

- 原声发音和图解词典

- 智能的屏幕取词与划词

这个是我最希望用到的功能，在Debian下没办法使用
所以我就一直在寻找替代品，终于想起来了以前在刷网页的时候看见过的openyoudao，虽然openyoudao界面和windows版本不是很一样，但是这个取词翻译功能听好用的，反正基本上我用的都是有道的取词翻译，只不过你需要将这个程序一直放在最前。这些问题都不是很大的问题，因为openyoudao是开源的，代码托管在Github上面，我们可以fork之后，修改然后pull request ！并且作者声明还是会继续维护下去的，可以放心使用！

下面我们来说一下安装的方法，其安装过程在官网上面和Github上面都有详细的方法，我在这里简单说明一下，

```sh
Add mirrorlist:

deb http://ppa.launchpad.net/justzx2011/openyoudao-v0.4/ubuntu trusty main
deb-src http://ppa.launchpad.net/justzx2011/openyoudao-v0.4/ubuntu trusty main
```

在/etc/apt/sources.list.d/下面建立一个openyoudao.list(强烈建议，对于软件源的修改， 轻易不要去修改sources.list,虽然同样就是添加两行，但是稍有不甚就可能会影响到整个系统的软件更新，但是如果你放到一个单独文件中的话，就不会影响这个系统)， 将上述两行代码拷贝到这个文件中！ 具体的操作命令如下：

```sh
sudo gedit /etc/apt/sources.list.d/openyoudao.list
```

然后拷贝内容！

```sh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14C9B91C3F9493B9
sudo apt-get update
sudo apt-get install openyoudao
```
