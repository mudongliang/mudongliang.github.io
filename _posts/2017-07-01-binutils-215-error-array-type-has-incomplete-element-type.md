---
layout: post
title: "binutils 2.15 error: array type has incomplete element type"
date: 2017-07-01
description: ""
category: 
tags: []
---

When I tried to compile binutils-2.15 at Ubuntu 14.04.2 LTS. One error appeared:

```
./gas/config/tc-i386.h:457:32: error: array type has incomplete element type
extern const struct relax_type md_relax_table[];
```

Modify line 451 in gas/config/tc-i386.h :

```
extern const struct relax_type md_relax_table[];
=>
extern const struct relax_type * md_relax_table;
```

Modify Line 366 in gas/config/tc-i386.c:

```
const relax_typeS md_relax_table[] =
=>
const struct relax_type *md_relax_table =
```
Patch as follows:

```
diff --git a/binutils-2.15/gas/config/tc-i386.c b/binutils-2.15/gas/config/tc-i386.c
index 5de6a55..6809110 100644
--- a/binutils-2.15/gas/config/tc-i386.c
+++ b/binutils-2.15/gas/config/tc-i386.c
@@ -363,7 +363,7 @@ int x86_cie_data_alignment;
    prefix), and doesn't work, unless the destination is in the bottom
    64k of the code segment (The top 16 bits of eip are zeroed).  */
 
-const relax_typeS md_relax_table[] =
+const relax_typeS *md_relax_table =
 {
   /* The fields are:
      1) most positive reach of this state,
diff --git a/binutils-2.15/gas/config/tc-i386.h b/binutils-2.15/gas/config/tc-i386.h
index 14b522b..bdd6e9c 100644
--- a/binutils-2.15/gas/config/tc-i386.h
+++ b/binutils-2.15/gas/config/tc-i386.h
@@ -448,7 +448,7 @@ extern int tc_i386_fix_adjustable PARAMS ((struct fix *));
 
 #define md_operand(x)
 
-extern const struct relax_type md_relax_table[];
+extern const struct relax_type *md_relax_table;
 #define TC_GENERIC_RELAX_TABLE md_relax_table
 
 extern int optimize_align_code;
```
