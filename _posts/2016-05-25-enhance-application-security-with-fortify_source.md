---
layout: post
title: "Enhance application security with FORTIFY_SOURCE"
date: 2016-05-25
description: ""
category: 
tags: []
---

From [Red Hat Security > BlogBlog Posts > Enhance application security with FORTIFY_SOURCE ](https://access.redhat.com/blogs/766093/posts/1976213)

The following is from [glibc mailing list](https://gcc.gnu.org/ml/gcc-patches/2004-09/msg02055.html):

------------------------------------------------------------

> The intended use in glibc is that by default no protection is    
> done, when the above GCC 4.0+ and `-D_FORTIFY_SOURCE=1` is used    
> at optimization level 1 and above, security measures that    
> shouldn't change behaviour of conforming programs are taken.    
> With `-D_FORTIFY_SOURCE=2` some more checking is added, but    
> some conforming programs might fail.    

> Buffer overflows can be detected at compile time    
> or at runtime, if the compiler can detect they will not    
> happen, normal functions as opposed to their checking    
> alternatives are used.    

Below are **four** different cases that can happen:

```c
char buf[5];

/* 1) Known correct.
      No runtime checking is needed, memcpy/strcpy
      functions are called (or their equivalents inline).  */
memcpy (buf, foo, 5);
strcpy (buf, "abcd");

/* 2) Not known if correct, but checkable at runtime.
      The compiler knows the number of bytes remaining in object,
      but doesn't know the length of the actual copy that will happen.
      Alternative functions __memcpy_chk or __strcpy_chk are used in
      this case that check whether buffer overflow happened.  If buffer
      overflow is detected, __chk_fail () is called (the normal action
      is to abort () the application, perhaps by writing some message
      to stderr.  */
memcpy (buf, foo, n);
strcpy (buf, bar);

/* 3) Known incorrect.
      The compiler can detect buffer overflows at compile
      time.  It issues warnings and calls the checking alternatives
      at runtime.  */
memcpy (buf, foo, 6);
strcpy (buf, "abcde");

/* 4) Not known if correct, not checkable at runtime.
      The compiler doesn't know the buffer size, no checking
      is done.  Overflows will go undetected in these cases.  */
memcpy (p, q, n);
strcpy (p, q);
```

> In the current implementation **mem{cpy,pcpy,move,set},**
> **st{r,p,nc}py, str{,n}cat, {,v}s{,n}printf and gets** functions
> are checked this way.

> The diffence between -D_FORTIFY_SOURCE=1 and -D_FORTIFY_SOURCE=2    
> is e.g. for    
> struct S { struct T { char buf[5]; int x; } t; char buf[20]; } var;    
> With -D_FORTIFY_SOURCE=1,    
> strcpy (&var.t.buf[1], "abcdefg");    
> is not considered an overflow (object is whole VAR), while    
> with -D_FORTIFY_SOURCE=2    
> strcpy (&var.t.buf[1], "abcdefg");    
> will be considered a buffer overflow.    

> Another difference is that with -D_FORTIFY_SOURCE=2, %n    
> in format strings of the most common *printf family functions    
> is allowed only if it is stored in read-only memory (usually    
> string literals, gettext's _("%s string %n") is fine too), but    
> usually when an attacker attempts to exploit a format string    
> vulnerability, %n will be somewhere where the attacker could    
> write it into.    

----------------------------------------------------------------

References:

[1][FORTIFY_SOURCE](https://idea.popcount.org/2013-08-15-fortify_source/)
