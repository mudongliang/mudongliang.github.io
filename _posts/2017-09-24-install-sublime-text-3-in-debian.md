---
layout: post
title: "Install Sublime Text 3 in Debian"
date: 2017-09-24
description: ""
category: 
tags: []
---
* TOC
{:toc}

In linux, we can install sublime text 3 by all kinds of package managers. We just list `apt` here. 

## Apt

- Install the GPG key:

```
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
```

Ensure apt is set up to work with https sources:

```
sudo apt-get install apt-transport-https
```

Select the channel to use:

- Stable

```
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
```

- Dev

```
echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
```

- Update apt sources and install Sublime Text

```
sudo apt-get update
sudo apt-get install sublime-text
```

## References

[1] [Official Document](https://www.sublimetext.com/docs/3/linux_repositories.html)
