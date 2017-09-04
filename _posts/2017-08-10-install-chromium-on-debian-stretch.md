---
layout: post
title: "Checking out and building Chromium on Linux"
date: 2017-08-10
description: ""
category: 
tags: []
---
* TOC
{:toc}

**I have installed the latest chromium from source code successfully in Debian Stretch by the following instructions.**

## System requirements

*   A 64-bit Intel machine with at least 8GB of RAM. More than 16GB is highly
    recommended.
*   At least 100GB of free disk space.
*   You must have Git and Python installed already.

Most development is done on Ubuntu (currently 14.04, Trusty Tahr). There are
some instructions for other distros below, but they are mostly unsupported.

## Install `depot_tools`

Clone the `depot_tools` repository:

```shell
$ git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

Add `depot_tools` to the end of your PATH (you will probably want to put this
in your `~/.bashrc` or `~/.zshrc`). Assuming you cloned `depot_tools` to
`/path/to/depot_tools`:

```shell
$ export PATH="$PATH:/path/to/depot_tools"
```

## Get the code

Create a `chromium` directory for the checkout and change to it (you can call
this whatever you like and put it wherever you like, as long as the full path
has no spaces):

```shell
$ mkdir ~/chromium && cd ~/chromium
```

Run the `fetch` tool from depot_tools to check out the code and its
dependencies.

```shell
$ fetch --nohooks chromium
```

If you don't want the full repo history, you can save a lot of time by
adding the `--no-history` flag to `fetch`.

Expect the command to take 30 minutes on even a fast connection, and many
hours on slower ones.

If you've already installed the build dependencies on the machine (from another
checkout, for example), you can omit the `--nohooks` flag and `fetch`
will automatically execute `gclient runhooks` at the end.

When `fetch` completes, it will have created a hidden `.gclient` file and a
directory called `src` in the working directory. The remaining instructions
assume you have switched to the `src` directory:

```shell
$ cd src
```

### Install additional build dependencies

Once you have checked out the code, and assuming you're using Ubuntu, run
[build/install-build-deps.sh](https://chromium.googlesource.com/chromium/src/+/master/docs/build/install-build-deps.sh)

You may need to adjust the build dependencies for other distros. There are
some [notes](#notes) at the end of this document, but we make no guarantees
for their accuracy.

### Run the hooks

Once you've run `install-build-deps` at least once, you can now run the
Chromium-specific hooks, which will download additional binaries and other
things you might need:

```shell
$ gclient runhooks
```

*Optional*: You can also [install API
keys](https://www.chromium.org/developers/how-tos/api-keys) if you want your
build to talk to some Google services, but this is not necessary for most
development and testing purposes.

## Setting up the build

Chromium uses [Ninja](https://ninja-build.org) as its main build tool along
with a tool called [GN](https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/quick_start.md) to generate `.ninja`
files. You can create any number of *build directories* with different
configurations. To create a build directory, run:

```shell
$ gn gen out/Default
```

* You only have to run this once for each new build directory, Ninja will
  update the build files as needed.
* You can replace `Default` with another name, but
  it should be a subdirectory of `out`.
* For other build arguments, including release settings, see [GN build
  configuration](https://www.chromium.org/developers/gn-build-configuration).
  The default will be a debug component build matching the current host
  operating system and CPU.
* For more info on GN, run `gn help` on the command line or read the
  [quick start guide](https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/quick_start.md).

### Faster builds

This section contains some things you can change to speed up your builds,
sorted so that the things that make the biggest difference are first.

#### Disable NaCl

By default, the build includes support for
[Native Client (NaCl)](https://developer.chrome.com/native-client), but
most of the time you won't need it. You can set the GN argument 
`enable_nacl=false` and it won't be built.

#### Include fewer debug symbols

By default GN produces a build with all of the debug assertions enabled
(`is_debug=true`) and including full debug info (`symbol_level=2`). Setting
`symbol_level=1` will produce enough information for stack traces, but not
line-by-line debugging. Setting `symbol_level=0` will include no debug
symbols at all. Either will speed up the build compared to full symbols.

#### Disable debug symbols for Blink

Due to its extensive use of templates, the Blink code produces about half
of our debug symbols. If you don't ever need to debug Blink, you can set
the GN arg `remove_webcore_debug_symbols=true`.

#### Use Icecc

[Icecc](https://github.com/icecc/icecream) is the distributed compiler with a
central scheduler to share build load. Currently, many external contributors use
it. e.g. Intel, Opera, Samsung (Googlers use an internal system called Goma).

In order to use `icecc`, set the following GN args:

```
linux_use_bundled_binutils=false
use_debug_fission=false
is_clang=false
```

See these links for more on the 
[bundled_binutils limitation](https://github.com/icecc/icecream/commit/b2ce5b9cc4bd1900f55c3684214e409fa81e7a92),
the [debug fission limitation](http://gcc.gnu.org/wiki/DebugFission).

Using the system linker may also be necessary when using glibc 2.21 or newer.
See [related bug](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=808181).

#### ccache

You can use [ccache](https://ccache.samba.org) to speed up local builds (again,
this is not useful if you're using a Googler using Goma).

Increase your ccache hit rate by setting `CCACHE_BASEDIR` to a parent directory
that the working directories all have in common (e.g.,
`/home/yourusername/development`). Consider using
`CCACHE_SLOPPINESS=include_file_mtime` (since if you are using multiple working
directories, header times in svn sync'ed portions of your trees will be
different - see
[the ccache troubleshooting section](http://ccache.samba.org/manual.html#_troubleshooting)
for additional information). If you use symbolic links from your home directory
to get to the local physical disk directory where you keep those working
development directories, consider putting

    alias cd="cd -P"

in your `.bashrc` so that `$PWD` or `cwd` always refers to a physical, not
logical directory (and make sure `CCACHE_BASEDIR` also refers to a physical
parent).

If you tune ccache correctly, a second working directory that uses a branch
tracking trunk and is up to date with trunk and was gclient sync'ed at about the
same time should build chrome in about 1/3 the time, and the cache misses as
reported by `ccache -s` should barely increase.

This is especially useful if you use `git-new-workdir` and keep multiple local
working directories going at once.

#### Using tmpfs

You can use tmpfs for the build output to reduce the amount of disk writes
required. I.e. mount tmpfs to the output directory where the build output goes:

As root:

    mount -t tmpfs -o size=20G,nr_inodes=40k,mode=1777 tmpfs /path/to/out

*** note
**Caveat:** You need to have enough RAM + swap to back the tmpfs. For a full
debug build, you will need about 20 GB. Less for just building the chrome target
or for a release build.
***

Quick and dirty benchmark numbers on a HP Z600 (Intel core i7, 16 cores
hyperthreaded, 12 GB RAM)

*   With tmpfs:
    *   12m:20s
*   Without tmpfs
    *   15m:40s

## Build Chromium

Build Chromium (the "chrome" target) with Ninja using the command:

```shell
$ ninja -C out/Default chrome
```

You can get a list of all of the other build targets from GN by running `gn ls
out/Default` from the command line. To compile one, pass the GN label to Ninja
with no preceding "//" (so, for `//chrome/test:unit_tests` use `ninja -C
out/Default chrome/test:unit_tests`).

## Run Chromium

Once it is built, you can simply run the browser:

```shell
$ out/Default/chrome
```

## Running test targets

You can run the tests in the same way. You can also limit which tests are
run using the `--gtest_filter` arg, e.g.:

```shell
$ out/Default/unit_tests --gtest_filter="PushClientTest.*"
```

You can find out more about GoogleTest at its
[GitHub page](https://github.com/google/googletest).

## Update your checkout

To update an existing checkout, you can run

```shell
$ git rebase-update
$ gclient sync
```

The first command updates the primary Chromium source repository and rebases
any of your local branches on top of tip-of-tree (aka the Git branch
`origin/master`). If you don't want to use this script, you can also just use
`git pull` or other common Git commands to update the repo.

The second command syncs dependencies to the appropriate versions and re-runs
hooks as needed.

## Tips, tricks, and troubleshooting

### Linker Crashes

If, during the final link stage:

```
LINK out/Debug/chrome
```

You get an error like:

```
collect2: ld terminated with signal 6 Aborted terminate called after throwing an instance of 'std::bad_alloc'
collect2: ld terminated with signal 11 [Segmentation fault], core dumped
```

you are probably running out of memory when linking. You *must* use a 64-bit
system to build. Try the following build settings (see [GN build
configuration](https://www.chromium.org/developers/gn-build-configuration) for
other settings):

*   Build in release mode (debugging symbols require more memory):
    `is_debug = false`
*   Turn off symbols: `symbol_level = 0`
*   Build in component mode (this is for development only, it will be slower and
    may have broken functionality): `is_component_build = true`

### More links

*   Information about [building with Clang](https://chromium.googlesource.com/chromium/src/+/master/docs/clang.md).
*   You may want to [use a chroot](https://chromium.googlesource.com/chromium/src/+/master/docs/using_a_linux_chroot.md) to
    isolate yourself from versioning or packaging conflicts.
*   Cross-compiling for ARM? See [LinuxChromiumArm](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_chromium_arm.md).
*   Want to use Eclipse as your IDE? See
    [LinuxEclipseDev](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_eclipse_dev.md).
*   Want to use your built version as your default browser? See
    [LinuxDevBuildAsDefaultBrowser](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_dev_build_as_default_browser.md).

## Next Steps

If you want to contribute to the effort toward a Chromium-based browser for
Linux, please check out the [Linux Development page](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_development.md) for
more information.

## References

[linux_build_instructions.md from Chromium Documents](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md)


