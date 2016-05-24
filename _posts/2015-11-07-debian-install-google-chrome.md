---
layout: post
title: "Debian install Google Chrome"
date: 2015-11-07
description: ""
category: 
tags: []
---

# Debian系安装google chrome命令

```sh
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' 
sudo apt-get update 
sudo apt-get install google-chrome-stable
```
