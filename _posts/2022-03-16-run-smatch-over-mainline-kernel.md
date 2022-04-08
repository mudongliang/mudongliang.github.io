---
layout: post
title: "Quick guidance of running smatch over mainline kernel"
date: 2022-03-16
description: ""
category: 
tags: []
---
* TOC
{:toc}


## Dependency

```
sudo apt-get install gcc make sqlite3 libsqlite3-dev libdbd-sqlite3-perl libssl-dev libtry-tiny-perl
```

## Smatch

Download and compile Smatch
```
mkdir -p ~/Repos
cd ~/Repos
git clone git://repo.or.cz/smatch.git
cd smatch
make
```

```
cd ~/Repos
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
cd linux
# copy one kernel config file
~/Repos/smatch/smatch_scripts/build_kernel_data.sh
~/Repos/smatch/smatch_scripts/test_kernel.sh
```

Run smatch over just one kernel file or directory
```
~/Repos/smatch/smatch_scripts/kchecker drivers/whatever/file.c
~/Repos/smatch/smatch_scripts/kchecker drivers/whatever/

```

## References

[1] <https://repo.or.cz/smatch.git/blob/HEAD:/Documentation/smatch.txt>

