---
layout: post
title: "How to install TeamViewer on Debian 9 Stretch Linux"
date: 2017-06-27
description: ""
category: 
tags: []
---

* TOC
{:toc}

## Objective

The objective is to install desktop sharing application TeamViewer on Debian 9 Stretch Linux.

## Operating System and Software Versions

Operating System: Debian 9 Stretch

Software: TeamViewer v12.0.76279

## Requirements

Privileged access to to your Debian system will be required to install TeamViewer and its prerequisites.

## Difficulty

EASY

## Conventions

```
# - requires given command to be executed with root privileges 
    either directly as a root user or by use of sudo command
$ - given command to be executed as a regular non-privileged user
```

## Instructions

### Prerequisites

TeamViewer is i386 application and from this reason it depends on number i386 libraries. First, enable multi-arch on your Debian system:

```
# dpkg --add-architecture i386
# apt update
```

Next, install prerequisites and tools to help with the actual installation:

```
# apt install libjpeg62-turbo:i386 wget gdebi-core
```

### Download and install TeamViewer

At this stage we are ready to download TeamViewer:

```
$ wget https://download.teamviewer.com/download/teamviewer_i386.deb
$ ls
teamviewer_i386.deb
```
The TeamViewer package should be now located withing your working directory and ready to be installed. Use gdebi to install TeamViewer package:

```
# gdebi teamviewer_i386.deb
Remote control and meeting solution.
 TeamViewer provides easy, fast and secure remote access and meeting solutions
 to Linux, Windows PCs, Apple PCs and various other platforms,
 including Android and iPhone.
 .
 TeamViewer is free for personal use.
 You can use TeamViewer completely free of charge to access your private
 computers or to help your friends with their computer problems.
 .
 To buy a license for commercial use, please visit http://www.teamviewer.com
 .
 This package contains Free Software components.
 For details, see /opt/teamviewer/doc/license_foss.txt
Do you want to install the software package? [y/N]:y
```
```
# apt-get install -f
```

### Launch TeamViewer

TeamViewer is now ready to be started from your desktop navigation menu or from command line. Please note, the first launch of the TeamViewer may take some time. The reason for this is that TeamViewer is wine dependent application and it will be setting up an environment on its first launch. So be patient:

```
$ teamviewer
Init...
CheckCPU: SSE2 support: yes
XRandRWait: No value set. Using default.
XRandRWait: Started by user.
Checking setup...
wine: configuration in '/home/linuxconfig/.local/share/teamviewer12' has been updated.
Launching TeamViewer ...
Launching TeamViewer GUI ...
```

Shared from [how-to-install-teamviewer-on-debian-9-stretch-linux](https://linuxconfig.org/how-to-install-teamviewer-on-debian-9-stretch-linux)
