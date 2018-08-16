---
layout: post
title: "Installing TeX Live over the Internet on CentOS7"
date: 2018-08-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Objective

The objective is to install texlive over the Internet.

## Operating System and Software Versions

- **Operating System**: CentOS7.3

## Requirements

Privileged access to your CentOS system is required to install Texlive into some privileged directories.

## Install Texlive through install-tl Script

First, download the [install-tl-unx.tar.gz] from [Download Page](https://www.tug.org/texlive/acquire-netinstall.html);

Second, uncompress the package, and use root priviledge to install texlive into default destination directory - `/usr/local/bin`.

```
tar -xvf install-tl-unx.tar.gz
cd install-tl-20180816
sudo ./install-tl
I <- to install the texlive into target direcotry
```

## References

[1] <https://www.systutorials.com/241660/how-to-install-tex-live-on-centos-7-linux/>

[2] <https://www.tug.org/texlive/quickinstall.html>
 
[3] <https://www.tug.org/texlive/acquire-netinstall.html>
