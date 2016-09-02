---
layout: post
title: "update grub 命令解析"
date: 2016-09-02
description: ""
category: 
tags: []
---

今天在讨论的时候碰见了update-grub这个命令，才发现原来这个命令是Ubuntu特有的。

除了Ubuntu及其衍生版，其他发行版都没有。

要说，这个命令是一个什么呢。我在LinuxMint17上面做一个简单的实验，来查看一下这个命令。

    $ which update-grub
    /usr/sbin/update-grub
    
    $ file `which update-grub`
    /usr/sbin/update-grub: POSIX shell script, ASCII text executable
    
    $ cat `which update-grub`
    #!/bin/sh
    set -e
    exec grub-mkconfig -o /boot/grub/grub.cfg "$@"

原来这个命令是一个简单的 shell 脚本，其中是对于 grub-mkconfig 命令的简单封装。经过了解， grub-mkconfig 是 grub 提供的命令，各个发行版均可使用。

另外解释一下， exec ， source 和 fork 的区别：

1. fork (/directory/script.sh) ：如果 shell 中包含执行命令，那么子命令并不影响父级的命令，在子命令执行完后再执行父级命令。子级的环境变量不会影响到父级。

    fork是最普通的, 就是直接在脚本里面用 /directory/script.sh 来调用 script.sh 这个脚本. 运行的时候开一个 sub-shell 执行调用的脚本， sub-shell 执行的时候,  parent-shell 还在。sub-shell执行完毕后返回 parent-shell 。 sub-shell 从 parent-shell 继承环境变量.但是 sub-shell 中的环境变量不会带回 parent-shell 。整个执行的过程是 fork + exec + waitpid (此三者均为系统调用)。

2. exec (exec /directory/script.sh) ：执行子级的命令后，不再执行父级命令。

    exec 与 fork 不同，不需要新开一个 sub-shell 来执行被调用的脚本.  被调用的脚本与父脚本在同一个 shell 内执行。但是使用 exec 调用一个新脚本以后, 父脚本中 exec 行之后的内容就不会再执行了。这是 exec 和 source 的区别。

3. source (source /directory/script.sh) ：执行子级命令后继续执行父级命令，同时子级设置的环境变量会影响到父级的环境变量。
