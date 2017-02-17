---
layout: post
title: "Upgrade LinuxMint via terminal"
date: 2015-07-01
description: ""
category: 
tags: []
---

1) Backup the repository file

Use the command below to back up your repository file

```sh
# sudo cp /etc/apt/sources.list.d/official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list.bak
```

2) Modify the repository file

LinuxMint 17 & 17.1 & 17.2 is based on Ubuntu 14.04. So just use the command below to replace `qiana` with `rebecca`

```sh
# sudo sed -i 's/qiana/rebecca/g' /etc/apt/sources.list.d/official-package-repositories.list
```

Or

```sh
# sudo sed -i 's/rebecca/rafaela/g' /etc/apt/sources.list.d/official-package-repositories.list
```

3) Run upgrade LinuxMint 17 to 17.1 Or 17.1 to 17.2

Now, its time to upgrade your Operating system from LinxuMint 17 (Qiana) to LinuxMint 17.1 (Rebecca). This upgrade will take 20-25 mins based on your internet connection and software which you install.

```
# sudo apt-get update
# sudo apt-get dist-upgrade
# sudo apt-get upgrade
```

**The sequence cannot be changed!**

4) Check the version of your Desktop

Reboot your system and see the upgraded version. Use the command below to check the current version of your desktop.

```
$ cat /etc/lsb-release
DISTRIB_ID=LinuxMint
DISTRIB_RELEASE=17.2
DISTRIB_CODENAME=rafaela
DISTRIB_DESCRIPTION="Linux Mint 17.2 Rafaela"
```
