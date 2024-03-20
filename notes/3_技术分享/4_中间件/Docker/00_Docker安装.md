# Docker 安装

### 移除残留docker

```
sudo yum remove docker \ docker-client \ docker-client-latest \docker-common \docker-latest \docker-latest-logrotate \docker-logrotate \ocker-engine
```

### 开始安装

##### 1.yum安装

安装yum工具

```
yum install -y yum-utils
```

添加镜像站点

```
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

安装 Docker 所需的一些依赖包：

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

安装docker

```shell
// 这个是安装老版本的
yum install -y docker
// 这个是安装最新社区版本 推荐用这个
yum install docker-ce docker-ce-cli containerd.io
```

查看是否安装成功

```shell
yum list installed | grep docker
```

##### 2.离线安装

https://docs.docker.com/engine/install/binaries/#install-daemon-and-client-binaries-on-linux

https://www.gold404.cn/info/140

下载二[进制包](https://download.docker.com/linux/static/stable/x86_64/) 上传服务器并解压

```shell
tar -zxvf docker-19.03.5.tgz
```

将docker 相关命令拷贝到 /usr/bin

```shell
cp docker/* /usr/bin/
```

将docker注册为服务

```shell
vi /etc/systemd/system/docker.service
```

```shell
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target
 
[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
 
[Install]
WantedBy=multi-user.target
```

添加执行权限

```shell
chmod +x /etc/systemd/system/docker.service
```

重新加载配置文件（每次有修改docker.service文件时都要重新加载下）

```shell
systemctl daemon-reload
```

### 启动docker

```shell
systemctl start docker.service
```

```
systemctl enable docker.service
```

```
systemctl status docker
```

```
systemctl stop docker.service
```

```
systemctl disable docker.service
```

