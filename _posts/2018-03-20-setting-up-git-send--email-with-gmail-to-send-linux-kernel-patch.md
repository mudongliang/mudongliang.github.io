---
layout: post
title: "Setting up git send-email with gmail to send Linux kernel patch"
date: 2019-03-20
description: ""
category: 
tags: []
---
* TOC
{:toc}

This post sets up gmail as smtp server.

## Prerequisites

```
sudo apt install git git-core git-sendmail
```

## Configuration

What we should do is to add the following configuration to ~/.gitconfig.

```
[sendemail]
	from = YourName <username@gmail.com>
	smtpserver = smtp.gmail.com
	smtpuser = username@gmail.com
	smtpencryption = tls
	smtppass = PASSWORD
	chainreplyto = false
	smtpserverport = 587
```

Note that, please modify the configuration according to your personal profile. For me, it is :

```
[sendemail]
	from = Dongliang Mu <mudongliangabcd@gmail.com>
        smtpencryption = tls
        smtpuser = mudongliangabcd@gmail.com
        smtpserver = smtp.gmail.com
        smtpserverport = 587
	chainreplyto = false
```

You can find that `smtppass` is missing here. Due to security concern, I intentionally remove this configuration. But if for convenience or being confident with your environment, you could set the smtppass as plaintext.

Then you could follow [my other post]({{site.url}}/2018/03/20/one-simple-patch-to-linux-kernel.html) to send kernel patch.
