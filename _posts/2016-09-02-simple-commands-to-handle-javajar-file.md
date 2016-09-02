---
layout: post
title: "Simple commands to handle java/jar file"
date: 2016-09-02
description: ""
category: 
tags: []
---

To compile a java file to generate class

    $ javac helloworld.java

To execute of file

    $ java helloworld

If you need include another jar file, please do like the following commands:

    $ javac -cp ".:./jars/common.jar" helloworld.java 
    $ java -cp ".:./jars/common.jar" helloworld

If you need view the contents of a JAR file, please do like the following command:

    $ jar -tf helloworld.jar
