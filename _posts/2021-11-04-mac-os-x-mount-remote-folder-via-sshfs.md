---
layout: post
title: Draft for "Mac OS X mount remote folder via SSHFS"
date: 2021-11-04
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Steps

1. Install two applications: macFUSE and SSHFS

2. mount remote folder with sshfs command

```
$ sshfs username@server:folder_name local_folder
```

## References

[1] https://osxfuse.github.io/
