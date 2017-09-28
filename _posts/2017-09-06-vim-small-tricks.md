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

### General Tricks

- remove whitespace (a space or a tab) in the end of line

```
:%s/\s\+$//e
```

- insert C comment (`//`) in the start of line

```
:1,3s/^/\/\//
```

### Commands for Multiple Screens

```
:split filename  - split window and load another file
:vsplit file     - vertical split
 
:hide            - close current window
:only            - keep only this window open
:ls              - show current buffers
:b 2             - open buffer #2 in this window
:bn              - open next buffer in this window
:bp              - open previous buffer in this window
```

**Shortcut:**

```
Ctrl+w Ctrl+w     - move cursor to another window (cycle) 
```
