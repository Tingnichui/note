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

```
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

```
docker run -d --name redis -p 6379:6379 redis --requirepass asiainfo5G
```

参考文章：

1. [Docker安装Redis并配置文件启动](https://developer.aliyun.com/article/913891)