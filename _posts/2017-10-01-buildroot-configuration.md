---
layout: post
title: "Buildroot configuration"
date: 2017-10-01
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Buildroot installation

### Download and unpack Buildroot

```
$ wget https://buildroot.org/downloads/buildroot-2017.08.tar.gz
$ tar -xvf buildroot-2017.08.tar.gz
```

### Configure Buildroot and generate the system

```
$ cd buildroot-2017.08/

$ make list-defconfigs | grep qemu
  qemu_aarch64_virt_defconfig         - Build for qemu_aarch64_virt
  qemu_arm_versatile_defconfig        - Build for qemu_arm_versatile
  qemu_arm_versatile_nommu_defconfig  - Build for qemu_arm_versatile_nommu
  qemu_arm_vexpress_defconfig         - Build for qemu_arm_vexpress
  qemu_m68k_mcf5208_defconfig         - Build for qemu_m68k_mcf5208
  qemu_m68k_q800_defconfig            - Build for qemu_m68k_q800
  qemu_microblazebe_mmu_defconfig     - Build for qemu_microblazebe_mmu
  qemu_microblazeel_mmu_defconfig     - Build for qemu_microblazeel_mmu
  qemu_mips32r2el_malta_defconfig     - Build for qemu_mips32r2el_malta
  qemu_mips32r2_malta_defconfig       - Build for qemu_mips32r2_malta
  qemu_mips32r6el_malta_defconfig     - Build for qemu_mips32r6el_malta
  qemu_mips32r6_malta_defconfig       - Build for qemu_mips32r6_malta
  qemu_mips64el_malta_defconfig       - Build for qemu_mips64el_malta
  qemu_mips64_malta_defconfig         - Build for qemu_mips64_malta
  qemu_mips64r6el_malta_defconfig     - Build for qemu_mips64r6el_malta
  qemu_mips64r6_malta_defconfig       - Build for qemu_mips64r6_malta
  qemu_nios2_10m50_defconfig          - Build for qemu_nios2_10m50
  qemu_or1k_defconfig                 - Build for qemu_or1k
  qemu_ppc64_pseries_defconfig        - Build for qemu_ppc64_pseries
  qemu_ppc_g3beige_defconfig          - Build for qemu_ppc_g3beige
  qemu_ppc_mpc8544ds_defconfig        - Build for qemu_ppc_mpc8544ds
  qemu_ppc_virtex_ml507_defconfig     - Build for qemu_ppc_virtex_ml507
  qemu_sh4eb_r2d_defconfig            - Build for qemu_sh4eb_r2d
  qemu_sh4_r2d_defconfig              - Build for qemu_sh4_r2d
  qemu_sparc64_sun4u_defconfig        - Build for qemu_sparc64_sun4u
  qemu_sparc_ss10_defconfig           - Build for qemu_sparc_ss10
  qemu_x86_64_defconfig               - Build for qemu_x86_64
  qemu_x86_defconfig                  - Build for qemu_x86
  qemu_xtensa_lx60_defconfig          - Build for qemu_xtensa_lx60
  qemu_xtensa_lx60_nommu_defconfig    - Build for qemu_xtensa_lx60_nommu

# build for 64-bit
$ make qemu_x86_64_defconfig
  qemu_x86_64_defconfig               - Build for qemu_x86_64
# build for 32-bit
$ make qemu_x86_defconfig
  qemu_x86_defconfig                  - Build for qemu_x86

# select kernel version, building options and ...
$ make menuconfig
$ make

# configure the kernel
$ make linux-menuconfig
$ make

# Or build out-of-tree
$ make O=../x86 qemu_x86_64_defconfig
$ make O=../x86 menuconfig
$ make O=../x86 linux-menuconfig
$ cd ../x86
$ make

$ make O=../x86_64 qemu_x86_defconfig
$ make O=../x86_64 menuconfig
$ make O=../x86_64 linux-menuconfig
$ cd ../x86_64
$ make
```

## Launch the system with Qemu and debug server

```
# 32-bit
$ qemu-system-i386 -kernel output/images/bzImage \
                   -hda output/images/rootfs.ext2 \
                   -append "root=/dev/sda rw" -s -S
# 64-bit
$ qemu-system-x86_64 -kernel output/images/bzImage \
                     -hda output/images/rootfs.ext2 \
                     -append "root=/dev/sda rw" -s -S
```

If you want to debug kernel, please follow [another post](https://mudongliang.github.io/2017/09/28/debugging-kernel-and-modules-via-gdb.html) when building Linux kernel, for example, disable KASLR and etc...

## Launch the debugger

```
$ cd build/linux-4.12.10/
$ gdb vmlinux
(gdb) target remote :1234
(gdb) b start_kernel
```
In my experiment, this breakpoint only works in x86 version, not in x86_64 version. In x86_64 version, there will be one error:

```
Remote 'g' packet reply is too long: 
......
```

## References

[1] [Qemu and the Kernel](http://www.linux-magazine.com/Online/Features/Qemu-and-the-Kernel)

[2] [README](https://github.com/buildroot/buildroot/blob/master/docs/manual/common-usage.txt)
