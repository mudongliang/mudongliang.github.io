---
layout: post
title: "GNOME Shell Screen Recorder"
date: 2020-09-14
description: ""
category: 
tags: []
---
* TOC
{:toc}

## GNOME Shell Screen Recorder

There’s a built-in screen recorder in GNOME Desktop Environment. It’s included as part of the GNOME Shell desktop and, although it’s well integrated it’s also well hidden: there’s no app launcher for it, no menu entry to it, and no quick button to turn it on or off. Instead, to access the GNOME Shell screen recorder you need to press a finger-flexing keyboard shortcut (which we’ll show you in a second).

### Instant Screen Capture

You can quickly record the Ubuntu desktop (and everthing that appears and happens on it) and save it as a video just by pressing this keyboard shortcut:
```
Ctrl + Alt + Shift + R
```

The screen capture will start instantly. Recording automatically stops after 30 seconds.

You can stop recording at any time by pressing the screencast shortcut combo again:
```
Ctrl + Alt + Shift + R
```

A video of your screencast is automatically saved to the Videos folder in your Home folder.

### Increase the duration of screen recording

At just 30 seconds long the default length of screencast using this method isn't ideal, particularly if you plan on making a lengthy video or need to demo a particular workflow or feature.

It is possible to increase the duration of screencasts manually, by modifying the following gsettings string using the Terminal application:

```
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 60
```

Replace the '60' value with the length you want in seconds, e.g., 300 for 5 minutes, 600 for 10 minutes, and so on.

If you set the value to '0' there will be no time limit.
