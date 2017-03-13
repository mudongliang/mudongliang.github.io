---
layout: post
title: "GDB does not works inside docker"
date: 2017-03-13
description: ""
category: 
tags: []
---

Usually, I run docker by the following command:

```
docker run -it <docker image name>
```

When I try to debug inside docker, I find that breakpoint does not work at all and there is warning about ASLR.

After I google this problem, [a solution from stack overflow](http://stackoverflow.com/questions/34856092/gdb-does-not-hit-any-breakpoints-when-run-it-from-inside-docker-container) comes.

In one word, this solution need you to run docker image in privileged mode.

```
docker run --privileged -it <docker image name>
```
