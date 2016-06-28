---
layout: post
title: "linux install java jdk1.7.0_45"
date: 2016-06-27
description: ""
category: 
tags: []
---

We can download java jdk package with the following commands

    # RPM
    wget --no-check-certificate \
         --no-cookies \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm \
         -O jdk-7u45-linux-x64.rpm
    
    # TAR GZ
    wget --no-check-certificate \
         --no-cookies \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.tar.gz \
         -O jdk-7u45-linux-x64.tar.gz

Those code snippets are from [Gist Github](https://gist.github.com/ashrithr/5874684640d04b293bd9).

    update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_45/bin/java 1
    update-alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_45/bin/javac 1
    update-alternatives --set java /opt/jdk1.7.0_45/bin/java
    update-alternatives --set javac /opt/jdk1.7.0_45/bin/javac

More information refers to [http://www.blackmoreops.com/2013/10/26/how-to-install-java-jdk-in-kali-linux/](http://www.blackmoreops.com/2013/10/26/how-to-install-java-jdk-in-kali-linux/).

Use the above link to configure your java environment.
