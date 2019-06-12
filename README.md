# ss-server-manager

This a shadowsocks server manager scripts library.


## Usage

This project based on _shadowsocks-libev_, _v2ray-plugin_, _docker-ce_ and _supervisor_.

**You should install docker-ce and supervisor, and build a shadowsocks docker image using _Dockerfile_.**

### Install dependent library

- [Install docker](https://docs.docker.com/install/ "docker")
- [Install supervisor](http://supervisord.org/installing.html "supervisor")

You need config supervisor,
and include `/root/shadowsocks/supervisor_configs/*.ini` in your config file.
And You can custom path, but you neeed to configure these scripts.

**Note**:
The default pidfile and serverurl are in the `/tmp` directory.
They may be automatically deleted by the system,
resulting in an inability to manage them.
You may need to customize their directories, such as `/var/log/supervisor/`.

### Build shadowsocks docker image

Execute follow command in current directory to build it.

``` shell
docker build . -t irika/shadowsocks
```

#### Copyright Notice

The _Dockerfile_ is copy from
[mritd/dockerfile](https://github.com/mritd/dockerfile/blob/master/shadowsocks/Dockerfile "mritd/dockerfile").
And removed some code, which makes the image more flexible.

The image support _shadowsocks-libev_ with _v2ray-plugin_, _kcptun_ and _simple-obfs_.


## Q/A

### Why choose shadowsocks-libev?

The shadowsocks-libev is an active ss distribution, and high performance, low resource consumption.
More importantly, it supports newer technologies and algorithms, such as aes-128-gcm.

### Why choose v2ray?

In my test, v2ray is more stable and faster.
And it is a newer tools for confusion proxy.

### Why choose docker?

The docker can better statistics traffic, more convenient management, and does not pollute the system.
And there is a ready-made shadowsocks-libev image on the docker hub. It does not need to be compiled by itself.
It is more convenient to install.


## Features

### Implemented

 - Add and delete user,
 - Switch user status,
 - Get user traffic information,
 - Generate user-friendly ss:// link,
 - V2ray confusion,
 - Restore user configuration,
 - ...


### Unimplemented

 - Automatic flow control was not implemented,
 - Remote self-management by users,
 - Generate user-friendly QR code,
 - ...

### NEED CLIENT MANUAL

 - v2ray-plugin on client device need manual configure,

