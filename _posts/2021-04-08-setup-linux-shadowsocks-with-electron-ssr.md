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


### Software Dependency

```
sudo apt install python-is-python3
sudo apt install libssl-dev libsodium-dev
```

### Install electron-ssr

Download electron-ssr from [Github Repo](https://github.com/shadowsocksrr/electron-ssr) and install it on Ubuntu Linux

```
wget https://github.com/shadowsocksrr/electron-ssr/releases/download/v0.2.7/electron-ssr-0.2.7.deb
sudo gdebi electron-ssr-0.2.7.deb
```

### Configure electron-ssr

Launch "eletron-ssr" from the Application View, and click "配置" -> "选项设置...". In the new window, select "订阅管理" and configure the subscription.

![eletron-ssr_configure]({{site.url}}/images/eletron-ssr.png)

### Problem Analysis

```
ERROR    tcprelay.py:1095 [Errno 2] No such file or directory: b'liblibcrypto.a' when handling connection
```

```
sudo ln -s /usr/lib/x86_64-linux-gnu/libcrypto.a /usr/lib/x86_64-linux-gnu/liblibcrypto.a
```

### References

[1] <https://github.com/qingshuisiyuan/electron-ssr-backup/blob/master/Ubuntu.md>

[2] <https://blog.csdn.net/qq_35975855/article/details/126255285>

[3] <https://github.com/qingshuisiyuan/electron-ssr-backup/issues/26>

[4] <https://www.jianshu.com/p/fba8637da1e3>

