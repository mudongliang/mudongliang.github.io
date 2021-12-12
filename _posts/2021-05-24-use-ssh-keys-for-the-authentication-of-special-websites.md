---
layout: post
title: "Use ssh keys for the authentication of special websites"
date: 2021-05-24
description: ""
category: 
tags: []
---
* TOC
{:toc}

By default, the SSH configuration file may not exist, so you need to create it.

```
$ touch ~/.ssh/config
$ chmod 600 ~/.ssh/config
```

## SSH Configuration File Structure

The ssh_config client configuration file has the following format. Both the global `/etc/ssh/ssh_config` and per-user `~/.ssh/config` have the same format.

- Empty lines and lines starting with '#' are comments.

- Each line begins with a keyword, followed by argument(s).

- Configuration options may be separated by whitespace or optional whitespace and exactly one =.

- Arguments may be enclosed in double quotes (") in order to specify arguments that contain spaces.


```
Host hostname1
    SSH_OPTION value
    SSH_OPTION value

Host hostname2
    SSH_OPTION value

Host *
    SSH_OPTION value
```

Take the following snippet as an example,

```
Host github.com
    User mudongliang
    IdentityFile ~/.ssh/github_rsa

```

### Host

Restricts the following declarations to be only for those hosts that match one of the patterns given after the keyword. The pattern is matched against the host name given on the command line.

### HostName

Specifies the real host name to log into. This can be used to specify nicknames or abbreviations for hosts. The default is the name given on the command line. Numeric IP addresses are also permitted (both on the command line and in HostName specifications).

### IdentityFile

Specifies a file from which the user's identity key is read when using public key authentication. The default for protocol version 1 is ~/.ssh/identity; and ~/.ssh/id_rsa or ~/.ssh/id_dsa for protocol version 2.

## References

[1] [Using the SSH Config File](https://linuxize.com/post/using-the-ssh-config-file/)

[2] [SSH config file for OpenSSH client](https://www.ssh.com/academy/ssh/config#format-of-ssh-client-config-file-ssh_config)
