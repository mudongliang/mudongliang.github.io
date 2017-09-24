---
layout: post
title: "Implicit function declarations in C Programming"
date: 2017-09-20
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Implicit function declarations in C/C++ Standard

I list the status of working in C/C++ Standard in the following table: 

|Standard|status of working|
|C89/C90|work, only cause warning in compilation|
|C99|not work, cause error in the compilation|
|C11|not work, cause error in the compilation|
|All C++ Standard|not work, cause error in the compilation|

A new feature of C99: The rule for implicit declaration of functions has been removed in C99. 

By default, the implicit function declarations the compiler generates will assume that the return type of the function is int, which will cause logic error, or even crash.

## References

https://stackoverflow.com/questions/17937909/implicit-function-declarations-sometimes-work-in-c
