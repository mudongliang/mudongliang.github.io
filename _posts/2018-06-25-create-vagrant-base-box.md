---
layout: post
title: "Create Vagrant Base Box Based on Existing One"
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
```

### Klee Installation and configuration

You can follow [Building KLEE (LLVM 3.4)](http://klee.github.io/build-llvm34/) to install and configure KLEE.

### Create new base image

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

## Sharing the base box
 
One easy method to share the base box is **to Upload the base box to Vagrant Cloud**.

### Sign in

At first, you need to create one account and sign in with your new account.

### Create new image

![create]({{site.url}}/images/vagrant_cloud_newimage.png)

### Create new version

![new_version]({{site.url}}/images/vagrant_cloud_newversion.png)

Then you will see the new vagrant box like this,

![status]({{site.url}}/images/vagrant_cloud_status.png)

### Select provider and Upload box file

![status]({{site.url}}/images/vagrant_cloud_provider.png)

Here I use vritualbox. So I fill the provider as "virtualbox".

![status]({{site.url}}/images/vagrant_cloud_upload.png)

Then upload the box file to Vagrant Cloud.

## References

[1] <https://www.sitepoint.com/create-share-vagrant-base-box/>

[2] <https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one>

[3] <https://abhishek-tiwari.com/creating-a-new-vagrant-base-box-from-an-existing-vm/>
