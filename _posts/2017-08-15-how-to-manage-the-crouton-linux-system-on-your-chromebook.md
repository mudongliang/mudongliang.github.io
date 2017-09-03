---
layout: post
title: "How to Manage the Crouton Linux System on Your Chromebook"
date: 2017-08-15
description: ""
category: 
tags: []
---

* TOC
{:toc}

Crouton stores the Linux systems you install in “chroots.” You can have multiple chroots. The commands below will help you work with and manage those chroots.

## Choose a Target

After downloading the Crouton script to your Downloads folder, you can run the following command to see a list of targets:

```
$ sh ~/Downloads/crouton -t help
Available targets:
audio
        Support audio playback via Chromium OS's audio system.
        Requires: core
chrome
        Google Chrome browser, stable channel.
        Requires: x11
chrome-beta
        Google Chrome browser, beta channel.
        Requires: x11
chrome-dev
        Google Chrome browser, dev channel.
        Requires: x11
chromium
        Chromium browser. Uses the distro's version, which may be old.
        Requires: x11
cli-extra
        Basic CLI tools such as ssh.
        Requires: core
core
        Performs core system configuration. Most users would want this.
e17
        Installs the enlightenment desktop environment. (Approx. 50MB)
        Requires: gtk-extra
extension
        Clipboard synchronization and URL handling with Chromium OS.
        Requires: x11
gnome
        Installs the GNOME desktop environment. (Approx. 400MB)
        Requires: gtk-extra
gnome-desktop
        Installs GNOME along with common applications. (Approx. 1100MB)
        Requires: gnome
gtk-extra
        GTK-based tools including gdebi, gksu, and a simple browser.
        Requires: x11
kde
        Installs a minimal KDE desktop environment. (Approx. 600MB)
        Requires: x11
kde-desktop
        Installs KDE along with common applications. (Approx. 1000MB)
        Requires: kde
keyboard
        Adds support for Chromebook keyboard special keys.
        Requires: x11
lxde
        Installs the LXDE desktop environment. (Approx. 200MB)
        Requires: gtk-extra
lxde-desktop
        Installs LXDE along with common applications. (Approx. 800MB)
        Requires: lxde
touch
        Touchscreen and limited generic gesture support.
        Requires: x11
unity
        Installs the Unity desktop environment. (Approx. 700MB)
        Requires: gtk-extra
unity-desktop
        Installs Unity along with common applications. (Approx. 1100MB)
        Requires: unity
x11
        X11 via autodetected backend. Does not install any desktop environment.
xbmc
        Installs the XBMC media player. (Approx. 140MB)
        Requires: x11
xfce
        Installs the Xfce desktop environment. (Approx. 250MB)
        Requires: gtk-extra
xfce-desktop
        Installs Xfce along with common applications. (Approx. 1200MB)
        Requires: xfce
xiwi
        X.org X11 backend running unaccelerated in a Chromium OS window.
        Requires: audio extension
xorg
        X.Org X11 backend. Enables GPU acceleration on supported platforms.
        Requires: audio
```

## Pick a Linux Distro and Release

Crouton still uses Ubuntu 12.04 as its default Linux distribution, but you can install other releases of Ubuntu, Debian, or Kali Linux. Specify a release with -r name while running the Crouton command.

```
$ sh ~/Downloads/crouton -r list
Insufficient permissions to refresh crouton installer.
Recognized debian releases:
    potato! woody! sarge! etch! lenny! squeeze! wheezy jessie stretch sid
Recognized kali releases:
    moto! kali! sana! kali-rolling
Recognized ubuntu releases:
    warty! hoary! breezy! dapper! edgy! feisty! gutsy! hardy! intrepid! jaunty!
    karmic! lucid! maverick! natty! oneiric! precise quantal! raring! saucy!
    trusty utopic! vivid! wily! xenial yakkety* zesty*
Releases marked with ! are upstream end-of-life, and should be avoided.
Releases marked with * are unsupported, but may work with some effort.
```

## Install a Crouton Chroot

After you choose one release for one linux distribution and its desktop environment, for example, you choose "Ubuntu 16.04 LTS and unity desktop", the argument for `r` option is `xenial`(**Note: this is the codename of Ubuntu 16.04 LTS**), and argument for `t` option is `unity`, then the whole command is as follows:

```
sudo sh ~/Downloads/crouton -r xenial -t unity
```

You can also install Ubuntu 14.04 LTS with another command,

```
sudo sh ~/Downloads/crouton -r trusty -t unity
```

In the above two commands, `xenial` and `trusty` is the name of corresponding crouton chroot respectively.

## Update a Crouton Chroot

Run the following command from the Chrome OS shell, replacing “name” with the name of your chroot. If you didn’t specify a name, it’s probably the name of the release you installed — for example, “trusty” or “precise.”

```
sudo sh ~/Downloads/crouton -u -n name
```

## Encrypt a Chroot

When installing a Crouton chroot with the installer script, add -e to the command to encrypt your chroot.

```
sudo sh ~/Downloads/crouton -u -e -n name
```

## Back Up a Chroot

Back Up

```
sudo edit-chroot -b name
```

Restore

```
sudo edit-chroot -r name
```

## Delete a Chroot

```
sudo delete-chroot name
```

For example,

```
sudo delete-chroot stretch
Unmounting /mnt/stateful_partition/crouton/chroots/stretch...
Delete /mnt/stateful_partition/crouton/chroots/stretch? [a/y/N] y
Finished deleting /mnt/stateful_partition/crouton/chroots/stretch
```

## References

[How to Manage the Crouton Linux System on Your Chromebook](https://www.howtogeek.com/210047/how-to-manage-the-crouton-linux-system-on-your-chromebook/)
