---
layout: post
title: "Docker : Got permission denied while trying to connect to the Docker daemon socket"
date: 2017-09-20
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem

You are trying to run a docker container or do the docker tutorial, but you only get an error message like this:

```
docker: Got permission denied while trying to connect to
the Docker daemon socket at unix:///var/run/docker.sock:
...
dial unix /var/run/docker.sock: connect: permission denied.
See 'docker run --help'.
```

## Solution

As a temporary solution, you can use sudo to run the failed command as root.
However it is recommended to fix the issue by adding the current user to the docker group:

Run this command in your favourite shell and then completely reboot:

```
sudo usermod -a -G docker $USER
sudo reboot
```

## References

[1] [https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/](https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/)
