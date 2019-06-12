# Client usage tutorial

This tutorial is for the client side
of the server configured with this project.

## Client device

List support client device and unsupport device.

### Support

 - Windows 7 and newer
 - Android
 - Linux command line
 - MAC OS X command line

### Unsupport

 - router
 - iOS
 - and other device

## Windows 7 and newer

**NOTE**:
For Windows device, the tutorial base on
[shadowsocks windows][shadowsocks-windows].

1. Download [shadowsocks windows][shadowsocks-windows-release] and install it
2. Download [v2ray plugin][v2ray-plugin-windows-release] and extract it to _shadowsocks-windows_ directory, named as _v2ray-plugin.exe_
3. Start shadowsocks-windows
4. Use the parameter information obtained from your service provider to configure
5. Enter _v2ray-plugin.exe_ in the **Plugin** input box
6. If you have extra parameter for v2ray, input it to **Parameter** box

## Android

**NOTE**:
For Android device, the tutorial base on
[shadowsocks android][shadowsocks-android].

1. Download [shadowsocks android][shadowsocks-android-release] and install it into your android device
2. Download v2ray for android and install it into your android device
3. Start shadowsocks-android
4. Use the parameter information obtained from your service provider to configure
5. Choose _v2ray_ in **Plugin** box
6. If you have extra parameter for v2ray, input it to **Configuration** page

## Linux and MAC OS X command line

**NOTE**:
For Android device, the tutorial base on
[shadowsocks-libev][shadowsocks-libev].

1. Install shadowsocks-libev, Follow is Ubuntu and MAC OS X install command
   - In Ubuntu `sudo apt install shadowsocks-libev`
   - In MAC OS X `brew install shadowsocks-libev`
2. Download [v2ray plugin Linux][v2ray-plugin-linux-release] or [v2ray plugin MAC OS X][v2ray-plugin-macosx-release]
and extract it to `/usr/bin` directory
3. Like follow configuration file to configure yourself configuration file named as `myserver.json`
``` json
{
    "server":["Your server IP or domain name"],
    "server_port":"remote port",
    "local_port":1080,
    "password":"Your password",
    "timeout":300,
    "method":"aes-128-gcm",
    "plugin":"v2ray-plugin",
    "plugin_opts":"fast-open",
    "mode":"tcp_and_udp",
    "fast_open": true
}
```
4. If you have extra parameter for v2ray, configure it into configuration file
5. Use command to start shadowsocks `ss-local -c myserver.json`
6. Now, you can use local port 1080 to proxy you applications, only **socks5**
7. If you need automatic proxy, you should use _PAC_
8. If you need http or https proxy, you can use _provixy_ tools.


[shadowsocks-windows]: https://github.com/shadowsocks/shadowsocks-windows "shadowsocks windows"
[shadowsocks-windows-release]: https://github.com/shadowsocks/shadowsocks-windows/releases/download/4.1.6/Shadowsocks-4.1.6.zip "shadowsocks windows release"
[v2ray-plugin-windows-release]: https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.1.0/v2ray-plugin-windows-amd64-v1.1.0.tar.gz "Windows v2ray plugin release"
[shadowsocks-android]: https://github.com/shadowsocks/shadowsocks-android "shadowsocks android"
[shadowsocks-android-release]: https://github.com/shadowsocks/shadowsocks-android/releases/download/v4.7.4/shadowsocks--universal-4.7.4.apk "shadowsocks android release"
[shadowsocks-libev]: https://github.com/shadowsocks/shadowsocks-libev "shadowsocks-libev"
[v2ray-plugin-linux-release]: https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.1.0/v2ray-plugin-linux-amd64-v1.1.0.tar.gz "Linux v2ray plugin release"
[v2ray-plugin-macosx-release]: https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.1.0/v2ray-plugin-darwin-amd64-v1.1.0.tar.gz "MAC OS X v2ray plugin release"

