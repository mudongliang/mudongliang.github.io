---
layout: post
title: "Some explanation of syz execprog"
date: 2021-04-16
description: ""
category: 
tags: []
---
* TOC
{:toc}

# Explanation of execprog
All the code in the following is in the version : [dce6e62ffce4b315ab41407813f0257ced29903f](https://github.com/google/syzkaller/tree/dce6e62ffce4b315ab41407813f0257ced29903f)

## execprog.go
First, options of syz-execprog are from three go files: exeprog.go, ipcconfig.go, log.go.
```go
var (
	flagOS = flag.String("os", runtime.GOOS, "target os")
	flagArch = flag.String("arch", runtime.GOARCH, "target arch")
	flagCoverFile = flag.String("coverfile", "", "write coverage to the file")
	flagRepeat = flag.Int("repeat", 1, "repeat execution that many times (0 for infinite loop)")
	flagProcs = flag.Int("procs", 1, "number of parallel processes to execute programs")
	flagOutput = flag.Bool("output", false, "write programs and results to stdout")
	flagHints = flag.Bool("hints", false, "do a hints-generation run")
	flagFaultCall = flag.Int("fault_call", -1, "inject fault into this call (0-based)")
	flagFaultNth = flag.Int("fault_nth", 0, "inject fault on n-th operation (0-based)")
	flagEnable = flag.String("enable", "none", "enable only listed additional features")
	flagDisable = flag.String("disable", "none", "enable all additional features except listed")
)
```
```go
var (
	flagExecutor = flag.String("executor", "./syz-executor", "path to executor binary")
	flagThreaded = flag.Bool("threaded", true, "use threaded mode in executor")
	flagCollide  = flag.Bool("collide", true, "collide syscalls to provoke data races")
	flagSignal   = flag.Bool("cover", false, "collect feedback signals (coverage)")
	flagSandbox  = flag.String("sandbox", "none", "sandbox for fuzzing (none/setuid/namespace/android_untrusted_app)")
	flagDebug    = flag.Bool("debug", false, "debug output from executor")
	flagTimeout  = flag.Duration("timeout", 0, "execution timeout")
)
```
```go
var (
	flagV        = flag.Int("v", 0, "verbosity")
)
```
Then we read each go statement from main function.
 In L49, `flag.Parse()` parses all the above options.
 In L54, `csource.ParseFeaturesFlags` is implemented in `pkg/csource/options.go`, it interprets "-enable/-disable".
In L59, [GetTarget](https://github.com/google/syzkaller/blob/dce6e62ffce4b315ab41407813f0257ced29903f/prog/target.go#L74) is used to get current architecture information. It does rely on [`import _ github.com/google/syzkaller/sys`](https://golang.org/ref/spec#Import_declarations).

> An import declaration declares a dependency relation between the importing and imported package. It is illegal for a package to import itself, directly or indirectly, or to directly import a package without referring to any of its exported identifiers. To import a package solely for its side-effects (initialization), use the  [blank](https://golang.org/ref/spec#Blank_identifier)  identifier as explicit package name:
>```go
>import _ "lib/math"
>```
If there is no such identifier, we will get the following error:
```
imported and not used: "github.com/google/syzkaller/sys"
```
For `GetTarget` function, the key is to understand how to initialize targets and `target.init.Do`.
```go
func GetTarget(OS, arch string) (*Target, error) {
	if OS == "android" {
		OS = "linux"
	}
	key := OS + "/" + arch
	target := targets[key]
    ......
	target.init.Do(target.lazyInit)
	return target, nil
}
```
1. How to initialize targets.
Answer: in sys/sys.go, it imports all the supported platforms. Here we only show the detail of linux. In linux/gen, there are six go files - `386.go  amd64.go  arm64.go  arm.go  empty.go  ppc64le.go`. For each file, it is automatically generated. And in `init` function, it uses `RegisterTarget` to register metadata of all the supported platforms into targets.
2. target.init.Do
target.init is with type `sync.Once`. From [the specification of `sync` package](https://golang.org/pkg/sync/#Once.Do), `Do` calls the function `target.lazyInit` if and only if `Do` is being called for the first time for this instance of `Once`. For the concrete initialization process, we don't detail it here.

In L63, `loadPrograms` loads programs from input files(flag.Args() returns the non-flag arguments). In `loadPrograms`, it uses `target.ParseLog` to interpret programs in the input files into specific formats.
Here we only include the data structures from `parse.go` and `prog.go`. Details could be inferred in function `ParseLog`.
```go
// LogEntry describes one program in execution log.
type LogEntry struct {
        P         *Prog
        Proc      int  // index of parallel proc
        Start     int  // start offset in log
        End       int  // end offset in log
        Fault     bool // program was executed with fault injection in FaultCall/FaultNth
        FaultCall int
        FaultNth  int
}
type Prog struct {
        Target   *Target
        Calls    []*Call
        Comments []string
}

type Call struct {
        Meta    *Syscall
        Args    []Arg
        Ret     *ResultArg
        Comment string
}
```
The following is part of syzkaller log. It is one simple program. 
```
2017/08/16 19:44:57 executing program 1:
mmap(&(0x7f0000000000/0xf77000)=nil, 0xf77000, 0x3, 0x32, 0xffffffffffffffff, 0x0)
r0 = socket$netlink(0x10, 0x3, 0x0)
r1 = dup(r0)
```
In L67 and L76, methods of host are firstly ignored.
In L79, `createConfig` is used to generate one `ipc.Config`. In `createConfig`,  it firstly obtain the default configuration from ipcconfig. The following is the definition of `ipc.Config` and `ipc.ExecOpts`.
```go
// Configuration flags for Config.Flags.
type EnvFlags uint64

// Note: New / changed flags should be added to parse_env_flags in executor.cc
const (
	FlagDebug                      EnvFlags = 1 << iota // debug output from executor
	FlagSignal                                          // collect feedback signals (coverage)
	FlagSandboxSetuid                                   // impersonate nobody user
	FlagSandboxNamespace                                // use namespaces for sandboxing
	FlagSandboxAndroidUntrustedApp                      // use Android sandboxing for the untrusted_app domain
	FlagExtraCover                                      // collect extra coverage
	FlagEnableFault                                     // enable fault injection support
	FlagEnableTun                                       // setup and use /dev/tun for packet injection
	FlagEnableNetDev                                    // setup more network devices for testing
	FlagEnableNetReset                                  // reset network namespace between programs
	FlagEnableCgroups                                   // setup cgroups for testing
	FlagEnableBinfmtMisc                                // setup binfmt_misc for testing
	// Executor does not know about these:
	FlagUseShmem      // use shared memory instead of pipes for communication
	FlagUseForkServer // use extended protocol with handshake
)

// Per-exec flags for ExecOpts.Flags:
type ExecFlags uint64

const (
	FlagCollectCover ExecFlags = 1 << iota // collect coverage
	FlagDedupCover                         // deduplicate coverage in executor
	FlagInjectFault                        // inject a fault in this execution (see ExecOpts)
	FlagCollectComps                       // collect KCOV comparisons
	FlagThreaded                           // use multiple threads to mitigate blocked syscalls
	FlagCollide                            // collide syscalls to provoke data races
)

type ExecOpts struct {
	Flags     ExecFlags
	FaultCall int // call index for fault injection (0-based)
	FaultNth  int // fault n-th operation in the call (0-based)
}

// Config is the configuration for Env.
type Config struct {
	// Path to executor binary.
	Executor string

	// Flags are configuation flags, defined above.
	Flags EnvFlags

	// Timeout is the execution timeout for a single program.
	Timeout time.Duration
}
```
For those options, we are more interested in `FlagSandbox*`, `FlagEnable*`, `FlagThreaded`, `FlagCollide`, `FlagInjectFault`(`FaultCall` and `FaultNth`). Besides those flags, we still need to introduce how to decide the features supported by each OS&Architecture.
```go
func Default(target *prog.Target) (*ipc.Config, *ipc.ExecOpts, error) {
	......
	sysTarget := targets.Get(target.OS, target.Arch)
	if sysTarget.ExecutorUsesShmem {
		c.Flags |= ipc.FlagUseShmem
	}
	if sysTarget.ExecutorUsesForkServer {
		c.Flags |= ipc.FlagUseForkServer
	}
	......
}
```
In `ipcconfig.go:40`, it uses `targets.Get` to fetch features supported by each OS&Arch. In `targets.go`, init function is used to initialize the features and the features is set in the `oses`. 
```go
func init() {
	for OS, archs := range List {
		for arch, target := range archs {
			initTarget(target, OS, arch)
		}
	}
	......
}
func initTarget(target *Target, OS, arch string) {
	if common, ok := oses[OS]; ok {
		target.osCommon = common
	}
	target.OS = OS
	target.Arch = arch
	if target.NeedSyscallDefine == nil {
		target.NeedSyscallDefine = needSyscallDefine
	}
	target.DataOffset = 512 << 20
	target.NumPages = (16 << 20) / target.PageSize
	......
}
```
And the features of `linux&amd64` are as follows:
```go
var  List = map[string]map[string]*Target{
	......
	"linux": {
		"amd64": {
			PtrSize:          8,
			PageSize:         4 << 10,
			CFlags:           []string{"-m64"},
			CrossCFlags:      []string{"-m64", "-static"},
			CCompilerPrefix:  "x86_64-linux-gnu-",
			KernelArch:       "x86_64",
			KernelHeaderArch: "x86",
			NeedSyscallDefine: func(nr uint64) bool {
				// Only generate defines for new syscalls
				// (added after commit 8a1ab3155c2ac on 2012-10-04).
				return nr >= 313
			},
		},
		"386": {
			VMArch:           "amd64",
			PtrSize:          4,
			PageSize:         4 << 10,
			CFlags:           []string{"-m32"},
			CrossCFlags:      []string{"-m32", "-static"},
			CCompilerPrefix:  "x86_64-linux-gnu-",
			KernelArch:       "i386",
			KernelHeaderArch: "x86",
		},
		......
	}
	......
}
var oses = map[string]osCommon{
	"linux": {
		SyscallNumbers:         true,
		SyscallPrefix:          "__NR_",
		ExecutorUsesShmem:      true,
		ExecutorUsesForkServer: true,
		KernelObject:           "vmlinux",
		CPP:                    "cpp",
	},
	......
}

```
In L81, it directly initializes one Context object. The declaration of object is as follows:
```go
type Context struct {
	entries   []*prog.LogEntry
	config    *ipc.Config
	execOpts  *ipc.ExecOpts
	gate      *ipc.Gate
	shutdown  chan struct{}
	logMu     sync.Mutex
	posMu     sync.Mutex
	repeat    int
	pos       int
	lastPrint time.Time
}
```
In L89, it uses `sync.WaitGroup` to control the execution of goroutines. We copy the explanation of WaitGroup :
> A WaitGroup waits for a collection of goroutines to finish. The main goroutine calls Add to set the number of goroutines to wait for. Then each of the goroutines runs and calls Done when finished. At the same time, Wait can be used to block until all goroutines have finished.
```go
wg.Add(*flagProcs)
for p := 0; p < *flagProcs; p++ {
	pid := p
	go func() {
		defer wg.Done()
		ctx.run(pid)
	}()
}
```
First, `wg.Add` sets the number of gorountines with `*flagProcs`. Then iterate all the procs and in each loop it invokes one gorountine to run `ctx.run(pid)`. `defer` statement defers the execution of a function until the surrounding function returns.As we show in the beginning, the options of `execprog` are separate into different parts.

---------
syz-execprog中的ctx.run(pid) 先调用了ipc.MakeEnv(ctx.config,pid)，初始化env对象。 env里面包含了所要使用executor的路径和当前pid等信息以及Exec方法。然后run调用ctx.execute(pid,env,entry)，其中entry为某一个program的结构体。
```go
// tools/syz-execprog/execprog.go
func (ctx *Context) run(pid int) {
	env, err := ipc.MakeEnv(ctx.config, pid)
	if err != nil {
		log.Fatalf("failed to create ipc env: %v", err)
	}
	defer env.Close()
	for {
		select {
		case <-ctx.shutdown:
			return
		default:
		}
		idx := ctx.getProgramIndex()
		if ctx.repeat > 0 && idx >= len(ctx.entries)*ctx.repeat {
			return
		}
		entry := ctx.entries[idx%len(ctx.entries)]
		ctx.execute(pid, env, entry)
	}
}
```
In `run` method, it firstly prepares environment variables with `ipc.MakeEnv`. The `Env` is defined by :
```go
type Env struct {
	in  []byte
	out []byte

	cmd       *command
	inFile    *os.File
	outFile   *os.File
	bin       []string
	linkedBin string
	pid       int
	config    *Config

	StatExecs    uint64
	StatRestarts uint64
}
```
In `MakeEnv`(ipc.go:157), it utilizes `CreateMemMappedFile` to mmap a temp file with the requested size and maps it into memory twice, one is input, the other is output. **Note that`CreateMemMappedFile` returns `* os.File`, `[]byte`, and`error`. And `CreateMemMappedFile`'s return values are  named. So you will see there is no explicit variable in return statement.**接下来看ctx.execute()，细节见代码内中文注释
我们可以看到ctx.execute()中调用了env.Exec(callOpts, entry.P)。

## ipc.go
env.Exec(callOpts, entry.P)这个函数位于ipc.go的函数会经过如下调用链
env.Exec 
-> makeCommand 此处在起executor，设置读写管道，
-> env.cmd.exec 往设置好的管道中写progData
```go
func MakeEnv(config *Config, pid int) (*Env, error) {
	var inf, outf *os.File
	var inmem, outmem []byte
	if config.Flags&FlagUseShmem != 0 {
		var err error
		inf, inmem, err = osutil.CreateMemMappedFile(prog.ExecBufferSize)
		......
		outf, outmem, err = osutil.CreateMemMappedFile(outputSize)
		......
	} else {
		inmem = make([]byte, prog.ExecBufferSize)
		outmem = make([]byte, outputSize)
	}
	env := &Env{
		in:      inmem,
		out:     outmem,
		inFile:  inf,
		outFile: outf,
		bin:     strings.Split(config.Executor, " "),
		pid:     pid,
		config:  config,
	}
	......
	// Append pid to binary name.
	// E.g. if binary is 'syz-executor' and pid=15,
	// we create a link from 'syz-executor.15' to 'syz-executor' and use 'syz-executor.15' as binary.
	// This allows to easily identify program that lead to a crash in the log.
	// Log contains pid in "executing program 15" and crashes usually contain "Comm: syz-executor.15".
	base := filepath.Base(env.bin[0])
	pidStr := fmt.Sprintf(".%v", pid)
	const maxLen = 16 // TASK_COMM_LEN is currently set to 16
	if len(base)+len(pidStr) >= maxLen {
		// Remove beginning of file name, in tests temp files have unique numbers at the end.
		base = base[len(base)+len(pidStr)-maxLen+1:]
	}
	binCopy := filepath.Join(filepath.Dir(env.bin[0]), base+pidStr)
	if err := os.Link(env.bin[0], binCopy); err == nil {
		env.bin[0] = binCopy
		env.linkedBin = binCopy
	}
	inf = nil
	outf = nil
	return env, nil
}
```
From the comment, we could see, usually **Log contains pid in "executing program 15" and crashes usually contain "Comm: syz-executor.15"**. This could be a good tip for reproduction.
`getProgramIndex` obtains `pos` field value in `Context` with lock. And then fetch the corresponding entry from entries. Finally it executes the entry or single program with `ctx.execute(pid, env, entry)`.
In L136(`execute`), it firstly logs single program to execute with `ctx.logProgram`, then executes program with`env.Exec(callOpts, entry.P)`, and print the output of program execution finally. 
```go
func (ctx *Context) execute(pid int, env *ipc.Env, entry *prog.LogEntry) {
	......(ctx *Context) execute(pid int, env *ipc.Env, entry *prog.LogEntry) {
	// Limit concurrency window.
	ticket := ctx.gate.Enter()
	defer ctx.gate.Leave(ticket)

	callOpts := ctx.execOpts
	if *flagFaultCall == -1 && entry.Fault {
		newOpts := *ctx.execOpts
		newOpts.Flags |= ipc.FlagInjectFault
		newOpts.FaultCall = entry.FaultCall
		newOpts.FaultNth = entry.FaultNth
		callOpts = &newOpts
	}
	if *flagOutput {
		// 此处logs single program to execute了将要执行的program，log的时候会用锁
		ctx.logProgram(pid, entry.P, callOpts)
	}
	//env.Exec executes single program on the machine真正执行了当前program
	output, info, hanged, err := env.Exec(callOpts, entry.P)
	if ctx.config.Flags&ipc.FlagDebug != 0 || err != nil {
		log.Logf(0, "result: hanged=%v err=%v\n\n%s", hanged, err, output)
	}
	if info != nil {
		// print execution result
		ctx.printCallResults(info)
		if *flagHints {
			ctx.printHints(entry.P, info)
		}
		if *flagCoverFile != "" {
			// dump code coverage
			ctx.dumpCoverage(*flagCoverFile, info)
		}
	} else {
		log.Logf(1, "RESULT: no calls executed")
	}
}
```
`env.Exec` is defined in `pkg/ipc/ipc.go:247`.  We will discuss about its logic flow in the following section.

## ipc.go
`env.Exec(callOpts, entry.P)` is the key function that executes one single program.
```go
func (env *Env) Exec(opts *ExecOpts, p *prog.Prog) (output []byte, info *ProgInfo, hanged bool, err0 error) {
	// Copy-in serialized program.
	progSize, err := p.SerializeForExec(env.in)
	if err != nil {
		err0 = fmt.Errorf("failed to serialize: %v", err)
		return
	}
	var progData []byte
	if env.config.Flags&FlagUseShmem == 0 {
		progData = env.in[:progSize]
	}
	......
	if env.cmd == nil {                                                                                                                                                                               
		......
		env.cmd, err0 = makeCommand(env.pid, env.bin, env.config, env.inFile, env.outFile, env.out)
		......
	}
	output, hanged, err0 = env.cmd.exec(opts, progData)
	......
	info, err0 = env.parseOutput(p)
	......
	return
}
```
In L272, `Exec` will firstly call `makeCommand` to prepare `command` data structure. and then execute the program on the virtual machine. Finally it will parse the output of this program.
In L521,`makeCommand` opens three pipes for output, executor->ipc, ipc->executor. From  [godoc](https://golang.org/pkg/os/#Pipe) of `Pipe`,
```go
func Pipe() (r *File, w *File, err error)
// Pipe returns a connected pair of Files;
// reads from r return bytes written to w.
// It returns the files and an error, if any.
```
Take the output capture pipe as example, if we write some data to `wp`, then we could get the data from `rp`.  This kind of pipe is used to communicate between processes.
And then those pipes fill many fields of `command` data structure.
```go
func makeCommand(pid int, bin []string, config *Config, inFile, outFile *os.File, outmem []byte) (*command, error) {
	......
	c := &command{
		pid:     pid,
		config:  config,
		timeout: sanitizeTimeout(config),
		dir:     dir,
		outmem:  outmem,
	}
	......
	// Output capture pipe.
	rp, wp, err := os.Pipe()
	if err != nil {
		return nil, fmt.Errorf("failed to create pipe: %v", err)
	}
	defer wp.Close()

	// executor->ipc command pipe.
	inrp, inwp, err := os.Pipe()
	if err != nil {
		return nil, fmt.Errorf("failed to create pipe: %v", err)
	}
	defer inwp.Close()
	c.inrp = inrp

	// ipc->executor command pipe.
	outrp, outwp, err := os.Pipe()
	if err != nil {
		return nil, fmt.Errorf("failed to create pipe: %v", err)
	}
	defer outrp.Close()
	c.outwp = outwp
	......
	cmd := osutil.Command(bin[0], bin[1:]...)
	if inFile != nil && outFile != nil {
		cmd.ExtraFiles = []*os.File{inFile, outFile}
	}
	cmd.Env = []string{}
	cmd.Dir = dir
	cmd.Stdin = outrp
	cmd.Stdout = inwp
	......
	if err := cmd.Start(); err != nil {
		return nil, fmt.Errorf("failed to start executor binary: %v", err)
	}
	c.cmd = cmd
	wp.Close()
	// Note: we explicitly close inwp before calling handshake even though we defer it above.
	// If we don't do it and executor exits before writing handshake reply,
	// reading from inrp will hang since we hold another end of the pipe open.
	inwp.Close()
	......
	tmp := c
	c = nil // disable defer above
	return tmp, nil
}
```
In `osutil/osutil.go:73`, `Command` function returns `exec.Cmd`. `Command` is a simple wrapper of `exec.Command`. And then `cmd` assigns its stdin/stdout input with `outrp/inwp`.
```go
// Command is similar to os/exec.Command, but also sets PDEATHSIG on linux.
func Command(bin string, args ...string) *exec.Cmd {
	cmd := exec.Command(bin, args...)
	setPdeathsig(cmd)
	return cmd
}
```
```go
type Cmd struct {
        // Path is the path of the command to run.
        Path string

        // Args holds command line arguments, including the command as Args[0].
        // In typical use, both Path and Args are set by calling Command.
        Args []string
		......
        // Stdin specifies the process's standard input.
        Stdin io.Reader

        // Stdout and Stderr specify the process's standard output and error.
        Stdout io.Writer
        Stderr io.Writer

        // ExtraFiles specifies additional open files to be inherited by the
        // new process. It does not include standard input, standard output, or
        // standard error. If non-nil, entry i becomes file descriptor 3+i.
        ExtraFiles []*os.File
        ......
}
```
From the specification of `ExtraFiles`, we know `inFile` and `outFile` are with fd 3 and fd 4, respectively.
In L612, `cmd.Start()` starts the specified command but does not wait for it to complete.
In L705, `exec` feeds/writes program data to the pipe (ipc->executor), then reads output of each proram from the pipe (executor->ipc).
For the handshake and fork server, we could refer to [afl fork server](http://lcamtuf.coredump.cx/afl/technical_details.txt).
```go
func (c *command) exec(opts *ExecOpts, progData []byte) (output []byte, hanged bool, err0 error) {
	req := &executeReq{
		magic:     inMagic,
		envFlags:  uint64(c.config.Flags),
		execFlags: uint64(opts.Flags),
		pid:       uint64(c.pid),
		faultCall: uint64(opts.FaultCall),
		faultNth:  uint64(opts.FaultNth),
		progSize:  uint64(len(progData)),
	}
	reqData := (*[unsafe.Sizeof(*req)]byte)(unsafe.Pointer(req))[:]
	if _, err := c.outwp.Write(reqData); err != nil {
		output = <-c.readDone
		err0 = fmt.Errorf("executor %v: failed to write control pipe: %v", c.pid, err)
		return
	}
	if progData != nil {
		if _, err := c.outwp.Write(progData); err != nil {
			output = <-c.readDone
			err0 = fmt.Errorf("executor %v: failed to write control pipe: %v", c.pid, err)
			return
		}
	}
	......
	for {
		reply := &executeReply{}
		replyData := (*[unsafe.Sizeof(*reply)]byte)(unsafe.Pointer(reply))[:]
		if _, err := io.ReadFull(c.inrp, replyData); err != nil {
			break
		}
		......
		callReply := &callReply{}
		callReplyData := (*[unsafe.Sizeof(*callReply)]byte)(unsafe.Pointer(callReply))[:]
		if _, err := io.ReadFull(c.inrp, callReplyData); err != nil {
			break
		}
		......
	}
```
For the detail of executor, we refer to the next section. 
￼￼￼￼￼￼￼￼￼￼￼
## executor.cc
First, verify the value of some pre-defined macros - `SYZ_EXECUTOR_USES_FORK_SERVER` and `SYZ_EXECUTOR_USES_SHMEM`. The executor is architecture-dependent, but we only focus on `linux/386` and `linux/amd64`. The following code is copied from `executor/defs.h`.
```cpp
#if GOOS_linux
#define GOOS "linux"

#if GOARCH_386
#define GOARCH "386"
#define SYZ_REVISION "641fa484dddc5cba544715ffdc90383c136b95ae"
#define SYZ_EXECUTOR_USES_FORK_SERVER 1
#define SYZ_EXECUTOR_USES_SHMEM 1
#define SYZ_PAGE_SIZE 4096
#define SYZ_NUM_PAGES 4096
#define SYZ_DATA_OFFSET 536870912
#endif

#if GOARCH_amd64
#define GOARCH "amd64"
#define SYZ_REVISION "6eb98f08ff8a010f389802043050ee3fe4a79a3a"
#define SYZ_EXECUTOR_USES_FORK_SERVER 1
#define SYZ_EXECUTOR_USES_SHMEM 1
#define SYZ_PAGE_SIZE 40both 96
#define SYZ_NUM_PAGES 4096
#define SYZ_DATA_OFFSET 536870912
#endif
...
#endif
```
From the above definition, we know both `linux/amd64`and `linux/386` enable `SYZ_EXECUTOR_USES_FORK_SERVER` and `SYZ_EXECUTOR_USES_SHMEM`. Then let's start with the main function.
In L339, it maps kInFd(3), kOutFd(4) to input_data and output_data. I have described the internal reason why it maps fd 3 and fd 4 in the `MakeCommand`. 
```cpp
#if SYZ_EXECUTOR_USES_SHMEM
	if (mmap(&input_data[0], kMaxInput, PROT_READ, MAP_PRIVATE | MAP_FIXED, kInFd, 0) != &input_data[0])
		fail("mmap of input file failed");
	// The output region is the only thing in executor process for which consistency matters.
	// If it is corrupted ipc package will fail to parse its contents and panic.
	// But fuzzer constantly invents new ways of how to currupt the region,
	// so we map the region at a (hopefully) hard to guess address with random offset,
	// surrounded by unmapped pages.
	// The address chosen must also work on 32-bit kernels with 1GB user address space.
	void* preferred = (void*)(0x1b2bc20000ull + (1 << 20) * (getpid() % 128));
	output_data = (uint32*)mmap(preferred, kMaxOutput,
				    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, kOutFd, 0);
	if (output_data != preferred)
		fail("mmap of output file failed");

	// Prevent test programs to mess with these fds.
	// Due to races in collider mode, a program can e.g. ftruncate one of these fds,
	// which will cause fuzzer to crash.
	close(kInFd);
	close(kOutFd);
#endif
```
In L361, `use_temporary_dir` creates temporary directory and change working directory to tmpdir.
```cpp
static void use_temporary_dir(void)
{

	char tmpdir_template[] = "./syzkaller.XXXXXX";
	char* tmpdir = mkdtemp(tmpdir_template);
	if (!tmpdir)
		fail("failed to mkdtemp");
	if (chmod(tmpdir, 0777))
		fail("failed to chmod");
	if (chdir(tmpdir))
		fail("failed to chdir");
}
#endif
```
In L362, `install_segv_handler` creates segment fault handler to deal with segment fault. **Question**: What's the internal mechanism of `install_segv_handler` on `linux/amd64`?
In L363, `setup_control_pipes` duplicates stdin to kInPipeFd, stdout to kOutPipeFd.
```cpp
void setup_control_pipes()
{
	if (dup2(0, kInPipeFd) < 0)
		fail("dup2(0, kInPipeFd) failed");
	if (dup2(1, kOutPipeFd) < 0)
		fail("dup2(1, kOutPipeFd) failed");
	if (dup2(2, 1) < 0)
		fail("dup2(2, 1) failed");
	// We used to close(0), but now we dup stderr to stdin to keep fd numbers
	// stable across executor and C programs generated by pkg/csource.
	if (dup2(2, 0) < 0)
		fail("dup2(2, 0) failed");
}
```
In L365, `receive_handshake` corresponds to `handshake` in `ipc.go:647`. They share the same data structure, but declared with different languages.
```cpp
void receive_handshake()
{
	handshake_req req = {};
	int n = read(kInPipeFd, &req, sizeof(req));
	if (n != sizeof(req))
		fail("handshake read failed: %d", n);
	if (req.magic != kInMagic)
		fail("bad handshake magic 0x%llx", req.magic);
	parse_env_flags(req.flags);
	procid = req.pid;
}
```
 Hi
```cpp
int status = 0;
switch (flag_sandbox) {
case sandbox_none:
	status = do_sandbox_none();
	break;
#if SYZ_HAVE_SANDBOX_SETUID
case sandbox_setuid:
	status = do_sandbox_setuid();
	break;
#endif
#if SYZ_HAVE_SANDBOX_NAMESPACE
case sandbox_namespace:
	status = do_sandbox_namespace();
	break;
#endif
#if SYZ_HAVE_SANDBOX_ANDROID_UNTRUSTED_APP
case sandbox_android_untrusted_app:
	status = do_sandbox_android_untrusted_app();
	break;
#endif
default:
	fail("unknown sandbox type");
} 
```
We use the do_sandbox_none as an example, fork and run a loop to keep receiving data:
```cpp
static int do_sandbox_none(void)
{
	// CLONE_NEWPID takes effect for the first child of the current process,
	// so we do it before fork to make the loop "init" process of the namespace.
	if (unshare(CLONE_NEWPID)) {
		debug("unshare(CLONE_NEWPID): %d\n", errno);
	}
	int pid = fork();
	if (pid != 0)
		return wait_for_loop(pid);

	setup_common();
	sandbox_common();
#if SYZ_EXECUTOR || SYZ_ENABLE_NETDEV
	initialize_netdevices_init();
#endif
	if (unshare(CLONE_NEWNET)) {
		debug("unshare(CLONE_NEWNET): %d\n", errno);
	}
#if SYZ_EXECUTOR || SYZ_TUN_ENABLE
	initialize_tun();
#endif
#if SYZ_EXECUTOR || SYZ_ENABLE_NETDEV
	initialize_netdevices();
#endif
	loop();
	doexit(1);
}
#endif
```
**Question:** what's the duty of `setup_common` and `sandbox_common`?
In `loop`(`common.h:500`), the core logic is to invoke `execute_one` to find an available thread to execute one system call.
