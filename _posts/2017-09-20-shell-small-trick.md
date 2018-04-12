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

### Use Tab as field delimiter

```
cut -f 1 file
awk -F$'\t' '{print $1} file
```

Note: `cut` use TAB for its field delimiter

## Uncompress all the archives in one 

```
find . -name '*.zip' -execdir unzip '{}' ';'
find . -name '*.tar.gz' -execdir tar -xvf '{}' ';'
```
