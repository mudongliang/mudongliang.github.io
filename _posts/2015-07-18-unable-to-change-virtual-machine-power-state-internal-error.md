---
layout: post
title: "Linux VMware虚拟机报错 - Unable to change virtual machine power state: Internal error."
date: 2015-07-18
description: ""
category: 
tags: []
---

Linux下VMWare虚拟机报出来的一个错误:

    Unable to change virtual machine power state: Internal error.

问题分析：

This is a result of a zombie ‘vmware-vmx’ process running. All you need to do is kill the process. This command sends ’signal 9′ to the process. When sent to a program, SIGKILL causes it to terminate immediately. In contrast to SIGTERM and SIGINT, this signal cannot be caught or ignored. For more information: more sigkill info.

    sudo killall -s9 vmware-vmx

After that, virtual machine was able to start up without issue.
