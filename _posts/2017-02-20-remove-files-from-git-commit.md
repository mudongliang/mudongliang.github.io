---
layout: post
title: "Remove files from Git commit"
date: 2017-02-20
description: ""
category: 
tags: []
---

Learn from [Remove files from Git commit](http://stackoverflow.com/questions/12481639/remove-files-from-git-commit)

I am learning to use git to manage my project.

Once I need to add many files, so I directly use `git add -a` to add all of them. But I added one file whose filesize is larger than 100M. When I push my commit, it shows `File XXX is 190 MB; this exceeds github's file size limit of 100 MB`.

Please refer to [Conditions for large files](https://help.github.com/articles/conditions-for-large-files/).

What I want to do is to remove such big files from the last commit.

1.revert to HEAD^

```sh
git reset --soft HEAD^ 
```

or

```sh
git reset --soft HEAD~1
```

2.reset the unwanted files in order to leave them out from the commit:

```sh
git reset HEAD path/to/unwanted_file
```

3.commit again, you can even re-use the same commit message:

```sh
git commit -c ORIG_HEAD
```
