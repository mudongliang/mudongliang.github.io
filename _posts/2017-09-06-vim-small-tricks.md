---
layout: post
title: "Vim small tricks"
date: 2017-09-06
description: ""
category: 
tags: []
---
* TOC
{:toc}

### Tricks

- remove whitespace (a space or a tab) in the end of line

```
:%s/\s\+$//e
```

- insert C comment (`//`) in the start of line

```
:1,3s/^/\/\//
```
