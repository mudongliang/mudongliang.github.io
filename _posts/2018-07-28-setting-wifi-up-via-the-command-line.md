---
layout: post
title: "Set up WiFi on the Raspberry Pi in command line"
date: 2018-07-28
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Using raspi-config

The quickest way to enable wireless networking is `to use the command line raspi-config tool`.

```
sudo raspi-config
```

Select the Network Options item from the menu, then the Wi-fi option. On a fresh install, for regulatory purposes, you will need to specify the country in which the device is being used. Then set the SSID of the network, and the passphrase for the network. If you do not know the SSID of the network you want to connect to, see the next section on how to list available networks prior to running raspi-config.

## Getting WiFi network details

To scan for WiFi networks, use the command `sudo iwlist wlan0 scan`. This will list all available WiFi networks, along with other useful information. Look out for:

'ESSID:"testing"' is the name of the WiFi network.

'IE: IEEE 802.11i/WPA2 Version 1' is the authentication used. In this case it's WPA2, the newer and more secure wireless standard which replaces WPA. This guide should work for WPA or WPA2, but may not work for WPA2 enterprise. For WEP hex keys, see the last example here. You'll also need the password for the wireless network.

## References

<https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md>
