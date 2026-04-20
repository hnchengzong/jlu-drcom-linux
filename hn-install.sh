#!/usr/bin/env bash

set -euo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

if [[ "$(id -u)" -ne 0 ]]; then
    echo -e "${RED}错误：必须使用 sudo 运行此脚本${RESET}"
    exit 1
fi

dir="./jlu-drcom"

if [ ! -d "$dir" ]; then
    echo -e "${RED}未检测到jlu-drcom文件夹，已退出。${RESET}"
    exit 1
fi

echo -e "${GREEN}检测到jlu-drcom文件夹。${RESET}"

critical_files=(
    "DrClientLinux"
    "DrClientLinux.rcc"
    "drcomauthsvr"
    "drcomauthsvr.drsc"
    "drcomrulesvr.drsc"
    "libjpeg.so.62"
    "libpng12.so.0"
    "pppoe-status"
    "hostinfo.sh"
    "translator/localizer_chs.qm"
)

warning_files=(
    "DrClientConfig"
    "hn-config.sh"
)

for file in "${critical_files[@]}"; do
    if [ ! -f "$dir/$file" ]; then
        echo -e "${RED}错误：缺失关键文件 $dir/$file${RESET}"
        exit 1
    fi
done

if [ ! -d "$dir/translator" ]; then
    echo -e "${RED}错误：缺失关键目录 $dir/translator${RESET}"
    exit 1
fi

for file in "${warning_files[@]}"; do
    if [ ! -f "$dir/$file" ]; then
        echo -e "${YELLOW}警告：缺失非关键文件 $dir/$file${RESET}"
    fi
done

if [ -d /opt/drclient ]; then
    echo -e "${BLUE}检测到已有安装，备份到 /opt/drclient.bak.${RANDOM}${RESET}"
    mv /opt/drclient "/opt/drclient.bak)"
fi

echo -e "${CYAN}开始安装文件...${RESET}"

install -d /opt/drclient/translator

install -Dm755 "$dir/DrClientLinux" /opt/drclient/DrClientLinux
install -Dm644 "$dir/libjpeg.so.62" /opt/drclient/libjpeg.so.62
install -Dm644 "$dir/libpng12.so.0" /opt/drclient/libpng12.so.0
install -Dm644 "$dir/DrClientLinux.rcc" /opt/drclient/DrClientLinux.rcc
install -Dm644 "$dir/translator/localizer_chs.qm" /opt/drclient/translator/localizer_chs.qm
install -Dm755 "$dir/drcomauthsvr" /opt/drclient/drcomauthsvr
install -Dm644 "$dir/drcomauthsvr.drsc" /opt/drclient/drcomauthsvr.drsc
install -Dm644 "$dir/drcomrulesvr.drsc" /opt/drclient/drcomrulesvr.drsc

install -Dm755 "$dir/hn-config.sh" /opt/drclient/hn-config.sh
install -Dm755 "$dir/hostinfo.sh" /opt/drclient/getinfo.sh
install -Dm755 "$dir/pppoe-status" /opt/drclient/pppoe-status.sh

chown root:root /opt/drclient/drcomauthsvr
chmod 4755 /opt/drclient/drcomauthsvr

install -d /usr/bin

cat > /usr/bin/jlu-drcom << 'EOF'
#!/bin/sh
cd /opt/drclient || exit 1
exec ./DrClientLinux "$@"
EOF

cat > /usr/bin/jlu-config << 'EOF'
#!/bin/sh
cd /opt/drclient || exit 1
export LD_LIBRARY_PATH=/opt/drclient:$LD_LIBRARY_PATH
exec /opt/drclient/hn-config.sh "$@"
EOF

chmod 755 /usr/bin/jlu-drcom
chmod 755 /usr/bin/jlu-config

echo -e "${GREEN}安装完成！${RESET}"
echo -e "${CYAN}使用 jlu-drcom 启动客户端${RESET}"
echo -e "${CYAN}使用 jlu-config 进行配置${RESET}"
