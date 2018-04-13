---
layout: post
title: "One failed kernel patch"
date: 2018-03-20
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Instructions

### clone linux git repository

```
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
```

### Modify The Kernel Code

```
git add Documentation/ia64/xen.txt
git commit -a -s -m "fix one dead link in ia64/xen.txt" #-e
git status
```

### Generate Patch

```
git format-patch -1
vim 0001-fix-one-dead-link-in-ia64-xen.txt.patch 
```

### Check generated Patch

```
./scripts/checkpatch.pl 0001-fix-one-dead-link-in-ia64-xen.txt.patch 
```

### Get Maintainer List

```
./scripts/get_maintainer.pl Documentation/ia64/ -f
```

### Send Patch

```
git send-email --subject-prefix="PATCH v2"  --smtp-server /usr/bin/msmtp --to corbet@lwn.net --to yamada.masahiro@socionext.com --to slyfox@gentoo.org --to tony.luck@intel.com --to bjorn.forsman@gmail.com --to mudongliangabcd@gmail.com -cc linux-doc@vger.kernel.org -cc linux-kernel@vger.kernel.org 0001-fix-one-dead-link-in-ia64-xen.txt.patch
```

If you don't want to type the password every time, you could set your password in configuration file of msmtp

## Result

:( [https://lkml.org/lkml/2018/3/20/735](https://lkml.org/lkml/2018/3/20/735) :(

## References

[1] [https://vthakkar1994.wordpress.com/2017/01/21/sending-patches-with-the-git-send-email/](https://vthakkar1994.wordpress.com/2017/01/21/sending-patches-with-the-git-send-email/)

[2] [http://dinosaursareforever.blogspot.com/2013/07/using-git-send-email-for-sending-kernel.html](http://dinosaursareforever.blogspot.com/2013/07/using-git-send-email-for-sending-kernel.html)

[3] [http://blog.chinaunix.net/uid-28453894-id-3552774.html](http://blog.chinaunix.net/uid-28453894-id-3552774.html)
