---
layout: post
title: Draft for "CISCN2017   babydriver (2)"
date: 2022-02-24
description: ""
category: 
tags: []
---
* TOC
{:toc}

General cache and special/dedicated cache



Ubuntu 20.04 LTS

cred_jar is defined with kmem_cache_create

```
/ # cat /proc/slabinfo | grep cred_jar
cred_jar            2273   2583    192   21    1 : tunables    0    0    0 : slabdata    123    123      0
```

CISCN2017 babydriver 

```
/ # cat /proc/slabinfo | grep "cred_jar"
```

The CTF Challenge remove special cache cred_jar. This answers my question.

