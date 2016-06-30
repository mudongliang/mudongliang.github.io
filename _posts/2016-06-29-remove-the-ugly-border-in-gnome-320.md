---
layout: post
title: "Remove the ugly border in Gnome 3.20"
date: 2016-06-29
description: ""
category: 
tags: []
---

Here is a `.config/gtk­3.0/gtk.css` file where the ugly border is removed. If there is no such file, just create it.

    window.ssd headerbar.titlebar {
      border: none;
      background-image: linear-gradient(to bottom, 
        shade(@theme_bg_color, 1.05), 
        shade(@theme_bg_color, 0.99));
      box-shadow: inset 0 1px shade(@theme_bg_color, 1.4);
    }
