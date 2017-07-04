---
layout: post
title: "gets undeclared here"
date: 2017-07-02
description: ""
category: 
tags: []
---

When compiling coreutils8.4 on Ubuntu 14.04.2LTS, I encountered one error as follows: 

```
./stdio.h:177:1: error: 'gets' undeclared here (not in a function)
 /* It is very rare that the developer ever has full control of stdin,
 ^
```

How to fix it:

`lib/stdio.h:177`

```
-_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
+//_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
```
