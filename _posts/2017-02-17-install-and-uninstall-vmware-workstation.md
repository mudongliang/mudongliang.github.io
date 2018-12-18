---
layout: post
title: "Install and uninstall vmware workstation"
date: 2017-02-17
description: ""
category: 
tags: [vmware, install, uninstall]
---

* TOC
{:toc}

## Install Prerequisite Packages

```
sudo apt install build-essential linux-headers-$(uname -r)
```

## Download Vmware Workstation

Download Vmware Workstation Installation Script from [Vmware Workstation Pro](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)

The newest version of vmware workstation is 12.5.2. And the corresponding script name is `VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle`.

## Install VMware Workstation

First, change the permission of this installation script,

```sh
$ chmod +x VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle
```

Second, execute this installtion script, (this operation needs root privilege)

```sh
$ sudo ./VMware-Workstation-Full-12.5.2-4638234.x86_64.bundle
```

At last, follow the Graphics Installation Menu, and choose "Yes/No".

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
