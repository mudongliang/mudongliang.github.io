---
layout: post
title: "replace rm with trash"
date: 2016-02-03
description: ""
category: 
tags: []
---

Replace `rm` with `trash`, so that the deleted files will be put into the trash, other than deleted forever.

    sudo apt-get install trash-cli
    alias rm=trash
