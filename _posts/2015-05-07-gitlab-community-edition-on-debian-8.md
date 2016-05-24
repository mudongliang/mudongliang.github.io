---
layout: post
title: "Gitlab Community Edition On Debian 8"
date: 2015-05-07
description: ""
category: 
tags: []
---
Debian is among the most popular platforms to run GitLab on. With the stable release of Debian 8, we wanted to make sure that early-adopters could run GitLab on their new machines.    
You can install Github from [downloads page](https://about.gitlab.com/downloads).    
You can also install GitLab Community Edition with:

```sh
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install gitlab-ce
```
