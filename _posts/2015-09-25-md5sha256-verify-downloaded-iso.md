---
layout: post
title: "md5/sha256 verify downloaded iso"
date: 2015-09-25
description: ""
category: 
tags: []
---

From [this website](http://mirrors.ustc.edu.cn/linuxmint-cd/stable/17.1/), I downloaded the following four files:

    linuxmint-17.1-cinnamon-32bit.iso    26-Nov-2014 23:52    1412431872
    md5sum.txt                       09-Jan-2015 14:09    958
    sha256sum.txt                    09-Jan-2015 14:10    1406
    sha256sum.txt.gpg                09-Jan-2015 14:11    198

**md5sum:**

    $ md5sum -c md5sum.txt 2> /dev/null | grep "OK"

**sha256sum:**

    $ sha256sum -c sha256sum.txt 2> /dev/null | grep "OK"

if there are a file which has the sha1sum of files in current directory, you can use sha1sum to check sum :

    sha1sum :     $ sha1sum -c sha1sum.txt 2> /dev/null | grep "OK"

