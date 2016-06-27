---
layout: post
title: "Debian 添加与设置 locale"
date: 2015-06-21
description: ""
category: 
tags: []
---

如果没有安装locale工具，则首先要安装它，然后执行

    #dpkg-reconfigure locales

![Index]({{site.url}}/images/index.png)

**小技巧**：中间可以使用PageDown翻页，下键太慢了，毕竟“zh_CN”在最后面！

选择语言包。需要添加上en_US(以为我之后把它给删了),zh_CN等开头的几个选项，当然你也可以只添加一个，然后，选择其中的一个作为默认。设置完成后，执行locale命令检查一下当前的locale设置是否为英文或中文了。

![Locale]({{site.url}}/images/index.png)
