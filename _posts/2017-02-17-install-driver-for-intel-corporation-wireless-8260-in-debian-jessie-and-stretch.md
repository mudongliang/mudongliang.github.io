---
layout: post
title: "Install Driver for Intel Corporation Wireless 8260 in Debian Jessie and Stretch"
date: 2017-02-17
description: ""
category: 
tags: []
---

First, read [wiki about iwlwifi](https://wiki.debian.org/iwlwifi).

For `Debian 8 Jessie`,

1.Add "non-free" component to `/etc/apt/sources.list`, for example:

```
# Debian 8 "Jessie"
deb http://httpredir.debian.org/debian/ jessie main contrib non-free
```

2.Update the list of available packages and install the [firmware-iwlwifi](https://packages.debian.org/jessie/firmware-iwlwifi) package:

```
# apt-get update && apt-get install firmware-iwlwifi
```

3.As the iwlwifi module is automatically loaded for supported devices, reinsert this module to access installed firmware:

```
# modprobe -r iwlwifi ; modprobe iwlwifi
```

For `Debian 9 Stretch`, there is only one difference.

You need change "jessie" to "stretch".

But if your host OS is Debian Stable, you may find it is still no working, please refer to [email](https://lists.debian.org/debian-kernel/2017/02/msg00193.html).

Because `linux-image` and `firmware-iwlwifi` in Debian 8 Jessie do not support Intel Corporation Wireless 8260, you need to upgrade to Debian Stretch. [Debian Stretch is frozen](https://lists.debian.org/debian-devel-announce/2017/02/msg00001.html), it is not a long time until it becomes stable.

However, if you don't want to upgrade to Stretch due to stable or other concern, two methods are provided:

1.add `jessie-backports` software source to your `/etc/apt/source.list` 

```sh
# Debian 8 "Jessie"
deb http://httpredir.debian.org/debian/ jessie-backports main contrib non-free
```

2.install `linux-image` and `firmware-iwlwifi` from jessie-backports software source.

```sh
sudo apt install -t jessie-backports linux-image-amd64 firmware-iwlwifi
```

You can get similiar instructions from [debian-backports](https://backports.debian.org/Instructions/).
