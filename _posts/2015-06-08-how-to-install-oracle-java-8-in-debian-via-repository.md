---
layout: post
title: "How To Install Oracle Java 8 In Debian Via Repository"
date: 2015-06-08
description: ""
category: 
tags: []
---

From [http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html](http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html)

Usually, the packages available in Launchpad PPAs don't support Debian because they are built against specific Ubuntu libraries, but since the WebUpd8 Oracle Java PPA contains just an installer, it works on Debian too.

Using this PPA repository, you'll be able to install Oracle Java 8 (which includes both JRE8 and JDK8) in Debian for both 32bit and 64bit as well as ARM (ARM v6/v7 Hard Float ABI - there's no JDK 8 ARM Soft Float ABI archive available for download on Oracle's website).

The installer automatically downloads and installs Oracle JDK8, but no actual Java files are available in our repository (that's not allowed by the Oracle Java license).

For Ubuntu / Linux Mint installation instructions, see: [Install Oracle Java 8 In Ubuntu Or Linux Mint Via PPA Repository](http://mudongliang.github.io/2015/07/05/install-oracle-java-8-in-ubuntu-or-linux-mint-via-ppa-repository.html)

To add the WebUpd8 Oracle Java PPA repository and install Oracle Java 8 in Debian, use the following commands:

    su - 
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
    apt-get update 
    apt-get install oracle-java8-installer

And that's it, Oracle Java 8 should now be installed and you should get automatic updates for future Oracle Java 8 versions, under Debian.

You can check out the Java version on your system by using these commands:

    java -version

This should display something like this:

    java version "1.8.0_31" Java(TM) SE Runtime Environment (build 1.8.0_31-b13)
    Java HotSpot(TM) 64-Bit Server VM (build 25.31-b07, mixed mode)

其实，在Debian上用过ppa和解决过“Not Found”问题的人应该都明白这个安装的实质是什么！

首先，我们说一下，Debian安装ppa的时候需要解决的问题：

1.  [找不到add-apt-repository的问题](http://mudongliang.github.io/2015/06/14/debian-add-apt-repository-command-not-found.html)

2. [“Not Found”问题](http://mudongliang.github.io/2015/06/15/debianubuntulinuxmint-install-sublime-text-2-via-ppa.html)

Debian安装ppa的最终结果就是安装deb软件包和list文件！

**为了不需要解决上述问题，我们要做的就是直接写入最后生成的list文件，然后apt-get update,最后安装相应的软件.**
