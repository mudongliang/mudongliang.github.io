---
layout: post
title: "Use Port Forwarding in VirtualBox"
date: 2021-12-27
description: ""
category: 
tags: []
---
* TOC
{:toc}


First, open VirtualBox and select the Virtual Machine you want to add port forwarding;

Then, click `Settings` and select on the Network tab;

In the Network window expand the `Advanced` section and click `Port Forwarding`;

In the `Port Forwarding Rules` window, click the `+` button and fill out the new rule as such:

```
Name - SSH
Protocol - TCP
Host IP - leave blank
Host Port - 2222
Guest IP - leave blank
Guest Port - 22
```

Once you've filled that out, click `OK` to save this rule.

```
ssh -p2222 USERNAME@127.0.0.1
```

In Vagrant, it uses port forwarding in VirtualBox to implement its `ssh` command.


## References

[1] <https://www.techrepublic.com/article/how-to-use-port-forwarding-in-virtualbox/>
