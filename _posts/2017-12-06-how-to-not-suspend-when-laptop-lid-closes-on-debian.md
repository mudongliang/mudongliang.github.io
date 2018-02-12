---
layout: post
title: "How to not suspend when you close Laptop Lid on Debian"
date: 2017-12-06
description: ""
category:
tags: []
---
* TOC
{:toc}

## Problem

In `Ubuntu`, we could set **"Do not do anything when Laptop Lid"** in the Power Setting. But in `Debian` there is not any option in the Power Setting. We could only modify the configuration file of `Login Manager` to achieve this goal.

## Solution

```
sudo gedit /etc/systemd/logind.conf`

#HandleLidSwitch=suspend -> HandleLidSwitch=ignore

reboot
```

## References

[1] [https://linux.cn/article-2485-1.html](https://linux.cn/article-2485-1.html)

[2][http://blog.csdn.net/acxlm/article/details/78248819](http://blog.csdn.net/acxlm/article/details/78248819)
