# jlu-drcom

jlu-drcom是适用于Arch Linux的吉林大学校园网登录认证客户端。

![Arch Linux](https://img.shields.io/badge/Arch-Linux-blue?logo=archlinux&logoColor=white)

![moe-counter](https://count.getloli.com/@jlu-drcom?theme=booru-lewd&padding=7&offset=0&align=top&scale=1&pixelated=1&darkmode=auto)

## 安装

### Arch Linux

#### AUR

`paru -S jlu-drcom-bin`

如果你使用yay

`yay -S jlu-drcom-bin`

### 其他发行版

```bash

git clone --depth 1 https://github.com/hnchengzong/jlu-drcom.git

cd ./jlu-drcom

# 安装
sudo bash ./hn-install.sh

# 进行配置
sudo jlu-config

jlu-drcom


```

## 运行

在终端中输入`jlu-drcom`。在使用前可以先`sudo jlu-config`进行配置。

## 配置

### 自动配置

Arch Linux用户可以使用`sudo jlu-config`，其他发行版可以运行该项目中的hn-config.sh脚本。如果你是使用hn-install来安装的，也可以直接`sudo jlu-config`来配置。网络配置只支持NetworkManager。自动保存等操作被硬编码在了/opt/drclient中，你可以根据下面的说明来在你的安装目录中手动输入这些内容到`DrClientConfig`中，或者在脚本中把`JLU_CONFIG="/opt/drclient/DrClientConfig"`改为软件所在目录。

### 手动网络设置（NetworkManager）

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

### 手动配置自动登录

Q: 如何自动保存密码、自动登录？客户端的自动保存、自动登录功能没有用？

A: 自动保存、自动登录功能需要文件`DrClientConfig`在软件目录下。格式如下：

```ini

[DrClientConfig]
Account=你的账户名
Passoword="你的密码的base64编码" ; 注意是passoword不是password
Adapter= ; 参数非必要
AutoLogin=1 ; 自动登录
SavePassword=1 ; 保存密码
Ext= ; 参数非必要

```

你可以运行下面代码创建。

```bash

# 切换到软件目录
cd /opt/drclient

# 创建文件
sudo touch DrClientConfig

# 确保权限正确
sudo chmod 644 ./DrClientConfig

# 写入文件，你也可以使用vim等编辑器手动填写
sudo cat > DrClientConfig << 'EOF'
[DrClientConfig]
Account=你的账户名
Passoword="你的密码的base64编码"
Adapter=
AutoLogin=1
SavePassword=1
Ext=
EOF

```

## 项目结构

jlu-drcom-1.0.0存放着吉林大学官网的Linux版本客户端文件,但是删除了官方的配置脚本，改成以`sudo`运行`hn-config.sh`来配置网络和信息，此外还重写了`hostinfo.sh`,`pppoe-status`等文件。将这个文件`tar -cJf jlu-drcom-1.0.0.tar.xz ./jlu-drcom-1.0.0`打包成jlu-drcom-1.0.0.tar.xz后根据PKGBUILD。在当前目录目录运行`makepkg -si`安装。release的文件即为打包生成的`jlu-drcom-1.0.0-1-x86_64.pkg.tar.zst`。

## 版权与免责声明

### 版权归属

该软件包 (jlu-drcom-bin) 仅为一个非官方的、社区维护的 Arch Linux 打包脚本，其目的是为了方便用户在 Arch Linux 系统上安装和使用吉林大学校园网认证客户端。软件包中所分发的可执行文件、动态库、资源文件等（包括但不限于 DrClientLinux、libjpeg.so.62、libpng12.so.0、drcomauthsvr 等）的所有版权和相关知识产权，均归其原始权利人所有。

### 免责声明

该软件包并非由吉林大学、Dr.COM 公司或其任何官方机构发布、认可或维护。使用该软件包的风险完全由用户自行承担。本软件包仅出于学习和方便个人使用的目的而创建。用户应遵守吉林大学校园网使用规定以及相关法律法规。作者无法保证及时修复其中的安全漏洞。用户应自行评估使用风险。

### 许可证

该软件包的打包脚本（即 PKGBUILD，hn-config.sh, hostinfo.sh 等相关文件）采用 MIT 许可证 发布，允许任何人自由使用、修改和分发。但对于软件包内包含的第三方二进制文件，其使用受原始版权条款的约束。用户如需将其用于商业目的或进行再分发，应自行获取原始权利人的许可。
