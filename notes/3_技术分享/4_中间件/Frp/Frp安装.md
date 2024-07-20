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
docker run --restart=always --network host -d -v /home/frp/frps.toml:/etc/frp/frps.toml --name frps snowdreamtech/frps:0.54.0
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

