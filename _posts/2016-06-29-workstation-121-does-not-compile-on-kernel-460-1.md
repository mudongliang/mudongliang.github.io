---
layout: post
title: "Workstation 12.1 does not compile on kernel 4.6.0 1"
date: 2016-06-29
description: ""
category: 
tags: []
---

From [Vmware Community](https://communities.vmware.com/thread/536705?start=0&tstart=0)

## Problem:

When I install Debian Stretch on my desktop and try to install vmware 12.1, there occurs some problems and some modules in vmware can't be compiled in 4.6.2. Detailed error log refers to the above link.

## Solution:

It's a bug - [Bug 1278896 – VMware Workstation 12 not starting On Fedora 23](https://bugzilla.redhat.com/show_bug.cgi?id=1278896)

You can solve this problem by the following instructions:

    1) backup vmmon.tar vmnet.tar
    $cd /usr/lib/vmware/modules/source
    $cp vmmon.tar vmmon.tar.bak
    $cp vmnet.tar vmnet.tar.bak

    2) vmmon.tar

    - untar vmmon.tar 
    $ tar -xvf vmmon.tar 

    - open ./vmmon-only/linux/hostif.c by vim
    - replace all : "get_user_pages" to "get_user_pages_remote" (only one place)

    - tar
    $ tar -cvf vmmon.tar vmmon-only/

    3) vmnet.tar

    - untar
    $ tar -xvf vmnet.tar

    - open ./vmnet-only/userif.c by vim
    - replace all : "get_user_pages" to "get_user_pages_remote" (only one place)

    - tar
    $ tar -cvf vmnet.tar vmnet-only/
