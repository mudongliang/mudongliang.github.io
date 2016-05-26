---
layout: post
title: "FORTIFY_SOURCE Examples"
date: 2016-05-25
description: ""
category: 
tags: []
---

## Theory in FORTIFY_SOURCE
```c
__strcpy_chk : __dest, __src, __bos (__dest)
__builtin___strcpy_chk : __dest, __src, __bos (__dest)
```

The first and second argument inherits from strcpy. The third argument is the length of __dest and identified by compile time.

```c
+#define strcpy(dst, src) \
+  __builtin___strcpy_chk (dst, src, os (dst))

+char *
+__strcpy_chk (char *d, const char *s, __SIZE_TYPE__ size)
+{
+  /* If size is -1, GCC should always optimize the call into strcpy.  */
+  if (size == (__SIZE_TYPE__) -1)
+    abort ();
+  ++chk_calls;
+  if (strlen (s) >= size)
+    __chk_fail ();
+  return strcpy (d, s);
+}
```

There are 5 cases to analyze:

### 1. Known correct

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/fortify_source/0/fortify_source1.c)

```c
int main(int argc,const char *argv[])
{	
	char buffer[10];
	if (argc < 1) {
		printf("need one argument"); 
	}
	strcpy(buffer, "abcdefg");
	return 0;
}
```

**Running Result:**    
No warning and no runtime check.

### 2. Known incorrect

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/fortify_source/0/fortify_source2.c)

```c
int main(int argc,const char *argv[])
{	
	char buffer[10];
	if (argc < 1) {
		printf("need one argument"); 
	}
	strcpy(buffer, "abcdefghijklmn");
	return 0;
}
```

**Running Result:**

```sh
In function ‘strcpy’,
    inlined from ‘main’ at fortify_source2.c:17:2:
/usr/include/x86_64-linux-gnu/bits/string3.h:104:3: warning: call to __builtin___memcpy_chk will always overflow destination buffer
    return __builtin___strcpy_chk (__dest, __src, __bos (__dest));
		     ^
```
Warning and runtime check.

### 3. Not known if correct, not checkable at runtime 

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/fortify_source/0/fortify_source3.c)

```c
int main(int argc,const char *argv[])
{	
	char buffer[10];
	if (argc < 2) {
	    printf("need one argument");
	}
	char *p = argv[2];
	char *q = argv[1];
	strcpy(p, q);
	return 0;
}
```

**Running Result:**    
No warning and no runtime check. The length of argv[2], argv[1] can't be detected at compile time.

### 4. Not known if correct, but checkable at runtime

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/fortify_source/0/fortify_source.c)

```c
int main(int argc,const char *argv[])
{	
	char buffer[10];
	if (argc < 1) {
		printf("need one argument"); 
	}
	strcpy(buffer, argv[1]);
	return 0;
}
```

**Running Result:**    
Warning and runtime check. The length of buffer is 10 at compile time.

### 5. Difference between 1 and 2(-D_FORTIFY_SOURCE)


[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/fortify_source/0/fortify1vs2.c)

```c
struct S {
	struct T {
		char buf[5];
		int x;
	} t;
	char buf[20];
} var;

int main(int argc,const char *argv[])
{
	strcpy(&var.t.buf[1], argv[1]);
	return 0;
}
```

**Running Result:**    
Compare the assembly language with different flags of gcc:

1. -D_FORTIFY_SOURCE = 1 

```
0x0000000000000654 <+4>:	lea    0x200565(%rip),%rax  # 0x200bc0 <var>
0x000000000000065b <+11>:	mov    0x8(%rsi),%rsi
0x000000000000065f <+15>:	mov    $0x4,%edx
0x0000000000000664 <+20>:	lea    0x1(%rax),%rdi
0x0000000000000668 <+24>:	callq  0x630 <__strcpy_chk@plt>

```

2. -D_FORTIFY_SOURCE = 2

```
0x0000000000000654 <+4>:	lea    0x200565(%rip),%rax  # 0x200bc0 <var>
0x000000000000065b <+11>:	mov    0x8(%rsi),%rsi
0x000000000000065f <+15>:	mov    $0x1f,%edx
0x0000000000000664 <+20>:	lea    0x1(%rax),%rdi
0x0000000000000668 <+24>:	callq  0x630 <__strcpy_chk@plt>
```

When -D_FORTIFY_SOURCE equals 1, edx is set to 4, the length of buffer : 4 (5 - 1); It separate the members in struct, so the edx is 4;
When -D_FORTIFY_SOURCE equals 2, edx is set to 31, the length of buffer : 31 (32 - 1); It regards struct S as a whole, so the edx is 31.    

