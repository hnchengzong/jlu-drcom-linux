#!/usr/bin/env bash

# 这个脚本监测本机的IP、MAC地址和网关，给DrClientLinux主程序使用。你可以强制设置这些值

export LANG="en"

FORCE_DEV=""          # 网卡名,这几项不填则默认从本机获取。
FORCE_IP=""           # 强制本机IP。
FORCE_MAC=""          # 强制MAC地址。
FORCE_GATEWAY=""      # 强制网关。

find_physical_dev() {
    [ -n "$FORCE_DEV" ] && echo "$FORCE_DEV" && return
    ip -br link | awk '
        /UP/ && !/LOOPBACK/ && !/docker/ && !/virbr/ && !/vbox/ && !/br-/ {
            print $1; exit
        }'
}

dev=$(find_physical_dev)

if [ -n "$FORCE_IP" ]; then
    ip="$FORCE_IP"
else
    ip=$(ip -4 addr show "$dev" 2>/dev/null | awk '/inet/ {split($2,a,"/"); print a[1]}')
fi

if [ -n "$FORCE_MAC" ]; then
    mac="$FORCE_MAC"
else
    mac=$(ip link show "$dev" 2>/dev/null | awk '/link\/ether/ {print $2}')
fi

if [ -n "$FORCE_GATEWAY" ]; then
    gw="$FORCE_GATEWAY"
else
    gw=$(ip route show default 2>/dev/null | awk '/default/ {print $3}')
    [ -z "$gw" ] && gw="0.0.0.0"
fi

[ -n "$ip" ] && [ -n "$mac" ] && echo "Net	$ip	$mac	$gw"

uname -snr | awk '{print $1"\t"$2"\t"$3}'