yum -y install epel-release
yum -y install python-pip
pip install shadowsocks
mkdir /etc/shadowsocks
cat > /etc/shadowsocks/shadowsocks.json << EOF
{
    "server":"123.456.789.0", # 填入shadowsocks服务器IP
    "server_port":8388, # 填入shadowsocks服务端口
    "local_address": "127.0.0.1",
    "local_port":1080, # 可以自定义客户端的代理端口
    "password":"password", # 填入shadowsocks服务的密码
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false,
    "workers": 1
}
EOF

cat > /etc/systemd/system/shadowsocks.service << EOF
[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target
EOF
systemctl enable shadowsocks.service
systemctl start shadowsocks.service
systemctl status shadowsocks.service
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip

echo 如果输出了服务器IP说明ss客户端正常运行

yum -y install privoxy
systemctl enable privoxy
systemctl start privoxy
systemctl status privoxy
echo forward-socks5t / 127.0.0.1:1080 . >> /etc/privoxy/config
echo PROXY_HOST=127.0.0.1 >> /etc/profile
echo export all_proxy=http://\$PROXY_HOST:8118 >> /etc/profile
echo export ftp_proxy=http://\$PROXY_HOST:8118 >> /etc/profile
echo export http_proxy=http://\$PROXY_HOST:8118 >> /etc/profile
echo export https_proxy=http://\$PROXY_HOST:8118 >> /etc/profile
echo export no_proxy=localhost,172.16.0.0/16,192.168.0.0/16.,127.0.0.1,10.10.0.0/16 >> /etc/profile
source /etc/profile
echo 安装完成,	重新登录以保证代理设置生效
