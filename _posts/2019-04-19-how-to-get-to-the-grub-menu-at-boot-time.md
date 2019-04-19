---
layout: post
title: "How to get to the GRUB menu at boot time?"
date: 2019-04-19
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Temporary

Menu will appear if you press and hold `Shift` during loading Grub, if you boot using BIOS. 

When your system boots using UEFI, press `Esc`.

## Permanent

You need to edit `/etc/default/grub` file -- place a "#" symbol at the start of line `GRUB_HIDDEN_TIMEOUT=0`.

Save changes and run `sudo update-grub` to apply changes.
