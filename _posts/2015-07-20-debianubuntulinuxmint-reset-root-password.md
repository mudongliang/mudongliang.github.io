---
layout: post
title: "Debian/Ubuntu/LinuxMint reset root password"
date: 2015-07-20
description: ""
category: 
tags: []
---

## 方法1：

第一步，启动进去boot menu。如没有出现boot menu，请参见[LinuxMint17 设置grub启动时间](http://mudongliang.github.io/2015/06/07/linuxmint-17-set-grub-boot-time.html)

![grub]({{site.url}}/images/grub1.png)

第二步，按照下面提示，按下“e”来编辑启动命令

![grub]({{site.url}}/images/grub2.png)

第三步，向下到 kernel 的配置那行, 类似于 `linux /boot/vmlinuz-... root=... quiet ...`。走到改行末尾，添加` init=/bin/bash `(注意空格)

![grub]({{site.url}}/images/grub3.png)

第四步，按“Ctrl+x”或“F10”启动。

![grub]({{site.url}}/images/grub4.png)

第五步，从上图中可以看出，根分区是按照只读模式挂载的，所以先要按读写方式重新挂载根分区，然后利用passwd来修改root密码。

    # Remount / as Read/Write 
    mount -rw -o remount /
    # Change password with
    passwd 
    # type new password, confirm and hit enter and then reboot.

唯一有点问题的是，就是进入这个启动模式之后，无法按照正常命令关机，只能强关。

![grub]({{site.url}}/images/grub5.png)

## 方法2：

前提：你有一个LinuxMint，Debian或者其他linux系统的liveCD。

第一步，利用这个liveCD启动，进入系统。
第二步，将原系统的根分区，挂载在/mnt（其他地方也可以）。
第三步，修改/mnt/etc/shadow文件，这个文件存储每一个用户密码加密的信息。
找到root所在的行，然后将第一个":"和第二个“:”之间的内容清空，即将密码加密项清空。
第四步，重新登录原系统，切换root无需密码，然后利用passwd重置密码
补充：

`/etc/shadow` 文件简单解释：

    name:...:16523:0:99999:7:::

每一行给一个特殊帐户定义密码信息，每个字段用 : 隔开。

- 字段 1 定义与这个 shadow 条目相关联的特殊用户帐户。
- 字段 2 包含一个加密的密码。
- 字段 3 自 1/1/1970 起，密码被修改的天数
- 字段 4 密码将被允许修改之前的天数（0 表示“可在任何时间修改”）
- 字段 5 系统将强制用户修改为新密码之前的天数（1 表示“永远都不能修改”）
- 字段 6 密码过期之前，用户将被警告过期的天数（-1 表示“没有警告”）
- 字段 7 密码过期之后，系统自动禁用帐户的天数（-1 表示“永远不会禁用”）
- 字段 8 该帐户被禁用的天数（-1 表示“该帐户被启用”）
- 字段 9 保留供将来使用
