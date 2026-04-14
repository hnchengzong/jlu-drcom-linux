#!/usr/bin/env bash

set -euo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[31m错误：必须使用 sudo 运行此脚本\033[0m"
    echo "Arch Linux用户可以使用 sudo jlu-config(AUR)"
    exit 1
fi

JLU_CONFIG="/opt/drclient/DrClientConfig"
WIRED="Wired connection 1"

GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
CYAN="\033[36m"
PURPLE="\033[35m"
RESET="\033[0m"

clear

echo -e "${GREEN}=================================================${RESET}"
echo -e "${YELLOW}jlu-drcom配置工具${RESET}"
echo -e "${BLUE}作者：HN程宗（hnchengzong） ${RESET}"
echo -e "${PURPLE}项目地址：https://github.com/hnchengzong/jlu-drcom${RESET}"
echo -e "${GREEN}=================================================${RESET}"
echo

echo -e "${YELLOW}要使用有线网络必须设置IP、网关、DNS、子网掩码等${RESET}"
echo


read -rp "是否配置自动登录？[y/N] " confirm_login

if [[ "$confirm_login" == "y" || "$confirm_login" == "Y" ]]; then
    echo
    read -rp "请输入账号：" account
    read -rsp "请输入密码：" password
    echo

    pass64=$(echo -n "$password" | base64)

    cat > "$JLU_CONFIG" <<EOF
[DrClientConfig]
Account=$account
Passoword="$pass64"
Adapter=
AutoLogin=1
SavePassword=1
Ext=
EOF

    chmod 644 "$JLU_CONFIG"
    echo -e "${CYAN}已保存配置${RESET}"
else
    echo -e "${YELLOW}跳过配置${RESET}"
fi

read -rp "是否配置有线网络？[y/N] " confirm_net

if [[ "$confirm_net" == "y" || "$confirm_net" == "Y" ]]; then

    read -rp "IP 地址和子网掩码（如1.1.1.1/24）：" ip
    read -rp "网关：" gateway
    read -rp "DNS（多个DNS使用空格分隔）：" dns

    echo
    echo -e "${BLUE}开始配置NetworkManager网络设置${RESET}"

    nmcli connection modify "$WIRED" ipv4.method manual
    nmcli connection modify "$WIRED" ipv4.addresses "$ip"
    nmcli connection modify "$WIRED" ipv4.gateway "$gateway"
    nmcli connection modify "$WIRED" ipv4.dns "$dns"
    nmcli connection modify "$WIRED" ipv6.method disabled

    nmcli connection down "$WIRED" >/dev/null 2>&1
    nmcli connection up "$WIRED" >/dev/null 2>&1

    echo -e "${CYAN}有线网络配置完成${RESET}"
else
    echo -e "${BLUE}跳过网络配置${RESET}"
fi

echo
echo -e "${GREEN}=================================================${RESET}"
echo -e "${RED}结束配置！${RESET}"
echo -e "${GREEN}=================================================${RESET}"