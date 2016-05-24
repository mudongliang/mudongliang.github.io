---
layout: post
title: "Check Selinux status and close Selinux"
date: 2015-05-30
description: ""
category: 
tags: []
---

查看Selinux状态和关闭Selinux

Debian默认没有安装Selinux；Redhat，CentOS，Fedora都默认安装Selinux。

### 查看SELinux状态：

1. /usr/sbin/sestatus -v      ##如果SELinux status参数为enabled即为开启状态
SELinux status:                 enabled

2. getenforce                 ##也可以用这个命令检查

### 关闭SELinux：

1. 临时关闭（不用重启机器）：

```sh
setenforce 0                  ##设置SELinux 成为permissive模式
##setenforce 1 设置SELinux 成为enforcing模式
```

2. 修改配置文件需要重启机器：
修改/etc/selinux/config 文件
将SELINUX=enforcing改为SELINUX=disabled
重启机器即可
