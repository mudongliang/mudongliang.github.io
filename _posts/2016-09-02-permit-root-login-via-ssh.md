---
layout: post
title: "Permit Root Login Via SSH"
date: 2016-09-02
description: ""
category: 
tags: []
---

1.Edit /etc/ssh/sshd_config with sudo or root privilege

    $ sudo vim /etc/ssh/sshd_config

2.Uncomment "#PermitRootLogin without-password", Add "PermitRootLogin yes"

    # Authentication:
    LoginGraceTime 120
    #PermitRootLogin without-password
    PermitRootLogin yes
    StrictModes yes

3.Restart SSH Service

    # service ssh restart

Or

    # systemctl restart ssh
