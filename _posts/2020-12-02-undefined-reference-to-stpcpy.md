---
layout: post
title: "undefined reference to 'stpcpy'"
date: 2020-12-02
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Porblem

When compiling Linux kernel with clang following [Tutorial 1](https://github.com/google/kmsan/blob/master/README.md) or [Turotial 2](https://github.com/ramosian-glider/clang-kernel-build), an error often occurs:

```
linux-kcsan/arch/x86/events/core.c:1703: undefined reference to `stpcpy'
ld: arch/x86/events/core.o: in function `events_ht_sysfs_show':
linux-kcsan/arch/x86/events/core.c:1726: undefined reference to `stpcpy'
ld: arch/x86/events/intel/uncore.o: in function `uncore_event_show':
linux-kcsan/arch/x86/events/intel/uncore.c:100: undefined reference to `stpcpy'
ld: security/apparmor/lsm.o: in function `param_get_mode':
linux-kcsan/security/apparmor/lsm.c:1559: undefined reference to `stpcpy'
ld: security/apparmor/lsm.o: in function `param_get_audit':
linux-kcsan/security/apparmor/lsm.c:1530: undefined reference to `stpcpy'
ld: drivers/xen/sys-hypervisor.o:linux-kcsan/drivers/xen/sys-hypervisor.c:375: more undefined references to `stpcpy' follow

```

## Solution

This is caused by a libcall optimization added in Clang 12 that optimizes certain basic sprintf calls into stpcpy calls. The correct fix for this is to cherry-pick ["lib/string.c: implement stpcpy"](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=5934637641c863cc2c1765a0d01c5b6f53ecc4fc), which adds a simple implementation of stpcpy to the kernel so that Clang can use it.

```
--- a/lib/string.c
+++ b/lib/string.c
@@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
 }
 EXPORT_SYMBOL(strscpy_pad);
 
+/**
+ * stpcpy - copy a string from src to dest returning a pointer to the new end
+ *          of dest, including src's %NUL-terminator. May overrun dest.
+ * @dest: pointer to end of string being copied into. Must be large enough
+ *        to receive copy.
+ * @src: pointer to the beginning of string being copied from. Must not overlap
+ *       dest.
+ *
+ * stpcpy differs from strcpy in a key way: the return value is the new
+ * %NUL-terminated character. (for strcpy, the return value is a pointer to
+ * src. This interface is considered unsafe as it doesn't perform bounds
+ * checking of the inputs. As such it's not recommended for usage. Instead,
+ * its definition is provided in case the compiler lowers other libcalls to
+ * stpcpy.
+ */
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src);
+char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
+{
+	while ((*dest++ = *src++) != '\0')
+		/* nothing */;
+	return --dest;
+}
+EXPORT_SYMBOL(stpcpy);
+
 #ifndef __HAVE_ARCH_STRCAT
 /**
  * strcat - Append one %NUL-terminated string to another
```

## References

[1] <https://awesomeopensource.com/project/kdrag0n/proton-clang>

[2] <https://github.com/nathanchance/android-kernel-clang/issues/16>
