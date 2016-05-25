---
layout: post
title: "Debian \"There is no public key available for the following key IDs\"问题解决"
date: 2015-06-15
description: ""
category: 
tags: []
---

    W: There is no public key available for the following key IDs:

我记得是我直接删除gpg文件造成的问题，不过对于这个问题的解决方法十分简单，将如下代码以root身份输入一下就可以解决！

Code:

    # apt-get install debian-keyring debian-archive-keyring
    # apt-key update


