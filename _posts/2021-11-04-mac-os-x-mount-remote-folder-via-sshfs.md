---
layout: post
title: "Mac OS X mount remote folder via SSHFS"
date: 2021-11-04
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Steps

1. Install two applications: macFUSE and SSHFS

[macFUSE download webpage](https://github.com/osxfuse/osxfuse/releases)

[SSHFS download webpage](https://github.com/osxfuse/sshfs/releases)

2. mount remote folder with sshfs command

```
$ sshfs username@server:folder_name local_folder
```

For convience, we can add an alias command in the bashrc/bash_profile.

## References

[1] https://osxfuse.github.io/

