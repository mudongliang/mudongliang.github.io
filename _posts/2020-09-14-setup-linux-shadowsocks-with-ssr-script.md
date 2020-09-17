---
layout: post
title: "Setup Linux Shadowsocks with ssr script"
date: 2020-09-14
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Setup Linux Shadowsocks with ssr script

### Setup ShadowsocksR client tool

I occosionally got one useful script(See Reference 1) from my friend. It saved me lots of efforts to configure shadowsocks on Linux platform. So I would like to share it through my blog.

Let's first look at its help menu.
```
ShadowSocksR python client tool
if you have not installed ssr, run `ssr install` first
Usage:
	 ssr help

 Install/Uninstall
	 ssr install      install shadowsocksr client
	 ssr uninstall    uninstall shadowsocksr client

 Config and Subscribe
	 ssr update       update subscription from http://ss.pythonic.life
	 ssr config       edit config.json
	 ssr xclip        paste configs from clipboard to config.json

 Start/Stop/Restart
	 ssr start        start the shadowsocks service
	 ssr stop         stop the shadowsocks service
	 ssr restart      restart the shadowsocks service

 Testing and Maintenance
	 ssr test         get ip from cip.cc using socks5 proxy
	 ssr log          cat the log of shadowsocks
	 ssr shell        cd into ssr installation dir
	 ssr clean        clean ssr configuration backups
```

Its uasage is very simple - `ssr install` -> `ssr config` -> `ssr start`.

In the end of starting, it leverages `proxychains4` to test whether the configuration is working.

Note that, you could buy *paofu* subscription and export server configuration from Mac/Windows clients.

### Configure local proxy

Next, you need to configure local proxy to use shadowsocks

First, open `Network` from `Setting`,

![proxy]({{site.url}}/images/network_proxy.png)

Second, configure the proxy with **Socks Host: 127.0.0.1** and **Ports: 1080**, like the following picture,

![manual]({{site.url}}/images/proxy_manual.png)

## References

[1] [ssr script](https://github.com/the0demiurge/CharlesScripts/blob/master/charles/bin/ssr)
