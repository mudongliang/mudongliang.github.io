---
layout: post
title: "Linux 内核之 Module 编写（一）"
date: 2015-10-06
description: ""
category: 
tags: []
---

Linux内核编译耗时巨大，模块机制很好用，因为它有助于缩短模块的开发周期：我们可以测试新驱动的一系列功能，却不需要每次都经过冗长的关机/开机操作。

LINUX的模块主要由6部分组成：

1、**模块的加载函数（必须）**

当通过insmod命令加载内核模块时，模块的加载函数会自动被内核执行，完成本模块的相关初始化工作。

2、**模块的卸载函数（必须）**

当通过rmmod命令卸载某模块时，模块的卸载函数会自动被内核执行，完成与模块加载函数相反的功能。

3、模块许可证声明

模块许可证（LICENSE）声明描述内核模块的的许可权限，如果不声明LICENSE,模块被加载时，将接到内核被污染的警告。

4、模块参数（可选）

模块参数是模块被加载的时候可以被传递给它的值，它本身对应模块内部的全局变量。

5、模块导出符号（可选）

内核模块可以导出符号(symbol,对应于函数或者是变量），这样其他模块就可以使用本模块中的变量或者是函数。

6、模块作者等信息声明（可选）

知道了LINUX模块的组成后，我们来编写一个简单的LINUX内核模块HelloWorld。

[Source Code in Github](https://github.com/mudongliang/CLanguageReview/tree/master/KernelModule/helloworld)

```
#include <linux/module.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("mudongliangabcd@gmail.com");
MODULE_DESCRIPTION("HelloWorld Module Template");
MODULE_VERSION("0.1");

static int __init moduletest_init(void)
{
    printk(KERN_ALERT "Hello,World");
    return 0;
}

static void __exit moduletest_exit(void)
{
    printk(KERN_ALERT "Goodbye,World!");
}

module_init(moduletest_init);
module_exit(moduletest_exit);
```

当然，你还需要`Makefile`：

**Version 1：**

```
obj-m := HelloWorld.o
all:
   make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules
clean:
   make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean
```

**Version 2：**

```
TARGET=HelloWorld
obj-m := $(TARGET).o

KDIR=/lib/modules/$(shell uname -r)/build
PWD=$(shell pwd)

default:
    make -C $(KDIR) M=$(PWD) modules
install:
    insmod $(TARGET).ko
uninstall:
    rmmod $(TARGET).ko
clean:
    make -C $(KDIR) M=$(PWD) clean
```

利用版本2，你可以通过一下命令来编译，删除，加载，卸载这个模块：

```
[mdl@mdl helloworld]$ make 
make -C /lib/modules/4.2.2-1-ARCH/build M=/home/mdl/Repos/Github/CLanguageReview/helloworld modules
make[1]: Entering directory '/usr/lib/modules/4.2.2-1-ARCH/build'
  CC [M]  /home/mdl/Repos/Github/CLanguageReview/helloworld/HelloWorld.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/mdl/Repos/Github/CLanguageReview/helloworld/HelloWorld.mod.o
  LD [M]  /home/mdl/Repos/Github/CLanguageReview/helloworld/HelloWorld.ko
make[1]: Leaving directory '/usr/lib/modules/4.2.2-1-ARCH/build'
```

```
[mdl@mdl helloworld]$ sudo make install
[sudo] password for mdl: 
insmod HelloWorld.ko
```
```
[mdl@mdl helloworld]$ sudo make uninstall
rmmod HelloWorld.ko
[mdl@mdl helloworld]$ make clean
make -C /lib/modules/4.2.2-1-ARCH/build M=/home/mdl/Repos/Github/CLanguageReview/helloworld clean
make[1]: Entering directory '/usr/lib/modules/4.2.2-1-ARCH/build'
  CLEAN   /home/mdl/Repos/Github/CLanguageReview/helloworld/.tmp_versions
  CLEAN   /home/mdl/Repos/Github/CLanguageReview/helloworld/Module.symvers
make[1]: Leaving directory '/usr/lib/modules/4.2.2-1-ARCH/build'
```

