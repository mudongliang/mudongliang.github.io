---
layout: post
title: "How To Find Saved WiFi Passwords In Linux?"
date: 2018-01-19
description: ""
category:
tags: []
---

* TOC
{:toc}

## Problem

How do we find saved WiFi password in Linux?

## Solution

### Graphic Menu

`cd /etc/NetworkManager/system-connections`

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu-5.jpg)

Now with the help of cat command followed by the network name, you can see the saved details. Under the section, WiFi-Security, you can find the password which will be prefixed by “psk=”. Also, don’t forget to replace Fossbytes by your own network name:

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu-6.jpg)

### Terminal

1. First you need to click on the **WiFi icon** in the top right corner to reveal a drop-down menu. At the bottom of the menu, **Edit Connections** option.

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu.jpg)

2. After clicking the network connections, you’ll see different options under Ethernet and Wi-Fi. You’ll see the saved network connections under the Wi-Fi option. Depending upon your requirement, you can click on a **WiFi network** to select it and press the **Edit** button for further operations.

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu-2.jpg)

3. After you click the **Edit** option, a new window will appear with different tabs. There, you need to select the **Wi-Fi Security** tab. This will reveal the security and password associated with it. It’ll be hidden.

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu-3.jpg)

4.  Now tick the **Show Password** option to show the saved password of the network. If you’re not acquainted with the other options, don’t fiddle with them as they might end up messing with your wireless configuration.

![wireless network connection]({{site.url}}/images/wifi-network-password-ubuntu-4.jpg)


## References

[1] [How To Find Saved WiFi Passwords In Linux?](https://fossbytes.com/find-saved-wifi-passwords-linux/)
