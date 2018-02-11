---
layout: post
title: "Install electronic wechat on Debian"
date: 2018-02-11
description: ""
category:
tags: []
---
* TOC
{:toc}

## Introduction

Electronic WeChat is a good Linux client for WeChat. As it shows in the official document:


> A better WeChat on macOS and Linux. Built with Electron.**

## Installation

1. Download the latest release from [Official Website](https://github.com/geeeeeeeeek/electronic-wechat/releases) according to your system. Here I use linux-x64.tar.gz;
2. Decompress the tar package and copy to one destination folder. Here I copy it to `/usr/local/`;
3. copy [wechat log](https://github.com/geeeeeeeeek/electronic-wechat/blob/master/assets/icon.png) in the Github repository to your local filesystem. Here I copy it to `/usr/local/electronic-wechat-linux-x64/`;
4. Write one desktop file or directly copy it from [My Gist](https://gist.github.com/mudongliang/7f74b94c3dc7cfbe1fc30f47fd90cfeb). You could put it in `~/.local/share/applications` or `/usr/share/applications`;

## Execution

After installation, you will see the one wechat logo in your application menu.

![wechat logo]({{site.url}}/images/wechat_logo.png)

Just click on the wechat logo, and scan through your phone.

## References

[1] [electronic-wechat](https://github.com/geeeeeeeeek/electronic-wechat)
