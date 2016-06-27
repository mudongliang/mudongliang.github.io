---
layout: post
title: "FAQ/Dowhile0"
date: 2015-06-17
description: ""
category: 
tags: []
---

From [http://kernelnewbies.org/FAQ/DoWhile0](http://kernelnewbies.org/FAQ/DoWhile0)

Why do a lot of `#defines` in the kernel use `do { ... } while(0)`?

There are a couple of reasons:

**(from Dave Miller)** Empty statements give a warning from the compiler so this is why you see #define FOO do { } while(0).
    
**(from Dave Miller)** It gives you a basic block in which to declare local variables.

**(from Ben Collins)** It allows you to use more complex macros in conditional code. Imagine a macro of several lines of code like:

    #define FOO(x) \
            printf("arg is %s\n", x); \
            do_something_useful(x);

    Now imagine using it like:

    if (blah == 2)
            FOO(blah);

    This interprets to:

    if (blah == 2)
            printf("arg is %s\n", blah);
            do_something_useful(blah);;

As you can see, the if then only encompasses the printf(), and the do_something_useful() call is unconditional (not within the scope of the if), like you wanted it. So, by using a block like do { ... } while(0), you would get this:

    if (blah == 2)
            do {
                    printf("arg is %s\n", blah);
                    do_something_useful(blah);
            } while (0);

    Which is exactly what you want.

**(from Per Persson)** As both Miller and Collins point out, you want a block statement so you can have several lines of code and declare local variables. But then the natural thing would be to just use for example:

    #define exch(x,y) { int tmp; tmp=x; x=y; y=tmp; }

However that wouldn't work in some cases. The following code is meant to be an if-statement with two branches:

    if (x > y)
            exch(x,y);          // Branch 1
    else  
            do_something();     // Branch 2

    But it would be interpreted as an if-statement with only one branch:

    if (x > y) {                // Single-branch if-statement!!!
            int tmp;            // The one and only branch consists
            tmp = x;            // of the block.
            x = y;
            y = tmp;
    }
    ;                           // empty statement
    else                        // ERROR!!! "parse error before else"
            do_something();

The problem is the semi-colon (;) coming directly after the block. The solution for this is to sandwich the block between do and while (0). Then we have a single statement with the capabilities of a block, but not considered as being a block statement by the compiler. Our if-statement now becomes:

    if (x > y)
            do {
                    int tmp;
                    tmp = x;
                    x = y;
                    y = tmp;
            } while(0);
    else
            do_something();

**(from Bart Trojanowski)** gcc adds Statement-Expressionswhich provide an alternative to the do-while-0 block. They provide the above mentioned benefits and are slightly more legible.

    #define FOO(arg) ({         \
               typeof(arg) lcl; \
               lcl = bar(arg);  \
               lcl;             \
        })

