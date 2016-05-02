---
layout: post
title: "Define a new keyboard shortcut"
date: 2015-04-22
description: ""
category: 
tags: []
---

**Problem**:

I want to define a new  keyboard shortcut in the graphic "settings/keyboard/shortcuts" to start-up the gitlab
**Name**: Gitlab Panel  
**Commands**: `su -c "/opt/gitlab-7.9.3-0/manager-linux-x64.run"`

The attribute of this file is in the following :

    /opt/gitlab-7.9.3-0/manager-linux-x64.run: ELF 64-bit LSB executable, 
	x86-64, version 1 (GNU/Linux), statically linked, stripped

But when I press the shortcut, there is no response to me.

**Solution**:

Try using `/usr/bin/gksu` (from the package of the same name) instead of `su`. (See the man page for the appropriate syntax.) Then you will be prompted for the sudoer password.

I install with `apt-get install gksu`, and change the command to 'gksu "/opt/gitlab-7.9.3-0/manager-linux-x64.run"'.
Then the problem is solved.
