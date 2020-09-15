---
layout: post
title: "Linux autostart ssr with systemd unit"
date: 2020-09-14
description: ""
category: 
tags: []
---
* TOC
{:toc}

## Autostart ssr with systemd unite

First, create a Systemd service file - `/etc/systemd/system/ssr.service` as below:

```
[Unit]
After=network.service

[Service]
ExecStart=/usr/local/bin/ssr_start
ExecStop=/usr/local/bin/ssr_stop

[Install]
WantedBy=default.target
```

`After`: Instructs systemd on when the script should be run  
`ExecStart`: This field provides a full path to the actual script to be executed on startup  
`ExecStop`: This field provides a full path to the actual script to be executed on stop 
`WantedBy`: Into what boot target the systemd unit should be installed  

Note that, you can also directly use `ssr` script in `ssr.service`.

Then, create the script - `/usr/local/bin/ssr_start` and `/usr/local/bin/ssr_stop` as below:

```sh
#!/bin/bash

/home/mudongliang/bin/ssr start > /tmp/ssr.log 2>&1
```

```sh
#!/bin/bash

/home/mudongliang/bin/ssr stop > /tmp/ssr.log 2>&1
```

Finally, modify the permission of two files and reload systemd
```
chmod 644 /etc/systemd/system/ssr.service
chmod 755 /usr/local/bin/ssr_start
chmod 755 /usr/local/bin/ssr_stop

sudo systemctl daemon-reload
sudo systemctl enable ssr.service
```

Here you can use `systemctl start ssr.service` and `systemctl stop ssr.service` to test this unit.

### Issue 1: Run systemd unit as normal user

We don't this service is executed by `root` at boot, so running systemd unit as normal user is essential. Systemd provides `User` and `Group` to specify which user to run this system unit. Then our `ssr_start.service` changes like this (Replace XXX with your own username and group name)

```
[Unit]
After=network.service

[Service]
User=XXX
Group=XXX
ExecStart=/usr/local/bin/ssr_start
ExecStop=/usr/local/bin/ssr_stop
RemainAfterExit=yes

[Install]
WantedBy=default.target
```

### Issue 2: Run ssr script after network is ready

Only network.service does not make sure network is really up. After google-searching, I found Reference 3 can help solve this issue.

```
[Unit]
Description=Run service as user mudongliang
Wants=network-online.target
After=network-online.target

[Service]
User=XXX
Group=XXX
ExecStart=/usr/local/bin/ssr_start
ExecStop=/usr/local/bin/ssr_stop
RemainAfterExit=yes

[Install]
WantedBy=default.target
```

## References

[1] [How to run script on startup on Ubuntu 20.04 Focal Fossa Server/Desktop](https://linuxconfig.org/how-to-run-script-on-startup-on-ubuntu-20-04-focal-fossa-server-desktop#:~:text=How%20to%20run%20script%20on%20startup%20on%20Ubuntu%2020.04%20step,service%20during%20the%20system%20boot.)

[2] [How to run systemd service as specific user and group in Linux](https://www.golinuxcloud.com/run-systemd-service-specific-user-group-linux/)

[3] [Running Services After the Network is up](https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/)
