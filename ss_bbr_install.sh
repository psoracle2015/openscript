#!/usr/bin/env bash

# wget --no-check-certificate -O ss_bbr_install.sh https://raw.githubusercontent.com/psoracle2015/openscript/master/ss_bbr_install.sh && bash ss_bbr_install.sh MzU4MmQ4N2E5MjIx

password="${1:-MzU4MmQ4N2E5MjIx}"

# 禁止iptables
systemctl stop firewalld 2>&1
systemctl disable firewalld 2>&1

# 安装shadowsocks
yum makecache
yum -y install vim wget m2crypto python-setuptools
easy_install pip
pip install shadowsocks

# 生成shadowsocks配置文件
cat > /etc/shadowsocks.json << EOF
{
    "server": "0.0.0.0",
    "method": "aes-256-cfb",
    "timeout": 600,
    "port_password":
    {
        "8108": "${password}"
    }
}
EOF

# 添加开机自动启动
echo '/bin/python /bin/ssserver -c /etc/shadowsocks.json -d start' >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

# 安装Google BBR 加速
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod +x bbr.sh
echo "Y" | ./bbr.sh


