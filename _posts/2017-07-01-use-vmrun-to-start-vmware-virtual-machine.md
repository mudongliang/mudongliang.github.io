---
layout: post
title: "use vmrun to start vmware virtual machine"
date: 2017-07-01
description: ""
category: 
tags: []
---

* TOC
{:toc}

## VIX API

[VIX API](https://www.vmware.com/support/developer/vix-api/) allows users to automate the management of VMs, such as APIs used to start/stop VMs. It supports most products from VMware, including Player, Sever, Workstation, Fusion and vSphere (though VIX API is deprecated as there is a vSphere API).

## vmrun

After VIX API is installed, you will have a powerful command – vmrun, which leverages the powerful VIX API to provide a similar command line interface for VMware-based VMs, like virsh for KVM.

Take VMware Player and its VMs for example:

### Start the VM without GUI
vmrun -T player start "path/to/yourVM.vmx" nogui

1.Start the VM

```
vmrun -T player start "path/to/yourVM.vmx"
```

2.Stop the VM

```
vmrun -T player stop "path/to/yourVM.vmx"
vmrun -T player stop "path/to/yourVM.vmx" soft
vmrun -T player stop "path/to/yourVM.vmx" hard
```

3.List all possible commands supported by vmrun

```
vmrun -h
```

If you want to control VMs in VMware Workstation, you need change "player" to "ws", like:

```
vmrun -T ws start "path/to/yourVM.vmx" nogui
```

### Issues with vmrun nogui

Once you start VM with nogui and login the VM, you may find `top/ls` do not work normally. The same case happens if you try to compile the kernel (make menuconfig). Adding the fix into .profile helps.

```
# top
‘xterm-256color’: unknown terminal type.

add "export TERM=xterm" into .profile
```
