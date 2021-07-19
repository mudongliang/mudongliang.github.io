---
layout: post
title: "objtool: Fix GCC  Wrestrict error in str_error_r"
date: 2021-07-19
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem

```
../lib/str_error_r.c: In function ‘str_error_r’:
../lib/str_error_r.c:25:3: error: passing argument 1 to restrict-qualified parameter aliases with argument 5 [-Werror=restrict]
   25 |   snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, %p, %zd)=%d", errnum, buf, buflen, err);
      |   ^~~~~~~~
cc1: all warnings being treated as errors
mv: cannot stat 'linux/objtool/.str_error_r.o.tmp': No such file or directory
make[3]: *** [Build:22: linux/tools/objtool/str_error_r.o] Error 1
make[2]: *** [Makefile:46: linux/tools/objtool/objtool-in.o] Error 2
```

## Solution

```
diff --git a/tools/lib/str_error_r.c b/tools/lib/str_error_r.c
index d6d65537b0d9b..6aad8308a0acf 100644
--- a/tools/lib/str_error_r.c
+++ b/tools/lib/str_error_r.c
@@ -22,6 +22,6 @@ char *str_error_r(int errnum, char *buf, size_t buflen)
 {
 	int err = strerror_r(errnum, buf, buflen);
 	if (err)
-		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, %p, %zd)=%d", errnum, buf, buflen, err);
+		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, [buf], %zd)=%d", errnum, buflen, err);
 	return buf;
 }
```

## References

[1] [objtool, perf: Fix GCC 8 -Wrestrict error](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=854e55ad289ef8888e7991f0ada85d5846f5afb9)
