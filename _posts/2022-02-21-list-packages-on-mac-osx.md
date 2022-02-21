---
layout: post
title: "List packages on Mac OSX"
date: 2022-02-21
description: ""
category: 
tags: []
---
* TOC
{:toc}


1. List all installed package IDs

```
pkgutil --pkgs
```

2. Show extended information about the specified package-id

```
$ pkgutil -- pkgs | grep SSHFS
com.github.osxfuse.pkg.SSHFS

$ pkgutil --pkg-info com.github.osxfuse.pkg.SSHFS
package-id: com.github.osxfuse.pkg.SSHFS
version: 2.5.0
volume: /
location:
install-time: 1636031141
```

For further information, see details in [1].

## References

[1] [pkgutil manpage](https://www.manpagez.com/man/1/pkgutil/)
