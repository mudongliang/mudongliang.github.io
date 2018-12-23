---
layout: post
title: "Difference between git checkout -- and git checkout"
date: 2018-12-23
description: ""
category: 
tags: []
---
* TOC
{:toc}


## git checkout \-\- . **vs** git checkout

The `--` is a way to tell Git to treat what follows checkout as a file and not as a branch. Suppose that you had both a file and a branch called `stuff`. Then the following command would seem ambiguous:

```
git checkout stuff
```

because it is not clear whether you are asking to checkout a file or a branch. By using `--` you explicitly tell Git to checkout a file by that name/path. So in this case the following commands allow checking out a branch and a file called `stuff`:

```
git checkout stuff       # checkout the branch stuff
git checkout -- stuff    # checkout the file stuff
```

Note that git checkout \<name\> is really meant for branches, but Git syntax is relaxed, and if Git can't find a branch, then it will look for a file.

## References

[1] <https://stackoverflow.com/questions/41101998/git-checkout-vs-git-checkout/41102120>

[2] <https://stackoverflow.com/questions/23208156/why-do-we-use-double-dash-in-git-checkout>
