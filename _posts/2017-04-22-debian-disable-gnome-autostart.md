---
layout: post
title: "Debian disable gnome autostart"
date: 2017-04-22
description: ""
category: 
tags: []
---

From [how to disable X server autostart](https://unix.stackexchange.com/questions/264393/how-to-disable-x-server-autostart-in-debian-jessie)

The disable didn't work because the Debian `/etc/X11/default-display-manager` logic is winding up overriding it.

In order to make text boot the default under systemd (regardless of which distro, really):

    systemctl set-default multi-user.target

To change back to booting to the GUI,

    systemctl set-default graphical.target

I confirmed those work on my Jessie and Stretch.
