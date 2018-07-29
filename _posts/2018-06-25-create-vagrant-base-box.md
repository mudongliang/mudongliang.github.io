---
layout: post
title: "Create Vagrant Base Box"
date: 2018-06-25
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Download one base image

```
vagrant box add ubuntu/trusty64
mkdir klee
vagrant init ubuntu/trusty64
```

## Boot and Modify the machine

```
vagrant up
vagrant ssh
# do your own modifications
```

### Add public key

```

```

### Install VirtualBox Guest Additions

```
```

### Create new base image

```
$ VBoxManage list vms
"bionic64_default_1527182703834_99771" {daba6cbc-6031-4526-975f-3d5d952d6e89}
"trusty64_default_1529872704422_34658" {f7d11d1b-d88e-4241-a36e-78d434e0fa51}

$ vagrant package --base trusty64_default_1529872704422_34658
```

Then you will see one file - package.box in the working directory.

## Upload to Vagrant Cloud


### Sign in

### Create new image

Screenshot

### Create new version

Screenshot

### Upload box file

Fill in the provider and upload the box file to Vagrant Cloud.

## References

[1] <https://www.sitepoint.com/create-share-vagrant-base-box/>
