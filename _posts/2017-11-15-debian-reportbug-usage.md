---
layout: post
title: "Debian Reportbug Usage"
date: 2017-11-15
description: ""
category:
tags: []
---
* TOC
{:toc}


## Introduction
**reportbug** is a tool designed to make the reporting of bugs in Debian and derived distributions relatively painless. Its features include:

 - Access to outstanding bug reports to make it easier to identify whether problems have already been reported.
 - Automatic checking for newer versions of packages.
Optional automatic verification of integrity of packages via debsums.
 - Support for following-up on outstanding reports.
 - Integration with the mutt, af, and mh/nmh e-mail readers.
 - Optional PGP/GnuPG integration.

This package provides access to the Debian Bug Tracking System, which can be used for both reporting and researching bugs, by a number of interfaces, including email, web, and command-line utilities.

 - To report a bug: 'reportbug packagename'
 - To view bugs for a package: 'querybts packagename'

## Installation

    sudo apt-get install python-vte reportbug



Now I try to take a sample case borrowed from Reference 2 to illustrate how to use `reportbug`.

## Configure reportbug

![reportbug]({{site.url}}/images/reportbug/Reportbug_708.png)

![reportbug]({{site.url}}/images/reportbug/Reportbug_709.png)

![reportbug]({{site.url}}/images/reportbug/Reportbug_711.png)

![reportbug]({{site.url}}/images/reportbug/Reportbug_712.png)

![reportbug]({{site.url}}/images/reportbug/Selection_713.png)

Add your name.

![reportbug]({{site.url}}/images/reportbug/Selection_714.png)

Add your email.

![reportbug]({{site.url}}/images/reportbug/Reportbug_716.png)

Just skip SMTP host if you do not have. And the default SMTP server will be provided by Debian.

![reportbug]({{site.url}}/images/reportbug/Reportbug_718.png)

![reportbug]({{site.url}}/images/reportbug/Reportbug_719.png)

Just skip proxy server if you do not have.

![reportbug]({{site.url}}/images/reportbug/Reportbug_720.png)

After finishing configuration of reportbug, directly open reportbug to report bug to Debian Bug Tracking System.

## Report bug with reportbug

![reportbug]({{site.url}}/images/reportbug/Reportbug_721.png)

At first, please enter the name of debian package;

![reportbug]({{site.url}}/images/reportbug/Reportbug_722.png)

reportbug will check whether the package on our system is the newest version and ask you whether you really want to report this bug.

![reportbug]({{site.url}}/images/reportbug/Reportbug_723.png)

Please check whether there exists a similar report bug.

![reportbug]({{site.url}}/images/reportbug/Reportbug_725.png)

The bug here is "typecatcher cannot startup normally". It should be **important**.

![reportbug]({{site.url}}/images/reportbug/Reportbug_726.png)

If you cannot find any description that could apply to your bug, please continue.

![reportbug]({{site.url}}/images/reportbug/Reportbug_727.png)

Then describe your bug in the textbox following the tips.

![reportbug]({{site.url}}/images/reportbug/Reportbug_728.png)

Submit the bug report via email.

![reportbug]({{site.url}}/images/reportbug/Reportbug_730.png)

Finally, you could search your bug id from Debian Bug Tracking System.

## References

[1] [Reportbug](https://packages.debian.org/reportbug)

[2] [使用Reportbug工具向Debian软件包维护人员提交bug报告](https://www.linuxdashen.com/report-software-bugs-in-debian-using-reportbug)
