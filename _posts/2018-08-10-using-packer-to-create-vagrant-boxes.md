---
layout: post
title: "Using Packer to Create Vagrant Boxes"
date: 2018-08-10
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Objective

The objective is to create vagrant base boxes with Packer

## Operating System and Software Version

- **Operating System**: Ubuntu 18.04 LTS
- **Software**: Packer 1.2.5(Binary) or Packer 1.0.4(Ubuntu Repository)

## Install Packer

### Binary downloaded from official website

Download installer from [Packer Releases](https://releases.hashicorp.com/packer/), and unzip the installer in the local workspace. For convenience, I add it in the PATH environment.

### Ubuntu Repository

```
sudo apt install packer
```

## Create Vagrant Boxes with Packer

Packer allows you to create a personal Vagrant base box easily. This means that you don’t need to rely anymore on some random ready-made boxes from the Internet. With Packer, you know what is being installed into your base box and hence the box can be more trustworthy. While Packer supports Vagrant, it can also be used to prepare a system for VirtualBox, VMware and so on.

Packer works with [a template file](https://www.packer.io/docs/templates/index.html). I create several configuration files for Packer and upload them to [Github Repo](https://github.com/VulnReproduction/vagrant-images).

You could find detailed semantic of configuration file for virtualbox provider in [Packer Documentation](https://www.packer.io/docs/builders/virtualbox-iso.html).

And the instruction for Packer to build Vagrant Box is :

```
packer build XXXX.json
```

## References

[1] <https://ariya.io/2013/11/using-packer-to-create-vagrant-boxes>

[2] <https://dzone.com/articles/using-packer-create-vagrant>

[3] <https://blog.codeship.com/packer-vagrant-tutorial/>
