---
layout: post
title: "ruid, euid, suid usage in Linux"
date: 2020-09-17
description: ""
category: 
tags: []
---
* TOC
{:toc}

## ruid, euid, suid usage in Linux

- RUID(Real User ID)
    - The actual owner of a process
    - It is used in signal transmission. A unprivileged process can signal to the another process when the RUID, EUID is the same as RUID, SUID of the another process

- EUID(Effective User ID)
    - Generally, UID and EUID is the same
    - **EUID is changed by executable file that is configured SetUID authority**
    - EUID temporarily stores another account's UID
    - The authority of a process is determined according to the UID stored in the EUID

- SUID(Saved set-user-ID)
    - SUID is used when a process's authority is recovered after lowered
    - When process's authority is changed to lower. previous EUID is stored at SUID
    - Then, when the lowered authority is recovered to original authority, the SUID is stored at EUID

Note that, the setuid bit has no effect on scripts in Linux-based systems like Ubuntu. 

## Experiments

First, let's create one C file named `test.c`, as below:

```C
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
int main()
{
  uid_t ruid, euid, suid; 
  getresuid(&ruid, &euid, &suid);
  printf("EUID: %d, RUID: %d, SUID: %d\n", ruid, euid, suid);
  setreuid(geteuid(), geteuid());
  getresuid(&ruid, &euid, &suid);
  printf("EUID: %d, RUID: %d, SUID: %d\n\n", ruid, euid, suid);
  system("cat file-read-only-by-root"); // file-read-only-by-root: -r-------- root root
  return 0;
}
```

```
gcc -o test test.c
sudo chown root:ubuntu test # Here ubuntu is the normal user
```

Without setting setuid bit, the result of executing `test` is as below:

```
$ ./test
EUID: 1000, RUID: 1000, SUID: 1000
EUID: 1000, RUID: 1000, SUID: 1000

cat: file-read-only-by-root: Permission denied
```

Then we setuid for test file and execute it again,

```
sudo chmod u+s test
$ ./test
EUID: 1000, RUID: 0, SUID: 0
EUID: 0, RUID: 0, SUID: 0

```

## References

[1] <https://cysecguide.blogspot.com/2016/10/difference-among-ruid-euid-suid.html>
