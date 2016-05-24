---
layout: post
title: "/dev/null vs /dev/zero"
date: 2015-05-19
description: ""
category: 
tags: []
---

# /dev/null and /dev/zero

### NAME
null, zero - data sink

### DESCRIPTION
Data written to a null or zero special file is discarded.

Reads from the null special file always return end of file (i.e., read(2) returns 0), whereas reads from zero always return bytes containing zero (\0 characters).

null and zero are typically created by:

```sh
mknod -m 666 /dev/null c 1 3
mknod -m 666 /dev/zero c 1 5
chown root:root /dev/null /dev/zero
```

### FILES

```
/dev/null
/dev/zero
```

### NOTES
If these devices are not writable and readable for all users, many programs will act strangely.

### SEE ALSO
chown(1), mknod(1), full(4)

### COLOPHON
This  page  is  part  of  release  3.74  of  the  Linux  man-pages  project.   A  description  of  the project, information about reporting bugs, and the latest version of this page, can be found at

http://www.kernel.org/doc/man-pages/.
