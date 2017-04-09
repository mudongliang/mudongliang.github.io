---
layout: post
title: "soundness vs completeness"
date: 2017-04-09
description: ""
category: 
tags: []
---

### Theory

For example,

A **positive** program is a program with an error.

A **negative** program is a program without an error.

So there are four types of programms:

A **positive** program, analysed as **positive** -> `true positive` (**TP**).

A **positive** program, analysed as **negative** -> `false negative` (**FN**).

A **negative** program, analysed as **positive** -> `false positive` (**FP**).

A **negative** program, analysed as **negative** -> `true negative` (**TN**).

A system is sound, if it never accepts a false positive program.
A system is complete, if it never accepts a false negative program.

In one word, `Soundness prevents false negatives and completeness prevents false positives.` 

### Example One

Let's say a house owners set up alarm systems to detect thieves. The owner who dislikes false alarm due to other causes than illegal intrusion makes the system less sensitive, in this case, when the alarm sounds, it means "alarm means there is an intruder" with the danger of not detecting skillful thieves. The careful and cautious owner who can live with the false alarm but never wants the intrusion maybe make the system more sensitive. In this case, "no alarm means there is no intrusion".

The first system that never accepts the false positive (false alarm, in this example) is called sound system. The second system that never misses the intrusion, in other words, never accepts the false negative, is called complete system. Soundness does not guarantee completeness, and vice versa. With perfect sensitivity of the alarm system, there is no false alarm nor missing intrusion to make the system sound and complete.

### Example Two

In modern languages, type systems are sound (they prevent what they claim to) but not complete (they reject programs they need not reject). Soundness is important because it lets language users and language implementers rely on X never happening. Completeness would be nice, but hopefully it is rare in practice that a program is rejected unnecessarily and in those cases, hopefully it is easy for the programmer to modify the program such that it type-checks.
