---
layout: post
title: "Markdown学习（六）"
date: 2015-06-07
description: ""
category: 
tags: []
---

# 链接

## Markdown 支持两种形式的链接语法： 行内式和参考式两种形式。

不管是哪一种，链接文字都是用 [方括号] 来标记。

---

要建立一个行内式的链接，只要在方块括号后面紧接着圆括号并插入网址链接即可，如果你还想要加上链接的 title 文字，只要在网址后面，用双引号把 title 文字包起来即可，例如：

**Source:**

```
This is [an example](http://example.com/ "Title") inline link.    
[This link](http://example.net/) has no title attribute.
```

**Result:**

This is [an example](http://example.com/ "Title") inline link.    
[This link](http://example.net/) has no title attribute.

如果你是要链接到同样主机的资源，你可以使用相对路径：

**Source:**

    See my [About](/about/) page for details.

**Result:**

See my [About](/about/) page for details.

---
参考式的链接是在链接文字的括号后面再接上另一个方括号，而在第二个方括号里面要填入用以辨识链接的标记：

**Source:**

    This is [an example][id] reference-style link.

**Result:**

This is [an example][id] reference-style link.

你也可以选择性地在两个方括号中间加上一个空格：

**Source:**

```
This is [an example] [id] reference-style link.
```

**Result:**

This is [an example] [id] reference-style link.

接着，在文件的任意处，你可以把这个标记的链接内容定义出来：

**Source:**

```
[id]: http://example.com/  "Optional Title Here"
```

**Result:**

[id]: http://example.com/  "Optional Title Here"

>id defines here
 
链接内容定义的形式为：

方括号（前面可以选择性地加上至多三个空格来缩进），里面输入链接文字,接着一个冒号,接着一个以上的空格或制表符,接着链接的网址,选择性地接着 title 内容，可以用单引号、双引号或是括弧包着

下面这三种链接的定义都是相同：

**Source:**

    [foo]: http://example.com/  "Optional Title Here"
    [foo]: http://example.com/  'Optional Title Here'
    [foo]: http://example.com/  (Optional Title Here)

**Result:**

[foo]: http://example.com/  "Optional Title Here"
[foo]: http://example.com/  'Optional Title Here'
[foo]: http://example.com/  (Optional Title Here)
> foo defines here

链接网址也可以用尖括号包起来：

**Source:**

    [id]: <http://example.com/>  "Optional Title Here"

**Result:**

[id]: <http://example.com/>  "Optional Title Here"
>id defines here

你也可以把 title 属性放到下一行，也可以加一些缩进，若网址太长的话，这样会比较好看：

**Source:**

	[id]: http://example.com/longish/path/to/resource/here
	    "Optional Title Here"
**Result:**

[id]: http://example.com/longish/path/to/resource/here
	    "Optional Title Here"
>id defines here

网址定义只有在产生链接的时候用到，并不会直接出现在文件之中。
链接辨别标签可以有字母、数字、空白和标点符号，但是并不区分大小写.

---
隐式链接标记功能让你可以省略指定链接标记，这种情形下，链接标记会视为等同于链接文字，要用隐式链接标记只要在链接文字后面加上一个空的方括号，如果你要让 "Google" 链接到 google.com，你可以简化成：

**Source:**

    [Google][]
    [Google]: http://google.com/

**Result:**    

[Google][]

[Google]: http://google.com/

链接的定义可以放在文件中的任何一个地方，我比较偏好直接放在链接出现段落的后面，你也可以把它放在文件最后面，就像是注解一样。

下面是一个参考式链接的范例：

**Source:**

    I get 10 times more traffic from [Google] [1] than from
    [Yahoo] [2] or [MSN] [3].

    [1]: http://google.com/        "Google"
    [2]: http://search.yahoo.com/  "Yahoo Search"
    [3]: http://search.msn.com/    "MSN Search"

如果改成用链接名称的方式写：

**Source:**

    I get 10 times more traffic from [Google][] than from
    [Yahoo][] or [MSN][].

    [google]: http://google.com/        "Google"
    [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
    [msn]:    http://search.msn.com/    "MSN Search"

下面是用行内式写的同样一段内容的 Markdown 文件，提供作为比较之用：

**Source:**

    I get 10 times more traffic from [Google](http://google.com/ "Google") 
    than from [Yahoo](http://search.yahoo.com/ "Yahoo Search")    
    or [MSN](http://search.msn.com/ "MSN Search").

**Result:**

I get 10 times more traffic from [Google] [1] than from [Yahoo] [2] or [MSN] [3].

[1]: http://google.com/        "Google"
[2]: http://search.yahoo.com/  "Yahoo Search"
[3]: http://search.msn.com/    "MSN Search"    

