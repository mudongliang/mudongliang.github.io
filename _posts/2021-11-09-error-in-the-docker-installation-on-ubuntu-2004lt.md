---
layout: post
title: "Error in the docker installation on Ubuntu 20.04LTS"
date: 2021-11-09
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem encountered

```
Error starting daemon: Error initializing network controller: 
list bridge addresses failed: no available network
```

## Solution

```
$ sudo su root
# ip link add name docker0 type bridge
# ip addr add dev docker0 172.17.0.1/16
```

## Reference

[1] https://github.com/docker/for-linux/issues/123#issuecomment-346546953
