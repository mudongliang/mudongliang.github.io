---
layout: post
title: "Manually remove a broken package in Ubuntu/Debian"
date: 2015-07-20
description: ""
category: 
tags: []
---

To manually uninstall the broken package run the two commands below as root in Debian, preceded by sudo in Ubuntu (PACKAGE_NAME is your broken package name):

    mv /var/lib/dpkg/info/PACKAGE_NAME.* /tmp/
    dpkg --remove --force-remove-reinstreq PACKAGE_NAME

这些操作没有看懂是什么意思，都是单纯的执行这样的操作就搞好了，不需要解释.
