---
layout: post
title: "change default shell to bash"
date: 2015-04-24
description: ""
category: 
tags: []
---

在 `Debian` 中 `/bin/sh` 是 `dash` 的链接，如果大家想用 `bash` 作为 default shell 的话，可以用以下的办法修改：

1) 直接将`/bin/sh`做成`bash`的链接，即可！（升级之后可能会恢复到`dash`）;

2) Bash as /bin/sh by default(以下是官方wiki上给出来的解决方法)

If your Jessie system is configured, so /bin/sh is dash, you can revert to bash using the command:

    sudo dpkg-reconfigure bash

and follow the instructions.
