---
layout: post
title: "Draft for Launching Teamviewer remotely through SSH"
date: 2021-05-10
description: ""
category: 
tags: []
---
* TOC
{:toc}

Teamviewer is a wonderful tool to access your computer (or any other device) remotely if you need to use your a graphical screen.

## List of TeamViewer command

```
$ whereis teamviewer
teamviewer: /usr/bin/teamviewer /etc/teamviewer
```

```
$ teamviewer --help

 TeamViewer                           15.19.3  (DEB)

 teamviewer                           Start TeamViewer user interface (if not running).
 teamviewer --url URL                 Start a remote control connection with the given TeamViewer link

 teamviewer help                      Print this help screen.
 teamviewer version                   Print version information.
 teamviewer info                      Print version, status, id.
 teamviewer ziplog                    Create a zip containing all teamviewer logs (useful when contacting support).

 teamviewer license [show|accept]     Interactively agree or show/agree to End User License Agreement.
 teamviewer setup                     Configure headless modes (non-gui/console)

 teamviewer passwd [PASSWD]           Set a password (useful when installing remote (ssh).

 teamviewer daemon status             Show current status of the TeamViewer daemon.
 teamviewer daemon start              Start		TeamViewer daemon.
 teamviewer daemon stop               Stop		TeamViewer daemon.
 teamviewer daemon restart            Stop/Start	TeamViewer daemon.
 teamviewer daemon disable            Disable	TeamViewer daemon - don't start daemon on system startup.
 teamviewer daemon enable             Enable		TeamViewer daemon - start daemon on system startup (default).

 teamviewer repo                      show current repository configuration
 teamviewer repo list                 list available packages
 teamviewer repo default              restore default configuration
 teamviewer repo disable              disable repository updates
 teamviewer repo stable               make all regular TeamViewer packages available (default)
 teamviewer repo preview              additionally, make feature preview packages available
```

```
sudo teamviewer --daemon enable
```

```
sudo teamviewer –daemon start
```

```
sudo teamviewer –info
```

```
sudo teamviewer –daemon stop
```

## References

[1] [Launching Teamviewer remotely through SSH](http://www.tonisoto.com/2013/07/launching-teamviewer-remotely-throught-ssh/)
