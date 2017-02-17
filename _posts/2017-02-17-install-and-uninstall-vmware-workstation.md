---
layout: post
title: "Install and uninstall vmware workstation"
date: 2017-02-17
description: ""
category: 
tags: [vmware, install, uninstall]
---

## Install VMware Workstation

Download Installation Script from (VMware Website)[https://my.vmware.com/web/vmware/info/slug/desktop_end_user_computing/vmware_workstation_pro/12_0]. The newest version of vmware workstation is 12.5.2. And the corresponding script name is `VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle`.

Change the permission of this installation script,

```sh
$ chmod +x VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle
```
Execute this installtion script, (this operation needs root privilege)

```sh
$ sudo ./VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle
```

Follow the Graphics Installation Menu, and choose "Yes/No".


## Uninstall VMware Workstation

First, check which production you have installed. Of course, it is 

```sh
$ vmware-installer --list-products

Product Name         Product Version     
==================== ====================
vmware-workstation   12.5.2.4638234      
```

Second, uninstall vmware-workstation

```sh
sudo vmware-installer -u vmware-workstation
```
