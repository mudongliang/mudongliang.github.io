---
layout: post
title: "Powerpoint Presenter view   notes not syncing in Mac OS X"
date: 2019-11-06
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Problem

Powerpoint Presenter view - notes not syncing in Mac OS Catalina (10.15.1)

I am on Powerpoint 16.30 (19101301) on Mac. Since the latest update installed, I am having issues with presenter view. The notes for the first slide appear but do not update as I move from slide to slide. The slides move but the only way I can see the connected notes is to click on the notes pane, which is obviously not ideal as it means I am tied to the laptop and can't just use the clicker.

It doesn't matter whether I use the clicker or click on the arrow to progress to the next slide.

## Solution

1. Remove 16.30 and downgrade to 16.29;
2. Change the Update Channel to "Insider Fast" and upgrade to 16.31;

More specific, select `Help->Check for Updates->Advanced->Update Channel`, set to **Insider Fast** and then check for updates and it will update to 16.31. It seems to have solved the problem.

## References

[1] <https://answers.microsoft.com/en-us/msoffice/forum/all/powerpoint-presenter-view-notes-not-syncing-mac/577a5e36-18da-4034-a88e-78364257c9b1>
