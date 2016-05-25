---
layout: post
title: "How to upgrade from Fedora21 to Fedora22"
date: 2015-06-04
description: ""
category: 
tags: []
---

# How to Upgrade from Fedora 21 to Fedora 22

From [How to Upgrade from Fedora 21 to Fedora 22](http://fedoramagazine.org/upgrade-fedora-21-fedora-22/)

## 1. Make sure your current system is up-to-date and backed up

First up, ensure that you have the most up-to-date version of Fedora 21 by updating your system using the Software application, or running the following command in the terminal:

    sudo dnf update

## 2. Install the FedUp tool

Now, open up a Terminal and install FedUp package by using the following command line:

    sudo dnf install fedup

## 3. Start the update with FedUp

Now your system is fully up-to-date, start the upgrade using the following command:

    sudo fedup --network 22

This command will tell FedUp to download all the appropriate packages from the Fedora repositories, and prep your system for the upgrade.

## 4. Reboot, and upgrade

![Image]({{site.url}}/images/fedup-grub.png)

Once the FedUp command from step 3 has completed without errors, reboot your system. In the Fedora Boot Menu (i.e. grub), there will be a menu item “System Upgrade”, select that and press enter.

## Further Information

For more detailed instructions on using FedUp for upgrading (including using a downloaded ISO or another installation source other than the network), check out the FedUp wikipage. This page also has details on issues that you may encounter during an upgrade.
