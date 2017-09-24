---
layout: post
title: "configure error : cannot run C compiled programs"
date: 2017-09-19
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Compile Error

```
configure: error: cannot run C compiled programs.

If you meant to cross compile, use `--host'.
```

### Check architecture

You could use `uname -m` to get the architecure. For my case,

```
$ uname -m
x86_64
```

### Add compile option

add "--host=x86_64" at the end of compile command.

## References

https://jingyan.baidu.com/article/2d5afd69d4da9685a3e28e63.html
