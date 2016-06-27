---
layout: post
title: "Install Oracle Java 8 In Ubuntu Or Linux Mint Via PPA Repository"
date: 2015-07-05
description: ""
category: 
tags: []
---

From [http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html](http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)

The installer provides Oracle Java 8 (which includes Java JDK, JRE and the Java browser plugin). However, you can't only install Oracle JRE - the PPA only provides the full Oracle JDK8 package.
Our PPA supports Ubuntu 15.04, 14.10, 14.04 and 12.04 as well as Linux Mint 17.1, 17 and 13. Add the PPA and install Oracle Java 8 (the package provides both JDK8 and JRE8) using the following commands:

    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer

Tip: if you're behind a firewall / router that blocks some of the redirects required to download the Oracle Java archive, you can download the JDK tar.gz archive manually and place it under /var/cache/oracle-jdk8-installer - then, installing the `oracle-java8-installer` package will use the local archive instead of trying it to download it itself.

Once installed, running `java -version` in a terminal should output something like this:

    $ java -version 
    java version "1.8.0_31" Java(TM) SE Runtime Environment 
    (build 1.8.0_31-b13)  Java HotSpot(TM) 64-Bit Server VM 
    (build 25.31-b07, mixed mode)
