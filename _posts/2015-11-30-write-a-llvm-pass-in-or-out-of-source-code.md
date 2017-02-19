---
layout: post
title: "Write a LLVM Pass In or Out of Source Code"
date: 2015-11-30
description: ""
category: 
tags: []
---


1.当在源代码内的时候，我们可以使用[WritingAnLLVMPass](http://llvm.org/docs/WritingAnLLVMPass.html);

所有的`LLVM passes`是`Pass`类的子类，通过重载从`Pass`继承得到的虚方法来实现相应功能。根据你的`pass`工作方式，你应该从`ModulePass`, `CallGraphSCCPass`, `FunctionPass`, `LoopPass`, `RegionPass`, `BasicBlockPass`类继承。而`FunctionPass`和`BasicBlockPass`类是比较重要的类。

关于在源代码内部的时候，请看`lib/Transforms/Hello/`中的样例。`Hello Pass`仅用于打印非外部的，存在于被编译的程序中的函数。它一点也不修改程序，只是检查程序而已。

你需要先添加下列的头文件：

```cpp
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;
namespace {
struct Hello : public FunctionPass {
//一个继承于FunctionPass的新类Hello

static char ID;
Hello() : FunctionPass(ID) {}
    bool runOnFunction(Function &F) override {
      errs() << "Hello: ";
      errs().write_escaped(F.getName()) << "\n";
      return false;
    }
  }; // end of struct Hello
}  // end of anonymous namespace
```

We declare a runOnFunction method, which overrides an abstract virtual method inherited from FunctionPass. This is where we are supposed to do our thing, so we just print out our message with the name of each function.

我们声明一个方法：`runOnFunction`，重载继承于`FunctionPass`的虚方法。它的功能就是打印程序中的每一个函数。

```cpp
char Hello::ID = 0;
static RegisterPass<Hello> X("hello", "Hello World Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
```

我们注册我们的类`Hello`，给予一个命令行参数 “hello”，以及名字 “Hello World Pass”。

从整体来看，这个文件就如下所示：

```cpp
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
  struct Hello : public FunctionPass {
    static char ID;
    Hello() : FunctionPass(ID) {}

    bool runOnFunction(Function &F) override {
      errs() << "Hello: ";
      errs().write_escaped(F.getName()) << '\n';
      return false;
    }
  };
}

char Hello::ID = 0;
static RegisterPass<Hello> X("hello", "Hello World Pass");
```

使用`opt`来运行一个`pass`：

```sh
$ opt -load ../lib/LLVMHello.so -help

-hello     - Hello World Pass
-hello2    - Hello World Pass (with getAnalysisUsage implemented)
```

而这些选项是从下面的命令行参数注册而来的。

```cpp
static RegisterPass<Hello> X("hello", "Hello World Pass");
static RegisterPass<Hello2> Y("hello2", "Hello World Pass (with getAnalysisUsage implemented)");
```

```sh
$ opt -load ../lib/LLVMHello.so -hello < hello.bc > /dev/null
$ opt -load ../lib/LLVMHello.so -hello2 < hello.bc > /dev/null
Hello: inner
Hello: myfun
Hello: main
```

2.当在源代码外的时候，我们可以使用 [cmake-out-of-source-pass](http://llvm.org/docs/CMake.html#cmake-out-of-source-pass)。

![Front End, Passes, Back End]({{site.url}}/images/compiler-arch.svg)

一个项目的布局如下所示：

```
<project dir>/
    |
    CMakeLists.txt
    <pass name>/
        |
        CMakeLists.txt
        Skeleton.cpp
<project dir>中的CMakeLists.txt的内容如下所示：

find_package(LLVM REQUIRED CONFIG)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(<pass name>)
<project dir>/<pass name>/CMakeLists.txt的内容如下所示：

add_library(LLVMPassname MODULE Pass.cpp)
```

还有就是一篇写的，我认为很不错的博文，[http://adriansampson.net/blog/llvm.html](http://adriansampson.net/blog/llvm.html)是介绍如何写源代码外的pass; [http://adriansampson.net/blog/clangpass.html](http://adriansampson.net/blog/clangpass.html)则是介绍如何编写以及编译源代码外的pass；并且这篇博文的作者还写一个库来展示：[https://github.com/sampsyo/llvm-pass-skeleton](https://github.com/sampsyo/llvm-pass-skeleton)。

关于在源代码外部的时候，请看这个库里面的文件，同时参考博文中的关于这些文件的描述。我将master分支中的Skeleton.cpp拿出来看一下这个模式：

```cpp
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
using namespace llvm;

namespace {
  struct SkeletonPass : public FunctionPass {
    static char ID;
    SkeletonPass() : FunctionPass(ID) {}

    virtual bool runOnFunction(Function &F) {
      errs() << "I saw a function called " << F.getName() << "!\n";
      return false;
    }
  };
}

char SkeletonPass::ID = 0;
static void registerSkeletonPass(const PassManagerBuilder &,
                         legacy::PassManagerBase &PM) {
  PM.add(new SkeletonPass());
}
static RegisterStandardPasses
  RegisterMyPass(PassManagerBuilder::EP_EarlyAsPossible,
                 registerSkeletonPass);
```

而运行这个 pass 我们需要的是以下的命令：

```sh
$ clang -Xclang -load -Xclang build/skeleton/libSkeletonPass.so test.c
```
