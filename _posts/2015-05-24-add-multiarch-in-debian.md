---
layout: post
title: "add multiarch in Debian"
date: 2015-05-24
description: ""
category: 
tags: []
---

# add multiarch(i386 or others) in Debian

### Add
```sh
# The procedures to add multiarch i386 in Debian Jessie
# Add (For example, i386)

# dpkg --add-architecture i386
# apt-get update
```

**Comment**: Nothing is really changed until you do the above command
 to update the available package lists

### List

    dpkg --get-selections | grep ":i386" | awk '{print $1}'

### Purge 
Before you remove the selected architecture, please remove/purge all the package in this architecture:

    apt-get purge `dpkg --get-selections | grep ":i386" | awk '{print $1}'

### Remove (For example, i386)

    dpkg --remove-architecture i386
