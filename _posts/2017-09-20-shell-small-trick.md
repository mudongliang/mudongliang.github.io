---
layout: post
title: "Shell small trick"
date: 2017-09-20
description: ""
category: 
tags: []
---
* TOC
{:toc}


### Average

```
awk '{sum+=$1};END{print sum/NR}' result
```
