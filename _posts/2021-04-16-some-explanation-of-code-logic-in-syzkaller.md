---
layout: post
title: "Some explanation of code logic in syzkaller"
date: 2021-04-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Main code logic of syzkaller

All the code in the following is in the version : [dce6e62ffce4b315ab41407813f0257ced29903f](https://github.com/google/syzkaller/tree/dce6e62ffce4b315ab41407813f0257ced29903f)

The main logic of syzkaller is as follows, borrowed from [internals.md](https://github.com/google/syzkaller/blob/5c6bf6c55f03f8b5555d5b8d0ccc4cbb18073ce9/docs/internals.md).

![internal mechanism](https://raw.githubusercontent.com/google/syzkaller/5c6bf6c55f03f8b5555d5b8d0ccc4cbb18073ce9/docs/process_structure.png)

## manager.go
```go
flagConfig  = flag.String("config", "", "configuration file")
flagDebug  = flag.Bool("debug", false, "dump all VM output to console")
flagBench  = flag.String("bench", "", "write execution statistics into this file periodically")
```
In `main` function, it first prepares something and then run manager in the previous figure.
In `L117`, I am not very sure about the meaning of `maxLine` - 1000. Originally I think it's the length of output log, but it seems incorrect.
In `L130`, it calls `PraseEnabledSyscalls` to parse enabled syscalls from the configuration file.
Then control flow comes to `RunManager(manager.go:137)`. Next is `vmLoop(manager.go:287)`. In `L346`, it calls `repro.Run` to reproduce the queue of crashes that need to reproduce - `reproQueue`. It should be noted that this is exactly the same callsite with syz-repro tool.
So when fuzzer is started to fuzzing the corresponding kernel? The answer is in `manager.go:L356`. 
```go
go  func() {
	crash, err  := mgr.runInstance(idx)
	runDone <-  &RunResult{idx, crash, err}
}()
```
The actual code of `mgr.runInstance` is in the `manager.go:508`. It would complete the following tasks:
- create one vm
- setup port forwarding
- copy fuzzer and executor binary
- start fuzzer binary and moniter its execution

### Code logic of fuzzer

Next, let me show some brief introduction to the logic of fuzzer.

In the main function of `fuzzer.go`, it inits and calls prog.loop() according to the flagProcs (flagProcs specified by user).
```go
	for pid := 0; pid < *flagProcs; pid++ {
		proc, err := newProc(fuzzer, pid)
		if err != nil {
			log.Fatalf("failed to create proc: %v", err)
		}
		fuzzer.procs = append(fuzzer.procs, proc)
		go proc.loop()
	}
```
The loop() is in syz-fuzzer/proc.go. It generates or mutates syscall sequences and calls `proc.execute` send data to executor to run syscalls.
```go
func (proc *Proc) loop() {
	......
	for  i  :=  0; ; i++ {
		......
		ct  := proc.fuzzer.choiceTable
		corpus  := proc.fuzzer.corpusSnapshot()
		if  len(corpus) ==  0  || i%generatePeriod ==  0 {
			// Generate a new prog.
			p  := proc.fuzzer.target.Generate(proc.rnd, programLength, ct)
			log.Logf(1, "#%v: generated", proc.pid)
			proc.execute(proc.execOpts, p, ProgNormal, StatGenerate)
		} else {
			// Mutate an existing prog.
			p  := corpus[proc.rnd.Intn(len(corpus))].Clone()
			p.Mutate(proc.rnd, programLength, ct, corpus)
			log.Logf(1, "#%v: mutated", proc.pid)
			proc.execute(proc.execOpts, p, ProgNormal, StatFuzz)
		}
	}
}
```
The proc.execute execute chain is as follows:
 `proc.execute -> executeRaw -> env.Exec`. And `env.Exec` is defined in the `ipc.go`. So the same process as `syz-execproc`.

