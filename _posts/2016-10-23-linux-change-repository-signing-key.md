---
layout: post
title: "Commands To Change Repository Signing Key"
date: 2016-10-23
description: ""
category: 
tags: []
---

Today when I tried to update my CentOS 7 Server, I encountered the following error:

```
Downloading packages:
warning: /var/cache/yum/x86_64/7/cuda/packages/cuda-8-0-8.0.44-1.x86_64.rpm: Header V3 RSA/SHA512 Signature, key ID 7fa2af80: NOKEY
Retrieving key from http://developer.download.nvidia.com/compute/cuda/repos/GPGKEY


The GPG keys listed for the "cuda" repository are already installed but they are not correct for this package.
Check that the correct key URLs are configured for this repository.


 Failing package is: cuda-8-0-8.0.44-1.x86_64
  GPG Keys are configured as: http://developer.download.nvidia.com/compute/cuda/repos/GPGKEY

```

Then I changed our signing key according to [Repository Signing Key Change From CUDA](https://devtalk.nvidia.com/default/topic/968891/repository-signing-key-change/). 

[New GPG Key](http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub) From CUDA

List commands to manage your signing keys :

- Add signing key

```
a) For Debian/Ubuntu distributions

# cat 7fa2af80.pub | apt-key add -

b) For Fedora, RHEL and SUSE distributions

# rpm --import 7fa2af80.pub
# rpm --import http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub
```

- Remove signing key

```
a) For Debian/Ubuntu distributions

# apt-key del 5C37D3BE

b) For Fedora, RHEL and SUSE distributions

# rpm -e gpg-pubkey-5c37d3be
```

- List all the signing keys

```
a) For Debian/Ubuntu distributions

# apt-key list

b) For Fedora, RHEL and SUSE distributions

# yum keys
```

