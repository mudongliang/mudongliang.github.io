---
layout: post
title: "#error New address family defined, please update secclass_map."
date: 2021-01-20
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem 

When compiling genheaders and mdp from a newer host kernel, the following error happens:

```
In file included from scripts/selinux/genheaders/genheaders.c:18:
./security/selinux/include/classmap.h:238:2: error: 
#error New address family defined, please update secclass_map.  
#error New address family defined, please update secclass_map. ^~~~~
make[3]: *** [scripts/Makefile.host:107:
scripts/selinux/genheaders/genheaders] Error 1 make[2]: ***
[scripts/Makefile.build:599: scripts/selinux/genheaders] Error 2
make[1]: *** [scripts/Makefile.build:599: scripts/selinux] Error 2
make[1]: *** Waiting for unfinished jobs....
```

Instead of relying on the host definition, include linux/socket.h in classmap.h to have PF_MAX.

## Solution

```
---
 scripts/selinux/genheaders/genheaders.c | 1 -
 scripts/selinux/mdp/mdp.c               | 1 -
 security/selinux/include/classmap.h     | 1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
index 1ceedea847dd..544ca126a8a8 100644
--- a/scripts/selinux/genheaders/genheaders.c
+++ b/scripts/selinux/genheaders/genheaders.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <errno.h>
 #include <ctype.h>
-#include <sys/socket.h>
 
 struct security_class_mapping {
 	const char *name;
diff --git a/scripts/selinux/mdp/mdp.c b/scripts/selinux/mdp/mdp.c
index 073fe7537f6c..6d51b74bc679 100644
--- a/scripts/selinux/mdp/mdp.c
+++ b/scripts/selinux/mdp/mdp.c
@@ -32,7 +32,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
-#include <sys/socket.h>
 
 static void usage(char *name)
 {
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index bd5fe0d3204a..201f7e588a29 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/capability.h>
+#include <linux/socket.h>
 
 #define COMMON_FILE_SOCK_PERMS "ioctl", "read", "write", "create", \
     "getattr", "setattr", "lock", "relabelfrom", "relabelto", "append", "map"
-- 
2.20.1
```

[1] <https://lore.kernel.org/selinux/20190225005528.28371-1-paulo@paulo.ac/>
