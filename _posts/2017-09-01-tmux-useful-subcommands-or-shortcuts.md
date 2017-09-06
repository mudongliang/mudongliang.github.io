---
layout: post
title: "tmux useful subcommands or shortcuts"
date: 2017-09-01
description: ""
category: 
tags: []
---

* TOC
{:toc}

![tmux panes]({{site.url}}/images/tmuxpanes.jpg)

## Introduction

`tmux` is useful to people in different ways. To me, it’s most useful as a way to maintain persistent working states on remote servers—allowing you to detach and re-attach at will.

You could, for example, have a session on your server for hacking on a node REST API (my current project), and call it “nodeapi”. And let us say that you are compiling something for it that will take two hours (work with me), but you’re currently working at a coffee shop and you have to leave. tmux lets you simply detach from that session and come back to it later.

That’s handy.

Others like to focus on how you can use tmux to have multiple panes within multiple windows within multiple tabs within multiple sessions. I don’t do that. I like fewer of those—as few as possible, actually—and this guide will be focused on a simple persistent-remote-sessions model.

**A remote computing lifestyle**

Mobility is a central theme for tmux users. Many developers do all of their work from the server, and simply connect in from $wherever to do it. tmux (and similar tools) allow you to work from a coffee shop in SF, start something building on the server, disconnect to take a flight, and then pick up that same task on the ground in NYC when you land.

A related advantage to this mobile approach is the fact that your client machine is not too terribly important. You can upgrade your laptop, clone a repo with your vim/tmux dotfiles in it, and you’re back to your optimum computing environment in minutes rather than days.

Anyway, those are some reasons that people love tmux, but you don’t have to make this lifestyle change in order to see its benefits.

## Why tmux?

Why do I try to `tmux` other than `terminator`?

Because I sometimes need to ssh, ssh, ...... and ssh to my destination server. And `tmux` could help you directly split panels with one shared ssh connection.

## Basics

Now is a good time to mention that there is a universal tmux shortcut that lets you quickly perform many tasks.

### The tmux shortcut

By default, tmux uses `Ctrl-b` as its shortcut activation chord, which enables you perform a number of functions quickly. Here are a few of the basics:

First you hit:

```
$ Ctrl-b
```

… followed by a number of options that we’ll talk about below. But get ready to use that `Ctrl-b` combo. Also consider remapping `CAPSLOCK` to `CONTROL` within your operating system; it makes the pinky walk for `Ctrl-b` quite nice.

### Invocation 

Right then. Let’s start by running `tmux`. You want to do this from the system that you want to detach and re-attach to which for me is usually a remote server.

```
$ tmux
```

Simple enough. You now have a tmux session open that you can disconnect from and come back to later.

### Show Sessions

Since the idea of tmux is having multiple sessions open, and being able to disconnect and reconnect to them as desired, we need to be able to see them quickly.

```
# Via shortcut (by default Ctrl-b)

$ Ctrl-b s

# Via tmux command

$ tmux ls
```

Either way you get the same thing:

```
0: 1 windows (created Tue Sep  5 22:58:45 2017) [150x38] (attached)
```

### Create a new Session

Now we’re going to create a new session. You can do this with just the new command, or by providing an argument to it that serves as the session name. I recommend providing a session name, since organization is rather the point of tmux.

```
$ tmux new -s session-name
```

### Attach to an existing session

Since we’re going to be creating sessions with names, and we may have more than one, we want to be able to attach to them properly. There are a couple ways of doing this.

You can simply type tmux a and it’ll connect you to the first available session.

```
$ tmux a
```

Or you can attach to a specific session by providing an argument.

```
$ tmux a -t session-name
```

### Detach from a session

You can detach from an existing session (so you can come back to it later) by sending the detach command.

```
$ tmux detach
```

Or you can use the shortcut.

```
$ Ctrl-b d
```

### Kill a session

There are times when you’ll want to destroy a session. This can be done using the following syntax, which is much the same as attachment:

```
$ tmux kill-session -t session-name
```

## Advanced

### Windows and Panes

One of these features is the ability to break your session into more discreet components, called windows and panes. These are good for organizing multiple varied activities in a logical way.

![tmux panes]({{site.url}}/images/tmuxpanes.jpg)

#### Nesting

![tmux nesting]({{site.url}}/images/tmuxnesting.png)

tmux sessions have windows, and windows have panes. Below you can see how how I conceptualize them although if anyone has a more authoritative or useful hierarchy I’ll happily embrace it.

- **`Sessions`** are for an overall theme, such as work, or experimentation, or sysadmin.

- **`Windows`** are for projects within that theme. So perhaps within your experimentation session you have a window titled noderestapi, and one titled lua sample.

- **`Panes`** are for views within your current project. So within your sysadmin session, which has a logs window, you may have a few panes for access logs, error logs, and system logs.


#### Navigating with panes

```
Up:
$ Ctrl-b ↑

Left:
$ Ctrl-b ←

Right:
Ctrl-b →

Down:
Ctrl-b ↓
```

## Shortcut Reference

Now a `Ctrl-b` options reference:

### Basics

**`?`** get help

### Session management

**`s`** list sessions

**`$`** rename the current session

**`d`** detach from the current session

### Windows

**`c`** create a new window

**`,`** rename the current window

**`w`** list windows

**`%`** split horizontally

**`"`** split vertically

**`n`** change to the next window

**`p`** change to the previous window

**`0 to 9`** select windows 0 through 9

### Panes

**`%`** create a horizontal pane

**`"`** create a vertical pane

**`h`** move to the left pane

**`j`** move to the pane below

**`l`** move to the right pane

**`k`** move to the pane above

**`q`** show pane numbers

**`o`** toggle between panes

**`}`** swap with next pane

**`{`** swap with previous pane

**`!`** break the pane out of the window

**`x`** kill the current pane

## References

[A tmux Primer](https://danielmiessler.com/study/tmux/)

[tmux cheatsheet](https://gist.github.com/henrik/1967800)
