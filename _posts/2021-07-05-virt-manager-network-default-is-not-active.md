---
layout: post
title: "virt manager network default is not active"
date: 2021-07-05
description: ""
category: 
tags: []
---
* TOC
{:toc}

First, confirm that the default network is indeed inactive:

```
sudo virsh net-list --all
```

If yes, just start the default network:

```
sudo virsh net-start default 
```

Run the first command again to see if it worked.

If the default network is not autostarted, just enable this:

```
sudo virsh net-autostart default
```

## References

[1] [Can't start KVM guest: “network 'default' is not active”](https://askubuntu.com/questions/1036297/cant-start-kvm-guest-network-default-is-not-active)

[2] [How to fix "network 'default' is not active" error in libvirt](https://www.xmodulo.com/network-default-is-not-active.html)
