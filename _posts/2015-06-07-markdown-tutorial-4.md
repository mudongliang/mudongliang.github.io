---
layout: post
title: "Markdown学习（四）"
date: 2015-06-07
description: ""
category: 
tags: []
---
# Markdown 支持有序列表和无序列表

## 1. 无序列表使用星号、加号或是减号作为列表标记：

**Source:**

	*   Red
	*   Green
	*   Blue

**Result:**

*   Red
*   Green
*   Blue

等同于：

Source:

	+   Red
	+   Green
	+   Blue

**Result:**

+	Red
+	Green
+	Blue

也等同于：   

**Source:**

	-   Red
	-   Green
	-   Blue

**Result:**

-   Red
-   Green
-   Blue

## 2. 有序列表则使用数字接着一个英文句点：

**Source:**

	1.  Bird
	2.  McHale
	3.  Parish

**Result:**

1.  Bird
2.  McHale
3.  Parish

很重要的一点是，你在列表标记上使用的数字并不会影响输出的 HTML 结果
如果你的列表标记写成：

**Source:**

	1.  Bird
	1.  McHale
	1.  Parish

**Result:**

1.  Bird
1.  McHale
1.  Parish

或甚至是：

**Source:**

	3. Bird
	1. McHale
	8. Parish

**Result:**

3. Bird
1. McHale
8. Parish

## 3.嵌套列表

-+*可循环使用，但符号之后的空格不能少，符号之前的空格也不能少

**Source:**

	- 嵌套列表
	  + 嵌套列表
	  + 嵌套列表
	    - 嵌套列表
		  * 嵌套列表
	- 嵌套列表

**Result:**

- 嵌套列表
  + 嵌套列表
  + 嵌套列表
    - 嵌套列表
	  * 嵌套列表
- 嵌套列表
