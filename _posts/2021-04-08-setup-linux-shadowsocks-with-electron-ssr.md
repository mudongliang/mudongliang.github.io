---
layout: post
title: "Setup Linux Shadowsocks with electron ssr"
date: 2021-04-08
description: ""
category: 
tags: []
---
* TOC
{:toc}

### Install electron-ssr

Download electron-ssr from [Github Repo](https://github.com/shadowsocksrr/electron-ssr) and install it on Ubuntu Linux

```
wget https://github.com/shadowsocksrr/electron-ssr/releases/download/v0.2.7/electron-ssr-0.2.7.deb
sudo gdebi electron-ssr-0.2.7.deb
```

### Configure electron-ssr

Launch "eletron-ssr" from the Application View, and click "配置" -> "选项设置...". In the new window, select "订阅管理" and configure the subscription.

![eletron-ssr_configure]({{site.url}}/images/eletron-ssr.png)
