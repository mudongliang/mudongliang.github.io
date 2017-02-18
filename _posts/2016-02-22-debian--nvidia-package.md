---
layout: post
title: "Debian 安装 NVIDIA 显卡驱动(台式机)"
date: 2016-02-22
description: ""
category: 
tags: []
---

我的台式机有两个显卡:

```
1. Intel 集成显卡
2. NVIDIA 独立显卡
```

1.检测 `NVIDIA` 显卡

`nvidia-detect` 脚本 (`nvidia-detect` 包在 `non-free` 源中) 用来确定 GPU 的类型和对应所需的驱动：

```sh
# apt-get install nvidia-detect
# nvidia-detect
Detected NVIDIA GPUs:
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107 [GeForce GTX 650] [10de:0fc6] (rev a1)
Your card is supported by the default drivers and legacy driver series 304.
It is recommended to install the
   nvidia-driver
package.
```

2.安装闭源 `NVIDIA` 驱动

```sh
# apt-get install nvidia-driver
```

3.配置闭源 `NVIDIA` 驱动 以及屏蔽开源驱动 `Nouveau`

```sh
# apt-get install nvidia-xconfig
```

在安装完成之后，执行 `nvidia-xconfig` 命令来生成新的 `/etc/X11/xorg.conf` 配置文件：

```sh
# nvidia-xconfig
New X configuration file written to '/etc/X11/xorg.conf
```

4.重启以及将默认显示模式改为 "PCIE for NVIDIA" 而不是 "iGPU for Intel"

参考:

1.[nvidia geforce driver on debian](https://linuxconfig.org/nvidia-geforce-driver-installation-on-debian-jessie-linux-8-64bit)
