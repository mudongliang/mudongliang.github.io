---
layout: post
title: Draft for "how to stop gpg warning one public key"
date: 2022-03-17
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem

I download one public key from the Internet, and import it in gpg

```
$ gpg --import some.asc
```

When I encrypt a data file with this public key, I get the following warning message.

```
It is NOT certain that the key belongs to the person named
in the user ID.  If you *really* know what you are doing,
you may answer the next question with yes.
``` 

## Solution

```
$ gpg --edit-key YOUR@KEY.ID
gpg> trust
Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y
```

## References

[1] <https://askubuntu.com/questions/288853/why-is-gpg-getting-upset-and-how-do-i-stop-it>
