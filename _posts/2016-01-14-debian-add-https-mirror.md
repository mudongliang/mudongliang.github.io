---
layout: post
title: "Debian add https mirror"
date: 2016-01-14
description: ""
category: 
tags: []
---

# Debian add https mirror

如果你在Debian中加入https的mirror，比如说，添加opera浏览器的源,添加Docker的源,

\# Add source in /etc/apt/sources.list 

```sh
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free' 
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add - 
sudo apt-get update 
```

**Comment:** 如果觉得直接写入到`/etc/apt/sources.list`有些不妥,你可以自己将软件的内容放入到`/etc/apt/sources.list.d/XXX.list`文件中.

这里会发现一个问题，由于https源的问题导致无法更新，解决这个问题的办法是：

    sudo apt-get install apt-transport-https

然后，我们就可以安装opera浏览器。

    sudo apt-get update
    sudo apt-get install opera-stable

但是，发现ubuntu14.04已经安装这个包了，可以直接使用https mirror.
