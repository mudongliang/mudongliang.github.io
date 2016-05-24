---
layout: post
title: "Debian 64bit install skype"
date: 2015-05-25
description: ""
category: 
tags: []
---

# Debian64 install skype(from Debian Wiki)

First, you will have to enable [Multi-Arch](https://wiki.debian.org/Multiarch/HOWTO); type in the following commands in ROOT Terminal:

```sh
# dpkg --add-architecture i386
# apt-get update
```

Then, download the i386 package as above and install:

```sh
# wget -O skype-install.deb http://www.skype.com/go/getskype-linux-deb
# dpkg -i skype-install.deb
```

To fix missing dependencies, you might want to use:

```sh
# apt-get -f install
```
