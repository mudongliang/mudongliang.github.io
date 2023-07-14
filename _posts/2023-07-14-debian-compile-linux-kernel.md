---
layout: post
title: "Debian compile Linux Kernel from Source Code"
date: 2023-07-14
description: ""
category: 
tags: []
---
* TOC
{:toc}

### 安装依赖软件

```
sudo apt install build-essential libncurses5-dev libssl-dev flex bison libelf-dev bc
```

### 下载源代码

```
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.38.tar.xz
```

### 解压压缩包

```
tar -xvf linux-6.1.38.tar.xz
```

### 配置

```
make allyesconfig
```

### 编译Linux内核

```
make -j40
```
