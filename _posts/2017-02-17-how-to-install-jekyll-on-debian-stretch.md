---
layout: post
title: "How to install Jekyll on Debian Stretch"
date: 2017-02-17
description: ""
category: 
tags: [jekyll, debian]
---


1. Install ruby and basic compile environment

```sh
sudo apt-get install ruby-full build-essential
```

2. Check whether ruby is installed successfully

```sh 
$ ruby -v
ruby 2.3.3p222 (2016-11-21) [x86_64-linux-gnu]
```

3. Install `jekyll` by `gem`

```sh
sudo gem install jekyll
```

4. Check whether jekyll is installed successfully

```sh
$ jekyll -v
jekyll 3.4.0
```

5. boot the jekyll with following command

```sh
jekyll serve -w
```

6. Open your broswer, type "http://127.0.0.1:4000", then you will see your own website locally.
