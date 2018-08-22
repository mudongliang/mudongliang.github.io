---
layout: post
title: "Avoiding Type 3 fonts in matplotlib plots"
date: 2018-08-22
description: ""
category: 
tags: []
---
* TOC
{:toc}

The Python plotting library, matplotlib, uses Type 3 fonts by default. However, Type 3 fonts do not display and print from some platforms.

We could use the following code to force matplotlib to produce Type 1 fonts.

```
matplotlib.rcParams['text.usetex'] = True
```

## References

[1] <http://phyletica.org/matplotlib-fonts/>
