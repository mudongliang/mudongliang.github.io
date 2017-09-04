---
layout: post
title: "How to install Jekyll on Debian Stretch"
date: 2017-02-17
description: ""
category: 
tags: [jekyll, debian]
---

* TOC
{:toc}

### Install ruby and basic compile environment

```sh
sudo apt-get install ruby-full build-essential
```

### Check if ruby is installed successfully

```sh 
$ ruby -v
ruby 2.3.3p222 (2016-11-21) [x86_64-linux-gnu]
```

### Install `jekyll` by `gem`

```sh
sudo gem install jekyll
```

### Check if jekyll is installed successfully

```sh
$ jekyll -v
jekyll 3.4.0
```

### Start the jekyll

```sh
jekyll serve -w
```

### See from broswer

Open your broswer, type "http://127.0.0.1:4000", then you will see your own website locally.
