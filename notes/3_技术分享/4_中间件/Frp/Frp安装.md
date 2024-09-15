> 官方文档 https://gofrp.org/zh-cn/



## frps服务端

### docker

```shell
mkdir -p /home/frp
cd /home/frp/
touch frps.toml
```

```shell
docker pull snowdreamtech/frps:0.54.0
```

```shell
docker run --restart=always --network host -d -v /home/application/frps/frps.toml:/etc/frp/frps.toml --name frps snowdreamtech/frps:0.54.0
```

```
docker run --restart=always --network host -d --name frps snowdreamtech/frps:0.54.0
```

进入容器

```
docker exec -it frps /bin/sh
```

```toml
# 绑定端口
bindPort = 7000
# 鉴权
auth.token = "1231312"
# 端口白名单，防止端口被滥用，可以手动指定允许哪些端口被使用，
allowPorts = [
  { start = 2000, end = 3000 },
  { single = 3001 },
  { single = 3003 },
  { start = 4000, end = 50000 }
]


# dashboard
webServer.addr = "0.0.0.0"
webServer.port = 7500
webServer.user = "admin"
webServer.password = "YQv$zxczkx"
```

### Linux

```bash
cd /usr/local
wget https://github.com/fatedier/frp/releases/download/v0.54.0/frp_0.54.0_linux_amd64.tar.gz

tar -zxvf frp_0.54.0_linux_amd64.tar.gz -C /usr/local
mv frp_0.54.0_linux_amd64 frp


vim /etc/systemd/system/frps.service

[Unit]
# 服务名称，可自定义
Description = frp server
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# 启动frps的命令，需修改为您的frps的安装路径
ExecStart = /usr/local/frp/frps -c /usr/local/frp/frps.toml

[Install]
WantedBy = multi-user.target

# 启动frp
systemctl start frps
# 停止frp
systemctl stop frps
# 重启frp
systemctl restart frps
# 查看frp状态
systemctl status frps

# 设置开机自启
systemctl enable frps
```



## frpc客户端

### windows

下载地址： https://github.com/fatedier/frp/releases

解压后修改frpc.toml文件，cmd启动

```
frpc.exe -c frpc.toml
```

修改frpc.toml配置

## docker

```
docker pull snowdreamtech/frpc:0.54.0
 
docker run --restart=always --network host -d -v /home/application/frpc/frpc.toml:/etc/frp/frpc.toml --name frpc snowdreamtech/frpc:0.54.0
```

