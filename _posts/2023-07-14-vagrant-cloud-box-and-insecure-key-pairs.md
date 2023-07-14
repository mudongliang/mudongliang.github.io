---
layout: post
title: "Vagrant cloud, box and insecure key pairs"
date: 2023-07-14
description: ""
category: 
tags: []
---
* TOC
{:toc}

### Problems

Vagrant leverages a **insecure** public/private keypair to create base boxes so that vagrant installations can automatically SSH into the boxes.

By default, `vagrant up` generates a new public/private keypair locally and inserts this public keypair into the virtual machine.

The private key is stored in the file - `.vagrant/machines/default/virtualbox/private_key`.

### Naive Solution 

You can insert a newline `config.ssh.insert_key = false` after `config.vm.box`, e.g.,

```
Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.ssh.insert_key = false
end
```

[1] [Insecure Keypair](https://github.com/hashicorp/vagrant/tree/master/keys)
