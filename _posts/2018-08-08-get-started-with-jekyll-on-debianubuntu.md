---
layout: post
title: "Get Started With Jekyll on Debian/Ubuntu"
date: 2018-08-08
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Objective

The objective is to install Jekyll(the static site generator) from Gem or standard on Debian/Ubuntu software repository. 

## Operating System and Software Versions

- **Operating System**: Debian 10 Buster / Ubuntu 18.04 LTS
- **Software**: jekyll 3.4.3 (source) or jekyll 3.1.6 (Debian/Ubuntu Repository) 

## Requirements

Privileged access to your Debian/Ubuntu system is required to install Jekyll packages as well as all prerequisite gems. 

## Install Jekyll

### Debian/Ubuntu Repository

This is by far the most easiest way to install Jekyll on your Linux system. The disadvantage is that depending on your requirements you may end up with although stable but outdated Jekyll version. To install Jekyll run: 

```
$ sudo apt install jekyll
$ jekyll -v
jekyll 3.1.6
``` 

### Gem

You could execute following instructions to install Jekyll from source.

```
$ sudo apt-get install ruby ruby-dev build-essential
$ sudo gem install jekyll
$ jekyll -v
jekyll 3.8.3
```

if you would like to select specific version to install, please try :

```
$ sudo gem install jekyll -v "3.1.5"
```

## References

[1] <https://linuxconfig.org/getting-started-with-jekyll-on-debian-9-stretch-linux>

[2] <https://jekyllrb.com/docs/installation/#ubuntu>
