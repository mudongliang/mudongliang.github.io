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

```
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 Documentation/ia64/xen.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ia64/xen.txt b/Documentation/ia64/xen.txt
index a12c74ce2773..464d4c29b8b5 100644
--- a/Documentation/ia64/xen.txt
+++ b/Documentation/ia64/xen.txt
@@ -26,8 +26,8 @@ Getting and Building Xen and Dom0
     DomainU OS  : RHEL5

  1. Download source
-    # hg clone http://xenbits.xensource.com/ext/ia64/xen-unstable.hg
-    # cd xen-unstable.hg
+    # hg clone http://xenbits.xensource.com/ext/ia64/xen-unstable
+    # cd xen-unstable
     # hg clone http://xenbits.xensource.com/ext/ia64/linux-2.6.18-xen.hg

  2. # make world
```

:( [https://lkml.org/lkml/2018/3/20/735](https://lkml.org/lkml/2018/3/20/735) :(
:( [https://lkml.org/lkml/2018/3/20/751](https://lkml.org/lkml/2018/3/20/751) :(

## References

[1] [https://vthakkar1994.wordpress.com/2017/01/21/sending-patches-with-the-git-send-email/](https://vthakkar1994.wordpress.com/2017/01/21/sending-patches-with-the-git-send-email/)

[2] [http://dinosaursareforever.blogspot.com/2013/07/using-git-send-email-for-sending-kernel.html](http://dinosaursareforever.blogspot.com/2013/07/using-git-send-email-for-sending-kernel.html)

[3] [http://blog.chinaunix.net/uid-28453894-id-3552774.html](http://blog.chinaunix.net/uid-28453894-id-3552774.html)
