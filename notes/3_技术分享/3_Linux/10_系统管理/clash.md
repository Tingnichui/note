```
wget -O /home/application/clash/config.yaml 订阅链接
```

```
#启动 HTTP 代理和 Socks5 代理
vim /etc/profile
#末尾增加一下两行代码
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
#保存然后更新配置
source /etc/profile
```

设置代理

```bash
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
```

取消代理

```
unset  http_proxy  https_proxy  all_proxy
```

验证代理

```
curl -L google.com
```

## 配置服务

```
vim /etc/systemd/system/clash.service
```

```
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/home/application/clash/clash-linux-amd64-v1.18.0 -d /home/application/clash

[Install]
WantedBy=multi-user.target
```

```
systemctl daemon-reload
systemctl enable clash
```

```
systemctl start clash
systemctl restart clash
```

```
systemctl stop clash
```

```
sudo systemctl status clash
journalctl -xe
```

## 参考文章

1. [在 Linux 中使用 Clash](https://blog.iswiftai.com/posts/clash-linux/#clash-%E4%B8%8B%E8%BD%BD)
2. [在 Linux 下使用 Clash 进行全局上网代理及自动订阅代理和规则](https://robinxb.com/posts/2023/clash-on-linux/)
3. [Linux系列 CentOS7使用Clash进行网络代理](https://www.sangmuen.com/?p=277)
4. [clash-on-linux配置](https://kevinello.ltd/2023/03/05/clash-on-linux%E9%85%8D%E7%BD%AE/)
5. [clash官网](https://clash-apps.com/)
6. [Linux 命令下安装与使用 Clash 带 UI 管理界面](https://blog.cyida.com/2023/24ANW6D.html)
7. https://github.com/haishanh/yacd