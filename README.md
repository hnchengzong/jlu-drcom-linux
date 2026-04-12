# jlu-drcom

jlu-drcom是适用于Arch Linux的吉林大学校园网登录认证客户端。

## 安装

### AUR

`paru -S jlu-drcom-bin`

如果你使用yay

`yay -S jlu-drcom-bin`

## 运行

在终端中输入`jlu-drcom`

## 网络设置

- 使用客户端登录时，连接Wi-Fi时不需要设置IP、子网掩码、DNS和网关。但是使用有线网络(wired connection 1)时必须全部设置。IP，网关等可以在`login.jlu.edu.cn`中登录查看。如果你使用networkmanager，请按照一下指令配置。

```bash
# 查看连接名称
nmcli connection show

# 假设有线连接名称为 "Wired connection 1"
sudo nmcli connection modify "Wired connection 1" ipv4.method manual
sudo nmcli connection modify "Wired connection 1" ipv4.addresses 你的IP/掩码
sudo nmcli connection modify "Wired connection 1" ipv4.gateway 你的网关
sudo nmcli connection modify "Wired connection 1" ipv4.dns "你的DNS"
sudo nmcli connection modify "Wired connection 1" ipv6.method disabled

# 重新激活连接
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"
```

- 如果你有图形化界面，请找到有线连接（通常名为“Wired connection 1”），点击齿轮图标。切换到 IPv4 选项卡。将方法从“自动 (DHCP)”改为 “手动”。在“地址”栏中填写：

1. 地址：你的 IP（例如 1.1.1.1）
2. 子网掩码：使用 CIDR 格式（例如 24 对应 255.255.255.0）
3. 你的网关地址

切换到 IPv6 选项卡，选择“禁用”。点击“应用”，然后关闭并重新打开有线连接（或重启 NetworkManager）。

你可以使用`ip a`命令来检查你的网络设置是否设置。
