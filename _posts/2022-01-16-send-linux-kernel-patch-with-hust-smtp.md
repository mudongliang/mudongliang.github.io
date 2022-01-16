---
layout: post
title: Draft for "Send linux kernel patch with HUST SMTP"
date: 2022-01-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Send Linux kernel with HUST SMTP

Recently I would like to change my email account to send kernel patch from Gmail to HUST Mail. After checking the specification of HUST Mail for faculty[1], I did the following configuration to my git-sendmail.

### Prerequisites

```
sudo apt install git git-core git-sendmail
```

### Set up HUST SMTP

Same as [2], edit the .gitconfig in the home directory to add the following sendmail configuration.

```
[sendemail]
	from = Dongliang Mu <dzm91@hust.edu.cn>
        smtpencryption = tls
        smtpuser = dzm91@hust.edu.cn
        smtpserver = mail.hust.edu.cn
```

### Send Linux kernel patch with HUST SMTP

Use `git format-patch` to generate one kernel patch, and 

```
# PWD should be a kernel git repository
git format-patch -1
git send-patch --to=mudongliangabcd@gmail.com 0001-*.patch
```

## References

[1] [教工服务-电子邮箱](http://ncs.hust.edu.cn/jgfw/dzyx.htm)    
[2] [Setting up git send-email with gmail to send Linux kernel patch](https://mudongliang.github.io/2018/03/20/setting-up-git-send-email-with-gmail-to-send-linux-kernel-patch.html)
