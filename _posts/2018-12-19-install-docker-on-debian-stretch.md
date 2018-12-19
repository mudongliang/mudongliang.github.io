---
layout: post
title: "Install Docker on Debian Stretch"
date: 2018-12-19
description: ""
category: 
tags: []
---
* TOC
{:toc}


## Uninstall older version

Older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them:

```
$ sudo apt-get remove docker docker-engine docker.io
```

## Install Docker CE

### Install using the repository

1. Install packages to allow apt to use a repository over HTTPS:

```
$ sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
```

2. Add Docker’s official GPG key:

```
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

3. Use the following command to set up the stable repository.

```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
```

4. Install Docker CE

```
$ sudo apt-get update
$ sudo apt-get install docker-ce
```

5. Verify that Docker CE is installed correctly by running the hello-world image.

```
$ sudo docker run hello-world
```

### Install from a package

1. Go to `https://download.docker.com/linux/debian/dists/`, choose your Debian version, browse to `pool/stable/`, choose `amd64` and download the .deb file for the Docker CE version you want to install.

2. Install Docker CE, changing the path below to the path where you downloaded the Docker package.

```
$ sudo dpkg -i /path/to/package.deb
```

The Docker daemon starts automatically.

3. Verify that Docker CE is installed correctly by running the hello-world image.

```
$ sudo docker run hello-world
```

### Install using the convenience script

Docker provides convenience scripts at [get.docker.com](https://get.docker.com/) for installing edge and testing versions of Docker CE into development environments quickly and non-interactively. The source code for the scripts is in the docker-install repository. **However, using these scripts is not recommended for production environments**

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

## Uninstall Docker CE

1. Uninstall the Docker CE package

```
$ sudo apt-get purge docker-ce
```

However, images, containers, volumes, or customized configuration files on your host are not automatically removed.

2. Delete all images, containers, and volumes

```
$ sudo rm -rf /var/lib/docker
```

## References

[1] <https://docs.docker.com/install/linux/docker-ce/debian/>
