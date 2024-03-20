## docker安装

```
docker pull redis:7.2
```

```
mkdir /home/application/redis
```

```
cd /home/application/redis && wget http://download.redis.io/redis-stable/redis.conf
```

```
chmod 777 /home/application/redis/redis.conf
```

```
vi /home/application/redis/redis.conf
```

```shell
bind 127.0.0.1 # 这行要注释掉，解除本地连接限制
protected-mode no # 默认yes，如果设置为yes，则只允许在本机的回环连接，其他机器无法连接。
daemonize no # 默认no 为不守护进程模式，docker部署不需要改为yes，docker run -d本身就是后台启动，不然会冲突
requirepass 123456 # 设置密码
appendonly yes # 持久化
```

```shell
docker run --name redis \
    -p 6379:6379 \
    -v /home/application/redis/redis.conf:/etc/redis/redis.conf \
    -v /home/application/redis:/data \
    -d redis:7.2 redis-server /etc/redis/redis.conf
```

```shell
docker run -d --name redis -p 6379:6379 redis --requirepass asiainfo5G
```

参考文章：

1. [Docker安装Redis并配置文件启动](https://developer.aliyun.com/article/913891)

## 二进制安装

官网地址：https://redis.io/

下载并解压安装包 https://download.redis.io/releases/

```bash
cd /usr/local
wget https://download.redis.io/releases/redis-7.2.4.tar.gz
tar -zxvf redis-7.2.4.tar.gz -C /usr/local/
mv redis-7.2.4/ redis
```

编译

```bash
cd /usr/local/redis
make && cd src/ && make install
```

设置环境变量

```bash
# 编辑配置
vim /etc/profile
# 写入配置 路径换成自己的
export PATH=$PATH:/usr/local/redis/src
# 生效配置
source /etc/profile
# 验证
redis-server --version
```

修改配置文件

```bash
vim /usr/local/redis/redis.conf
# 使用"/ 要搜索的内容"，回车，直接快速定位文档中的位置
# 注释下面 打开远程链接
bind 127.0.0.1 -::1
# 修改保护模式，不修改保护模式也是只能内网访问的 protected-mode yes 改成 protected-mode no
protected-mode no
# daemonize no 改为yes 后台一直运行
daemonize yes
# 设置密码，这里建议设置密码，否则可能会发生一些预料不到的事情，因为6379端口有漏洞
requirepass password
```

开放端口

```bash
# 查看端口状态：no 表示未开启
firewall-cmd --query-port=6379/tcp
# 永久开放端口
firewall-cmd --add-port=6379/tcp --permanent
# 重启防火墙
systemctl restart firewalld
```

启动

```bash
# 一次性启动
redis-server /usr/local/redis/redis.conf

redis-cli -h 127.0.0.1 -p 6379 -a password shutdown

ps -ef | grep redis
```

开机自启---**<u>没用到，重启后似乎还能自动启动</u>**

```bash
# 创建文件
vim /lib/systemd/system/redis.service
# 写入以下配置
[Unit]
Description=redis-server
After=network.target

[Service]
Type=forking
# ExecStart需要按照实际情况修改成自己的地址
ExecStart=/usr/local/redis/src/redis-server /usr/local/redis/redis.conf
PrivateTmp=true

[Install]
WantedBy=multi-user.target

# 设置开机自启
systemctl start redis.service
systemctl enable redis.service
# 重启redis
systemctl start redis.service
```

参考文章

1. [Centos安装Redis](https://blog.csdn.net/qq_38584262/article/details/125773286)
2. [Redis6设置自启动CentOS](https://blog.csdn.net/zwrlj527/article/details/113374863) 