---
layout: post
title: "subprocess do not use exec _exit in vfork"
date: 2015-05-23
description: ""
category: 
tags: []
---

# vfork中子进程未使用exec或_exit

linux编译错误__new_exitfn: Assertion `l != ((void *)0)' failed    
创建进程：fork(), vfork()

- fork()：创建进程后返回两个值，分别将子进程pid返回给父进程，将0返回给子进程。子进程完全复制 父进程的资源，并独立于父进程，有良好的并发性。
- vfork()：同上返回两个值，区别在于vfork()子进程共享父进程的地址空间，即子进程运行在父进程的地址空间上，子进程对数据的修改父进程同样能看到。特别注意，使用vfork() 时子进程中需调用exec 或exit 父进程才可能被调度运行，如果在调用exec 或 exit之前子进程要依赖父进程的的某个行为，则会造成死锁。

```sh
int main() {
	pid_t pid=vfork();
	if(pid==0) {
	    printf("i am the child process, my process id is %d\n",getpid());
	    printf("我是爹的儿子\n");//对某些人来说中文看着更直白
	}
	else if (pid > 0) {
	    printf("i am the parent process, my process id is %d\n",getpid());
		printf("我是孩子他爹\n");
		//_exit(0); //可以去man vfork去寻找这一行的作用，没有这样会出问题
	}
	else {
	    fprintf(stderr,"can't fork ,error %d\n",errno);
	    exit(1);
	}  
	return 0;
}
```
结果为:

```sh
i am the child process, my process id is 9909
我是爹的儿子
i am the parent process, my process id is 9908
我是孩子他爹
vfork: cxa_atexit.c:100: __new_exitfn: Assertion `l != ((void *)0)' 
failed.
Aborted
```

这种错误的一个原因是由于子进程中没有调用_exit 或 exec!
下面是man vfork中的一部分内容！

```
Standard description 
    (From POSIX.1) The vfork() function has the same effect as 
	fork(2), except that the behavior is undefined if the process 
	created by vfork() either modifies any data other than a variable
	of type pid_t used to store the return value from vfork(), or 
	returns from the function in which vfork() was called, or calls
	any other function before successfully calling _exit(2) or one 
	of the exec(3) family of functions.
```
