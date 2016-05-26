---
layout: post
title: "Markdown学习（七）"
date: 2015-06-07
description: ""
category: 
tags: []
---

# 强调

Markdown 使用星号（*）和底线（_）作为标记强调字词的符号，被 * 或 _ 包围的字词会被转成用 ```<em>``` 标签包围，用两个 * 或 _ 包起来的话，则会被转成 ```<strong>```，例如：

**Source:**

    *single asterisks*

    _single underscores_

    **double asterisks**

    __double underscores__

**Result:**

*single asterisks*

_single underscores_

**double asterisks**

__double underscores__

你可以随便用你喜欢的样式，唯一的限制是，你用什么符号开启标签，就要用什么符号结束。

强调也可以直接插在文字中间：

**Source:**

    un*frigging*believable

**Result:**

un*frigging*believable

但是如果你的 * 和 _ 两边都有空白的话，它们就只会被当成普通的符号。

如果要在文字前后直接插入普通的星号或底线，你可以用反斜线：

**Source:**

    \*this text is surrounded by literal asterisks\*

**Result:**

\*this text is surrounded by literal asterisks\*

# 代码

如果要标记一小段行内代码，你可以用反引号把它包起来（`），例如：

**Source:**

    Use the `printf()` function.

**Result:**

Use the `printf()` function.

如果要在代码区段内插入反引号，你可以用多个反引号来开启和结束代码区段：

**Source:**

    ``There is a literal backtick (`) here.``

**Result:**

``There is a literal backtick (`) here.``

在代码区段内，& 和尖括号都会被自动地转成 HTML 实体，这使得插入 HTML 原始码变得很容易，Markdown 会把下面这段：

**Source:**

    Please don't use any `<blink>` tags.

**Result:**

Please don't use any `<blink>` tags.

# 图片

很明显地，要在纯文字应用中设计一个「自然」的语法来插入图片是有一定难度的。  
Markdown 使用一种和链接很相似的语法来标记图片，同样也允许两种样式： 行内式和参考式。  
行内式的图片语法看起来像是：

**Source:**

    ![Alt text](http://njumdl-wordpress.stor.sinaapp.com/uploads/linuxpicture/1247537239.png "ArchLinux")

    ![Alt text](http://njumdl-wordpress.stor.sinaapp.com/uploads/linuxpicture/download.jpg "Debian")

**Result:**

![Alt text]({{site.url}}/images/arch-linux-logo.png "ArchLinux")

![Alt text]({{site.url}}/images/debian-logo.png "Debian")

详细叙述如下：

>一个惊叹号 !  
>接着一个方括号，里面放上图片的替代文字  
>接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上 选择性的 'title' 文字。  

参考式的图片语法则长得像这样：

![Alt text][id]

「id」是图片参考的名称，图片参考的定义方式则和连结参考一样：

[id]: http://njumdl-wordpress.stor.sinaapp.com/uploads/linuxpicture/1247537239.png "ArchLinux"
> id defines here
