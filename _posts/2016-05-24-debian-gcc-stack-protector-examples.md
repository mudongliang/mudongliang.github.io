---
layout: post
title: "Debian GCC Stack Protector Examples"
date: 2016-05-24
description: ""
category: 
tags: []
---

# Debian GCC Stack Protector Examples

Testing OS : Debian Jessie

### Exmaple1

[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/StackProtector/strong/ssp.c)

```c
#include <stdio.h>
#include <string.h>

int main(int argc,const char *argv[])
{
	char buffer[5];
	strcpy(buffer, "ABCDE");
	printf("%s\n",buffer);
    return 0;
}
```

As shown above, the length of buffer is 5. We can test whether our distribution change `–param=ssp-buffer-size=N` to 4.

- fstack-protector-all		: Y
- fstack-protector-strong	: Y
- fstack-protector			: N

If you change length of buffer to 10, you will see there is stack protector check in the assembly language.

- fstack-protector-all		: Y
- fstack-protector-strong	: Y
- fstack-protector			: Y

Analysis:

```
0x00000000000007d0 <+0>:	push   %rbp
0x00000000000007d1 <+1>:	mov    %rsp,%rbp
0x00000000000007d4 <+4>:	sub    $0x20,%rsp
0x00000000000007d8 <+8>:	mov    %edi,-0x14(%rbp)
0x00000000000007db <+11>:	mov    %rsi,-0x20(%rbp)
0x00000000000007df <+15>:	mov    %fs:0x28,%rax
0x00000000000007e8 <+24>:	mov    %rax,-0x8(%rbp)
0x00000000000007ec <+28>:	xor    %eax,%eax
0x00000000000007ee <+30>:	lea    -0x10(%rbp),%rax
0x00000000000007f2 <+34>:	movl   $0x44434241,(%rax)
0x00000000000007f8 <+40>:	movw   $0x45,0x4(%rax)
0x00000000000007fe <+46>:	lea    -0x10(%rbp),%rax
0x0000000000000802 <+50>:	mov    %rax,%rdi
0x0000000000000805 <+53>:	callq  0x650 <puts@plt>
0x000000000000080a <+58>:	mov    $0x0,%eax
0x000000000000080f <+63>:	mov    -0x8(%rbp),%rdx
0x0000000000000813 <+67>:	xor    %fs:0x28,%rdx
0x000000000000081c <+76>:	je     0x823 <main+83>
0x000000000000081e <+78>:	callq  0x660 <__stack_chk_fail@plt>
0x0000000000000823 <+83>:	leaveq 
0x0000000000000824 <+84>:	retq
```

1.Add stack protector on the stack:

``` 
mov    %fs:0x28,%rax
mov    %rax,-0x8(%rbp)
```

2.Check stack protector on the stack:

```
mov    -0x8(%rbp),%rdx
xor    %fs:0x28,%rdx
```

### Example2
[Source Code on Github](https://github.com/mudongliang/CLanguageReview/blob/master/StackProtector/strong/sspstrong.c)

```c
#include<stdio.h>
#include <stdlib.h>
#include <string.h>

struct no_chars {
	unsigned int len;
	unsigned int data;
};

int main(int argc,const char *argv[])
{
	struct no_chars info = {};

	if (argc < 3) {
		fprintf(stderr, "Usage: %s LENGTH DATA...\n", argv[0]);
		return 1;
	}

	info.len = atoi(argv[1]);
	memcpy(&info.data, argv[2], info.len);

	return 0;
}
```

- fstack-protector-all		: Y
- fstack-protector-strong	: Y
- fstack-protector			: N
