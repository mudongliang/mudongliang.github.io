---
layout: post
title: "Shell Find out one variable exists or is not empty"
date: 2020-09-13
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Example

The following is a script to demonstrate the various possibilities with bash/sh/posix based shell:

```
#!/bin/bash
JAIL="/nginx"
HINT=""
# Do three possibilities for $JAIL ##
for i in 1 2 3 
do
case $i in
	1) JAIL="/nginx/jail"; HINT="value set";;
	2) JAIL=""; HINT="value set to empty string";;
	3) unset JAIL; HINT="\$JAIL unset";;
esac
 
###############################################
# Update user with actual values and action  
# $JAIL set to a non-empty string (1)
# $JAIL set to the empty string  (2)
# $JAIL can be unset (3)
################################################
echo "*** Current value of \$JAIL is '$JAIL' ($HINT) ***"
 
## Determine if a bash variable is empty or not ##
if [ -z "${JAIL}" ]; then
    echo "JAIL is unset or set to the empty string"
fi
if [ -z "${JAIL+set}" ]; then
    echo "JAIL is unset"
fi
if [ -z "${JAIL-unset}" ]; then
    echo "JAIL is set to the empty string"
fi
if [ -n "${JAIL}" ]; then
    echo "JAIL is set to a non-empty string"
fi
if [ -n "${JAIL+set}" ]; then
    echo "JAIL is set, possibly to the empty string"
fi
if [ -n "${JAIL-unset}" ]; then
    echo "JAIL is either unset or set to a non-empty string"
fi
done
```
