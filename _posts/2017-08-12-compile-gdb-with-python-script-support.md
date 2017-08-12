---
layout: post
title: "Compile gdb with python script support"
date: 2017-08-12
description: ""
category: 
tags: []
---

* TOC
{:toc}

## Download gdb package

```
wget https://ftp.gnu.org/gnu/gdb/gdb-8.0.tar.gz
```

## Compile gdb with python support

```
tar -xvf gdb-8.0.tar.gz
cd gdb-8.0
./configure --with-python
make
sudo make install
```

## Test a simple python script

```
try:
    import gdb
except ImportError as e:
    raise ImportError("This script must be run in GDB: ", str(e))

print(gdb.PYTHONDIR)
```
