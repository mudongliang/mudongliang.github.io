---
layout: post
title: "git send email with --cc-cmd and --to-cmd"
date: 2021-06-21
description: ""
category: 
tags: []
---
* TOC
{:toc}

## get_maintainer.pl

In `submitting-patches.rst` [2], Linux kernel leverages `./scripts/get_maintainer.pl` to get the maintainers of corresponding patches or kernel files. To be specify, this script takes a patch as input and gives back a list of email addresses. These email addresses are usually passed to git send-email [3] for patch submission.

However, it is really troublesome to copy email address into `git send-email`.

## git send-email

After searching online, I found two great command options of `git send-email`.

```
    --to-cmd                <str>  * Email To: via `<str> $patch_path`
    --cc-cmd                <str>  * Email Cc: via `<str> $patch_path`
```

`--to-cmd` specifies a command to execute once per patch file which should generate patch file specific "To:" email addresses. Output of this command must be single email address per line. Default is the value of sendemail.tocmd configuration value.

The same to `--cc-cmd`, except that the former is for "To:" and the latter is for "CC:".

What to to next is to copy the following lines into `~/.gitconfig`:

```
[sendemail]
    tocmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nol"
    cccmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nom"
```

Finally, when I need to submit a patch, just type the following command:

```
git send-email 0001-ieee802154-hwsim-Fix-memory-leak-in-hwsim_add_one.patch
```

## References

[1] <https://www.marcusfolkesson.se/blog/get_maintainers-and-git-send-email/>

[2] <https://elixir.free-electrons.com/linux/latest/source/Documentation/process/submitting-patches.rst>

[3] <https://git-scm.com/docs/git-send-email>
