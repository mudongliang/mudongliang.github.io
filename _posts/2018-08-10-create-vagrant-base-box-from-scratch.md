---
layout: post
title: "Create Vagrant Base Box from Scratch"
date: 2018-08-10
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Objective

The objective is to create vagrant base boxes from Scratch

## Operating System and Software Version

- **Operating System**: Ubuntu 18.04 LTS
- **Software**: Vagrant 2.0.3 and VirtualBox 5.2.10

## Install Vagrant and VirtualBox

For vagrant, download Deb packege from [Vagrant For Linux](https://www.vagrantup.com/downloads.html)

For virtualbox, download Deb packege from [VirtualBox for Linux](https://www.virtualbox.org/wiki/Linux_Downloads)

## Create Vagrant Boxes from Scratch

### Install Linux in the VirtualBox

Follow the instructions in the [PDF File](https://raw.githubusercontent.com/mudongliang/mudongliang.github.io/master/files/VirtualBox_Ubuntu_16.04LTS_Installation.pdf) to install Ubuntu 16.04 LTS in the VirtualBox. Note that the user and password should be **vagrant**

### Configure Linux

- Add the vagrant user to sudoers file

Append one line in the `/etc/sudoers`

```
vagrant ALL=(ALL) NOPASSWD:ALL
```

- Install Vagrant Public Keys

```
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate \
    https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
```

- Update Linux System

```
sudo apt update
sudo apt upgrade -y
```

- Install OpenSSH Server

```
sudo apt install openssh
```

- Install the "Guest Additions"

- Clean up (useless packages, package cache, and so on)

```
sudo apt remove XXX
sudo apt clean
```

- "Zero out" the drive

```
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
```

### Package new box

```
$ vagrant package --base trusty64_default_1529872704422_34658
```

Then you will see one file - package.box in the working directory.

Note, you can use following instruction to obtain the name of a VM in VirtualBox.

```
$ VBoxManage list vms
"bionic64_default_1527182703834_99771" {daba6cbc-6031-4526-975f-3d5d952d6e89}
"trusty64_default_1529872704422_34658" {f7d11d1b-d88e-4241-a36e-78d434e0fa51}
```

## References

[1] <https://www.sitepoint.com/create-share-vagrant-base-box/>

[2] <https://www.skoblenick.com/vagrant/creating-a-custom-box-from-scratch/>

[3] <https://www.engineyard.com/blog/building-a-vagrant-box-from-start-to-finish>

[4] <http://aruizca.com/steps-to-create-a-vagrant-base-box-with-ubuntu-14-04-desktop-gui-and-virtualbox/>

[5] <https://github.com/ckan/ckan/wiki/How-to-Create-a-CentOS-Vagrant-Base-Box>
