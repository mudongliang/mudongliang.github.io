---
layout: post
title: "Some explanation of syz repro"
date: 2021-04-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

## repro.go
Repro.go has three configurable parameters - config, count, debug.
```go
flagConfig  = flag.String("config", "", "manager configuration file (manager.cfg)")
flagCount  = flag.Int("count", 0, "number of VMs to use (overrides config count param)")
flagDebug  = flag.Bool("debug", false, "print debug output")
```
In `L34`, it loads config file from `flagConfig`.
In `L38`, it fetches the first argument, e.g., the log file provided and read the data from this file.
In `L46` to `L60`, it initializes virtual machine setting based on `flagDebug` and `vmCount`.
In `L61`, it creates one new reporter. Its implementation is in `pkg/report/report.go:84`. Here I don't quite understand the meaning of  `compileRegexps`. However, the return value is `reportWrapper`. Its definition is as follows:
```go
type  reporterWrapper  struct {
	Reporter
	suppressions []*regexp.Regexp
	typ string
}
```
And the first field in `reportWrapper` is one anonymous filed and it is created by `ctor` or `ctroLinux` in Linux OS.
In `L67`, it directly call `repro.Run` to execute data extracting from syzkaller log.
```go
res, stats, err  := repro.Run(data, cfg, reporter, vmPool, vmIndexes)
```
This function is defined in `pkg/repro/repro.go:62`.
In `L71`, it first extracts the corresponding entries in the crash log.
In `L77`, crash log is parsed by reporter created before. The concrete implementation of `reporter.Parse` for Linux OS is in `pkg/report/linux.go:131`. It should be noted that Symbolize is used to transform call trace in binary format to source code format. The magic is nothing but `addr2line`.
In `L100`, it prepares one ctx with context type. Then it starts those vms in the vm pool, copies syz-executor, syz-execprog to target vm.
In `L174`, it calls `ctx.repro` to reproduce the crash based on this context.

In the following, `repro` is defined in `L200` of the same file. Next, in this function, it will sequentially call `ctx.extractProg`, `ctx.minimizeProg`, `ctx.extractC`, `ctx.simplifyProg`/`ctx.simplifyC`. And all those functions are all defined in the same file.
We only care about the first part - `ctx.extractProg(pkg/repor/repro.go:256)`.
In `L265`, it first extracts the last program on every Proc. (The first loop gets the relationship between proc and entry index. The second loop adds all the indexes to one list. The third loop organizes those into another list)
```go
// Extract last program on every proc.
procs := make(map[int]int)
for i, ent := range entries {
    procs[ent.Proc] = i
}
var indices []int
for _, idx := range procs {
    indices = append(indices, idx)
}
sort.Ints(indices)
var lastEntries []*prog.LogEntry
for i := len(indices) - 1; i >= 0; i-- {
    lastEntries = append(lastEntries, entries[indices[i]])
}
```
In `L280`, it leverages `ctx.extractProgSingle` to execute the reversed entries obtained in the previous step.
In `ctx.extractProgSingle(pkg/repro/repro.go:309)`, it traverses the entry list and tests each program with `ctx.testProg` in the virtual machine.
In `ctx.extractProgBisect(pkg/repro/repro.go:342)`, it selects/bisects multiple guilty programs with `ctx.bisectProgs` that has the corresponding detail of bisection. Finally, it will concatenate those programs into one. For the merged program, it first tries to reproduce without fault injection. If it does not work, then fault injection will be facilitated to reproduce this crash.
In addition, let me introduce some details of `testProg`, it is a special case for `testProgs`. In this function, it encodes all the entries, and writes the result into one file. Following, it copies this file into the virtual machine. Finally, it will
 calls syz-execprog to try to reproduce newly captured crashs.
```go
command  := instancePkg.ExecprogCmd(inst.execprogBin, inst.executorBin,
ctx.cfg.TargetOS, ctx.cfg.TargetArch, opts.Sandbox, opts.Repeat,
opts.Threaded, opts.Collide, opts.Procs, -1, -1, vmProgFile)
ctx.reproLog(2, "testing program (duration=%v, %+v): %s", duration, opts, program)
ctx.reproLog(3, "detailed listing:\n%s", pstr)
return ctx.testImpl(inst.Instance, command, duration)
```
At the same time, 

```go
func (ctx *context) testImpl(inst *vm.Instance, command string, duration time.Duration) (crashed bool, err error) {
	outc, errc, err  := inst.Run(duration, nil, command)
	if err !=  nil {
		return  false, fmt.Errorf("failed to run command in VM: %v", err)
	}
	rep  := inst.MonitorExecution(outc, errc, ctx.reporter,
	vm.ExitTimeout|vm.ExitNormal|vm.ExitError)
......
```
For our situation, our vm type is "qemu". Then `inst.Run` and `inst.MointorExecution` are implemented in `vm/qemu/qemu.go`.
