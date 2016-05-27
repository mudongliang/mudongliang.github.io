---
layout: post
title: "my vim configuration"
date: 2016-05-26
description: ""
category: 
tags: []
---

My vimrc is stored on the [Github](https://github.com/mudongliang/Myvimrc).

## Installation

```sh
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ git clone https://github.com/mudongliang/Myvimrc
$ cp Myvimrc/vimrc ~/.vimrc
$ rm -rf Myvimrc

```

## Usage

```sh
:PluginUpdate        - update all the plugins
:PluginList          - list configured plugins
:PluginInstall(!)    - install (update) plugins
:PluginSearch(!) foo - search (or refresh cache first) for foo
:PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
```

## Installed Plugins

```
" Code complete
Plugin 'snipMate' 
" NERD tree
Plugin 'scrooloose/nerdtree 
" Plugin to manage Most Recently Used (MRU) files
Plugin 'mru.vim'
```

## Shortc
```
<leader> is ","
<leader>w to save file
<leader>q to quit

<C-m> : Most Recently Used
<C-f> : Directory Tree
<C-c> : Exit insert mode
```

## Snippets in snipMate

C Snippets:

```c
main
inc
Inc
Def
def
ifdef
#if
once
if
el
t
do
wh
for
forr
fun
fund
td
st
tds
tde
pr
fpr
.
un
```

Shell Snippets:

```sh
if
elif
for
wh
until
case
```

Python Snippets:

```python
imp
docs
wh
for
cl
def
deff
defs
property
ld
.
try
ifmain
_
```

CPP Snippets:

```cpp
readfile
map
vector
ns
cl
```

Tex Snippets:

```tex
begin
tab
ali
gat
eq
\
enum
item
desc
mat
cas
spl
part
cha
sec
sub
subs
par
subp
itd
figure
table
listing
section
page
```
