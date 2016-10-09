---
layout: post
title: "为 Linux Kernel 3.19 打补丁，使 VMwareWrokstation 正常运行"
date: 2015-04-11
description: ""
category: Linux,Kernel,VMwareWorkstation
tags: [linux kernel,3.19,vmware workstation,patch]
---

继 [为 Linux Kernel 3.17 打补丁，使 VMwareWrokstation 正常运行]({{ site.url }}/2015/04/11/linux-kernel-317-vmwarewrokstation.html)之后，我又升级了内核，结果有发生了上文中出现的情况。对于这个 vmware 已然无语，但是虚拟机还要接着用，没办法又找了一下，结果发现只是更换一下使用的patch就可以了。

具体的过程如下所示：

以下内容来自于 [Archlinux](https://wiki.archlinux.org/index.php/VMware#.2Fdev.2Fvmmon_not_found):

```
Configuration
Tip: There is also a package called vmware-patch in the AUR 
with the intention of trying to automate this section 
(it also supports older VMware versions).

Note: Due to Workstation 11/Player (Pro) 7 taking advantage of 
the mainlined kernel modules, patching the VMCI/VSOCK sources 
is no longer required.

VMware Workstation 11.1.0 and Player (Pro) 7.1.0 support kernels up to 3.18.
Since 3.19 kernel the vmnet module will fail to build.
```

Download patcha:

    $ curl http://pastie.org/pastes/9934018/download -o /tmp/vmnet-3.19.patch

Change Pwd:

	$ su / sudo su
    # cd /usr/lib/vmware/modules/source
    # tar -xf vmnet.tar

Apply the patch:

	# patch -p0 -i /tmp/vmnet-3.19.patch

Recreate the archive:

	# tar -cf vmnet.tar vmnet-only

Remove leftover:

	# rm -r *-only

Rebuild modules:

	# vmware-modconfig --console --install-all
