# ss-server-manager
This a shadowsocks server manager scripts library.


## Usage
This project based on shadowsocks-libev, docker-ce and supervisor.

**You should install docker-ce and supervisor, and install shadowsocks-libev docker image.**

### How to install dependent library
- [Install docker](https://docs.docker.com/install/ "docker")
- [Install supervisor](http://supervisord.org/installing.html "supervisor")

You need config supervisor, and include /root/shadowsocks/supervisor\_configs/\*.ini to config file.
And You can custom path, but you neeed to configure these scripts.

**Note**:
The default pidfile and serverurl are in the /tmp directory. They may be automatically deleted by the system,
resulting in an inability to manage them. You may need to customize their directories, such as /var/log/supervisor/.

- [Install shadowsocks-libev docker image](https://hub.docker.com/r/shadowsocks/shadowsocks-libev/ "shadowsocks-libev image")


## Q/A

### Why choose shadowsocks-libev?
The shadowsocks-libev is an active ss distribution, and high performance, low resource consumption.
More importantly, it supports newer technologies and algorithms, such as aes-128-gcm.

### Why choose docker?
The docker can better statistics traffic, more convenient management, and does not pollute the system.
And there is a ready-made shadowsocks-libev image on the docker hub. It does not need to be compiled by itself.
It is more convenient to install.


## Implemented function

1. Add and delete user.
2. Switch user status,
3. Get user traffic information.
4. ...


## Unrealized function

1. Automatic flow control was not implemented.
2. Remote self-management by users.
3. Automatically generate user-friendly ss:// link and QR code.
4. ...
