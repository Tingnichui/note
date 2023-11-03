# MySQL

[ERROR 1045 (28000): Access denied for user 'mysql'@'localhost' (using password: YES)解决方法 ](http://t.csdn.cn/KAAUN)

拉取mysql

```
docker pull mysql:8.0.34
docker pull mysql:5.7.42
```

运行容器

```shell
docker run --name mysql \
    --network tingnichui \
    --network-alias mysql \
    --restart=always \
    -p 3306:3306 \
    -v /home/mysql/log:/var/log/mysql  \
    -v /home/mysql/data:/var/lib/mysql  \
    -v /home/mysql/conf:/etc/mysql/conf.d \
    -e TZ=Asia/Shanghai  \
    -e MYSQL_ROOT_PASSWORD=password  \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_general_ci \
    -d mysql:8.0.34
```

进入容器

```shell
docker exec -it mysql bash
mysql -uroot -ppassword
```



```bash
连接异常 2059 - authentication plugin ‘caching_sha2_password
先查看一下加密的方式
show variables like 'default_authentication_plugin';
查看本地mysql用户的信息
select host,user,plugin from mysql.user;
修改root账户的加密方式为【mysql_native_password】
如果是远程连接的话请将'localhost'换成'%'
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER; #更改加密方式
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; #更新用户密码
FLUSH PRIVILEGES; #刷新一下权限
exit #退出MySQL 
```

# Redis

[史上最详细Docker安装Redis （含每一步的图解）实战](https://blog.csdn.net/weixin_45821811/article/details/116211724?ops_request_misc=&request_id=&biz_id=102&utm_term=docker%20%E5%AE%89%E8%A3%85redis&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-116211724.nonecase&spm=1018.2226.3001.4187) 

```
docker run -d --name redis -p 6379:6379 redis --requirepass asiainfo5G
```



```bash
docker pull redis
mkdir /home/redis
```

创建并上传redis.conf 到 /home/redis 下

```shell
# bind 192.168.1.100 10.0.0.1
# bind 127.0.0.1 ::1
# bind 127.0.0.1

protected-mode no

port 6379

tcp-backlog 511

requirepass 000415

timeout 0

tcp-keepalive 300

daemonize no

supervised no

pidfile /var/run/redis_6379.pid

loglevel notice

logfile ""

databases 30

always-show-logo yes

save 900 1
save 300 10
save 60 10000

stop-writes-on-bgsave-error yes

rdbcompression yes

rdbchecksum yes

dbfilename dump.rdb

dir ./

replica-serve-stale-data yes

replica-read-only yes

repl-diskless-sync no

repl-disable-tcp-nodelay no

replica-priority 100

lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no

appendonly yes

appendfilename "appendonly.aof"

no-appendfsync-on-rewrite no

auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

aof-load-truncated yes

aof-use-rdb-preamble yes

lua-time-limit 5000

slowlog-max-len 128

notify-keyspace-events ""

hash-max-ziplist-entries 512
hash-max-ziplist-value 64

list-max-ziplist-size -2

list-compress-depth 0

set-max-intset-entries 512

zset-max-ziplist-entries 128
zset-max-ziplist-value 64

hll-sparse-max-bytes 3000

stream-node-max-bytes 4096
stream-node-max-entries 100

activerehashing yes

hz 10

dynamic-hz yes

aof-rewrite-incremental-fsync yes

rdb-save-incremental-fsync yes
```

运行容器

```shell
docker run -d --name redis \
    --network tingnichui \
    --network-alias redis \
    --restart always \
    --log-opt max-size=100m \
    --log-opt max-file=2 \
    --appendonly yes \
    -p 6379:6379 \
    -v /home/redis/redis.conf:/etc/redis/redis.conf \
    -v /home/redis/data:/data \
    -e REDIS_PASSWORD=password \
    redis redis-server /etc/redis/redis.conf 
```

进入容器查看一下

```shell
docker exec -it redis redis-cli
auth password
config get requirepass
```

# Nginx

配置

```xml
server {
listen       80;
listen  [::]:80;
server_name  openwrt.tingnichui.com;

location / {
proxy_pass http://10.0.12.17:120;
}

}


upstream frps {
server frps:7500 weight=1;
}

```

启用一个nginx服务

```bash
docker pull nginx

# 创建挂载目录
mkdir -p /home/nginx/conf
mkdir -p /home/nginx/log
mkdir -p /home/nginx/html

# 生成容器
docker run --restart=always --name nginx -p 80:80 -d nginx
# 将容器nginx.conf文件复制到宿主机
docker cp nginx:/etc/nginx/nginx.conf /home/nginx/conf/nginx.conf
# 将容器conf.d文件夹下内容复制到宿主机
docker cp nginx:/etc/nginx/conf.d /home/nginx/conf/conf.d
# 将容器中的html文件夹复制到宿主机
docker cp nginx:/usr/share/nginx/html /home/nginx/

# 删除容器
docker rm -f nginx

docker run --network tingnichui --network-alias nginx --restart=always -e TZ=Asia/Shanghai -p 80:80 -p 443:443 --name nginx -v /home/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /home/nginx/conf/conf.d:/etc/nginx/conf.d -v /home/nginx/log:/var/log/nginx -v /home/nginx/html:/usr/share/nginx/html -v /home/nginx/certs:/etc/nginx/certs -d nginx
```

```shell
docker run -d --name nginx \
    --network tingnichui \
    --network-alias nginx \
    --restart always \
    -e TZ=Asia/Shanghai \
    -p 80:80 \
    -p 443:443 \
    -v /home/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
    -v /home/nginx/conf/conf.d:/etc/nginx/conf.d \
    -v /home/nginx/log:/var/log/nginx \
    -v /home/nginx/html:/usr/share/nginx/html \
    -v /home/nginx/certs:/etc/nginx/certs \
    nginx
```

集群

[Nginx构建高可用集群，实现负载均衡应对高并发](https://cloud.tencent.com/developer/article/1853648?from=15425&areaSource=102001.1&traceId=FQyS1K1p5v9QWaq3v5z2-) 

[WEB服务如何平滑的上下线](https://juejin.cn/post/7124865790074945544) 

# Nacos

```bash
docker pull nacos/nacos-server

docker run -d -e prefer_host_mode=centos的IP地址 -e MODE=standalone -v  /home/nacos/logs:/home/nacos/logs -p 8848:8848 --name nacos --restart=always nacos/nacos-server

docker cp nacos:/home/nacos/conf /home/nacos

#下面三个命令都可以用 我用的最后一个
docker run -d -e prefer_host_mode=centos的IP地址 -e MODE=standalone -v /home/nacos/logs:/home/nacos/logs -v /home/nacos/conf:/home/nacos/conf -p 8848:8848 --name nacos --restart=always nacos/nacos-server

docker run -d -e MODE=standalone -e SPRING_DATASOURCE_PLATFORM=mysql -e MYSQL_SERVICE_HOST=centos的IP地址 -e MYSQL_SERVICE_PORT=3306 -e MYSQL_SERVICE_USER=root -e MYSQL_SERVICE_PASSWORD=chunhui -e MYSQL_SERVICE_DB_NAME=nacos -e TIME_ZONE='Asia/Shanghai' -v /home/nacos/logs:/home/nacos/logs -v /home/nacos/conf:/home/nacos/conf -p 8848:8848 --name nacos --restart=always nacos/nacos-server

docker run  --memory=600m --network tingnichui --network-alias nacos -e JVM_XMS=256m -e JVM_XMX=256m -e JVM_XMN=128m -e MODE=standalone -e SPRING_DATASOURCE_PLATFORM=mysql -e MYSQL_SERVICE_HOST=mysql -e MYSQL_SERVICE_PORT=3306 -e MYSQL_SERVICE_USER=root -e MYSQL_SERVICE_PASSWORD=chunhui -e MYSQL_SERVICE_DB_NAME=nacos_config -e TIME_ZONE='Asia/Shanghai' -v /home/nacos/logs:/home/nacos/logs -v /home/nacos/conf:/home/nacos/conf -p 8848:8848 -p 9848:9848 -p 9849:9849 --name nacos --restart=always -d nacos/nacos-server


docker exec -it nacos /bin/bash
```



# RabbitMQ

```bash
docker pull rabbitmq

docker run --network tingnichui --network-alias rabbitmq --restart=always -e TIME_ZONE='Asia/Shanghai' -e vm_memory_high_watermark=128m --hostname tingnichui  -e RABBITMQ_DEFAULT_USER=root -e RABBITMQ_DEFAULT_PASS=chunhui --name rabbitmq -p 15672:15672 -p 5672:5672 -d rabbitmq

--memory=128m 这个命令可以限制占用内存
```

```shell
docker run -d --name rabbitmq \
    --network tingnichui \
    --network-alias rabbitmq \
    --restart always \
    -e TIME_ZONE='Asia/Shanghai' \
    -e vm_memory_high_watermark=128m \
    --hostname tingnichui \
    -e RABBITMQ_DEFAULT_USER=root \
    -e RABBITMQ_DEFAULT_PASS=chunhui \
    -p 15672:15672 \
    -p 5672:5672 \
    rabbitmq
```

```shell
docker exec -it rabbitmq /bin/bash
rabbitmq-plugins enable rabbitmq_management
```

# Sentinel

```bash
docker run --name sentinel --restart=always --network tingnichui  --network-alias sentinel -p 8858:8858 -e AUTH_PASSWORD=chunhui -d  bladex/sentinel-dashboard
```

```shell
docker run -d --name sentinel \
    --restart always \
    --network tingnichui \
    --network-alias sentinel \
    -p 8858:8858 \
    -e AUTH_PASSWORD=password \
    bladex/sentinel-dashboard
```

# ELK(未成功)

[docker安装ELK详细步骤](https://blog.csdn.net/yuemancanyang/article/details/122769308?ops_request_misc=&request_id=&biz_id=102&utm_term=docker%20elk&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-122769308.142%5Ev59%5Ejs_top,201%5Ev3%5Econtrol_2&spm=1018.2226.3001.4187) 

```bash
docker run --network tingnichui --network-alias es --restart=always --name es -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e "discovery.type=single-node" -p 9200:9200 -p 9300:9300 -d elasticsearch:7.16.1




mkdir -p /home/elk/es/{config,data,logs}

vi /home/elk/es/config/elasticsearch.yml
-----------------------配置内容----------------------------------
cluster.name: "my-es"
network.host: 0.0.0.0
http.port: 9200

chmod 777 /home/elk
chmod 777 /home/elk/es
chmod 777 /home/elk/es/config
chmod 777 /home/elk/es/data
chmod 777 /home/elk/es/logs

#指定好版本
docker run -it -d -p 9200:9200 -p 9300:9300 --name es -e ES_JAVA_OPTS="-Xms1g -Xmx1g" -e "discovery.type=single-node" --restart=always -v /home/elk/es/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /home/elk/es/data:/usr/share/elasticsearch/data -v /home/elk/es/logs:/usr/share/elasticsearch/logs elasticsearch:7.17.5


cd /home/elk/es/config
touch elasticsearch.yml
-----------------------配置内容----------------------------------
cluster.name: "my-es"
network.host: 0.0.0.0
http.port: 9200


docker run -it -d -p 9200:9200 -p 9300:9300 --name es -e ES_JAVA_OPTS="-Xms1g -Xmx1g" -e "discovery.type=single-node" --restart=always -v /home/elk/es/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /home/elk/es/data:/usr/share/elasticsearch/data -v /home/elk/es/logs:/usr/share/elasticsearch/logs elasticsearch:8.4.3
```



```shell
docker pull kibana:8.4.3
```

```shell
docker pull logstash:8.4.3
```

# Jenkins

[Docker 搭建 Jenkins 容器 (完整详细版)](https://blog.csdn.net/BThinker/article/details/124178670?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167186501316800225543226%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167186501316800225543226&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-5-124178670-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=docker%20jekins&spm=1018.2226.3001.4187) 

[Docker+Jenkins一键自动化部署、超简单~](https://blog.csdn.net/weixin_45647685/article/details/127825728) 

[docker安装jenkins并且通过jenkins部署项目(超详细and靠谱)](https://blog.csdn.net/lzc2644481789/article/details/124888223?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167189273816782429748489%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167189273816782429748489&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-124888223-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=docker%20jenkins&spm=1018.2226.3001.4187) 

xxxxxxxxxx  docker update [OPTIONS] CONTAINER [CONTAINER…] docker update -m 600m --memory-swap 600m nacosbash

[jenkins 的两种SSH执行远程脚本方式](https://huaweicloud.csdn.net/635638dfd3efff3090b5b163.html?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-3-121927959-blog-90900215.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-3-121927959-blog-90900215.pc_relevant_default&utm_relevant_index=6) 

[SSH: Transferred 0 file(s) 解决](https://blog.csdn.net/weixin_33847182/article/details/94026304?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167246856516782425647044%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167246856516782425647044&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-94026304-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=Transferred%200%20file%28s%29&spm=1018.2226.3001.4187) 

[Jenkins常用插件之Publish Over SSH](https://blog.csdn.net/jiang1986829/article/details/51275361) 

```shell
# 创建目录并赋予权限
mkdir -p /home/jenkins/jenkins_home
chmod 777 /home/jenkins/jenkins_home

# 创建容器
docker pull jenkins/jenkins:latest
docker run -d -u root -m 1000m -p 8080:8080 -p 50000:50000 -v /jenkins/jenkins_home:/var/jenkins_home -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -e TIME_ZONE='Asia/Shanghai' --restart always --name jenkins jenkins/jenkins

docker run -d 
	-u root \
	-m 1000m \
	-p 8080:8080 \
	-p 50000:50000 \
    -v /jenkins/jenkins_home:/var/jenkins_home \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e TIME_ZONE='Asia/Shanghai' \
    --restart always \
    --name jenkins \
    jenkins/jenkins


# 修改源
cd /home/jenkins/jenkins_home/
vim hudson.model.UpdateCenter.xml
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
docker restart jenkins

# 进入容器查看是否能使用docker命令
docker exec -it jenkins bash

# 安装插件
安装 Maven Integration
安装 Publish Over SSH（如果不需要远程推送，不用安装）
如果使用 Gitee 码云，安装插件Gitee（这里我们使用gitee）

# 配置maven【首页】–【系统管理】–【全局工具配置】，拉到页面最下方 maven–maven 安装
apache-maven-3.8.6

# 新建任务---》源码管理和添加凭证---》构建选择maven
clean install -Dmaven.test.skip=true

# SSH 推送远端服务器 注意传输路径是相对地址，根目录是当前工作目录

# pos
cd /home/jenkins/tingnichui/tingnichui-pos
docker stop pos || true
docker rm pos || true
docker rmi tingnichui-pos || true
docker build -t tingnichui-pos .
docker run --memory=400m --restart=always --network tingnichui --network-alias pos -e NACOS_HOST=nacos -v /home/tingnichui/logs/pos:/logs --name pos -d -p 1130:1130 tingnichui-pos:latest

# user
cd /home/jenkins/tingnichui/tingnichui-user/tingnichui-user-biz
docker stop user || true
docker rm user || true
docker rmi tingnichui-user-biz || true
docker build -t tingnichui-user-biz .
docker run --memory=400m --restart=always --network tingnichui --network-alias user -e NACOS_HOST=nacos -v /home/tingnichui/logs/user:/logs --name user -d -p 1128:1128 tingnichui-user-biz:latest

# stock
cd /home/jenkins/tingnichui/tingnichui-stock
docker stop stock || true
docker rm stock || true
docker rmi tingnichui-stock || true
docker build -t tingnichui-stock .
docker run --memory=400m --restart=always --network tingnichui --network-alias stock -e NACOS_HOST=nacos -v /home/tingnichui/logs/stock:/logs --name stock -d -p 1129:1129 tingnichui-stock:latest

# gateway
cd /home/jenkins/tingnichui/tingnichui-gateway
docker stop gateway || true
docker rm gateway || true
docker rmi tingnichui-gateway || true
docker build -t tingnichui-gateway .
docker run --memory=400m --restart=always --network tingnichui --network-alias gateway -e NACOS_HOST=nacos -v /home/tingnichui/logs/gateway:/logs --name gateway -d -p 8888:8888 tingnichui-gateway:latest

```

# FRP内网穿透

> 注意：服务端修改frps.ini  |  客户端修改frpc.init

https://gitee.com/hankinsli/natserver

[docker 搭建frp内网穿透以及frp详细使用](https://blog.csdn.net/qq_37493888/article/details/123633110?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167292219116800222848780%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167292219116800222848780&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-3-123633110-null-null.142^v70^one_line,201^v4^add_ask&utm_term=docker%E9%83%A8%E7%BD%B2frp&spm=1018.2226.3001.4187) 

[使用frp进行内网穿透，实现ssh远程访问Linux](https://blog.csdn.net/qq_44577070/article/details/121893406?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167292486616800215010194%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167292486616800215010194&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-121893406-null-null.142^v70^one_line,201^v4^add_ask&utm_term=frps%20ssh&spm=1018.2226.3001.4187) 

#### 服务端部署frps

docker 部署frps

```bash
mkdir -p /home/frp && cd /home/frp

vim frps.ini
# 服务端配置
[common]
# 监听端口
bind_port = 7000
# 面板端口
dashboard_port = 7500
# 登录面板账号设置
dashboard_user = admin
dashboard_pwd = chunhui

docker pull snowdreamtech/frps

# --network host 貌似只能用host，不然腾讯云不会穿透端口
docker run -d -m 100m --network host -v /home/frp/frps.ini:/etc/frp/frps.ini --name frps --restart always snowdreamtech/frps

docker run -d \
	-m 100m \
	--network host \
    -v /home/frp/frps.ini:/etc/frp/frps.ini \
    --name frps \
    --restart always \
    snowdreamtech/frps
```

#### 客户端部署frpc

 docker部署frpc

```shell
mkdir -p /home/frp && cd /home/frp

vim frpc.ini
# 服务端参数
[common]
# server_addr为FRPS服务器IP地址
server_addr = x.x.x.x
# server_port为服务端监听端口，bind_port
server_port = 7000
# 身份验证
token = chunhui

docker pull snowdreamtech/frpc

docker run -d -m 100m --restart always --network host --name frpc -v /home/frp/frpc.ini:/etc/frp/frpc.ini snowdreamtech/frpc

docker run -d -m 100m \
	--restart always \
	--network host \
    --name frpc \
    -v /home/frp/frpc.ini:/etc/frp/frpc.ini \
    snowdreamtech/frpc

```

ssh

```bash
[ssh] # 不要重名
type = tcp # 连接的类型
local_ip = 127.0.0.1 # 中转客户端实际访问的IP
local_port = 22 # 目标端口
remote_port = 2288 # 远程端口
```

http

```bash
[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 80
remote_port = 180
```

```xml
[common]
# server_addr为FRPS服务器IP地址
server_addr = x.x.x.x
# server_port为服务端监听端口，bind_port
server_port = 7000
# 身份验证
token = 12345678

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 2288

# [ssh] 为服务名称，下方此处设置为，访问frp服务段的2288端口时，等同于通过中转服务器访问127.0.0.1的22端口。
# type 为连接的类型，此处为tcp
# local_ip 为中转客户端实际访问的IP 
# local_port 为目标端口
# remote_port 为远程端口

[ssh]
type = tcp
local_ip = 192.168.1.229
local_port = 80
remote_port = 18022

[unRAID web]
type = tcp
local_ip = 192.168.1.229
local_port = 80
remote_port = 18088

[Truenas web]
type = tcp
local_ip = 192.168.1.235
local_port = 80
remote_port = 18188

[speedtest]
type = tcp
local_ip = 192.168.1.229
local_port = 6580
remote_port = 18190


[webdav]
type = tcp
local_ip = 192.168.1.235
local_port = 18080
remote_port = 18189

[RDP PC1]
type = tcp
local_ip = 192.168.1.235
local_port = 3389
remote_port = 18389
```

# zookeeper

https://hub.docker.com/r/bitnami/zookeeper

#### 不带密码认证

```shell
docker run -d \
    --name zookeeper \
    --network tingnichui \
    --network-alias zookeeper \
	-p 2181:2181 \
    -e ALLOW_ANONYMOUS_LOGIN=yes \
    bitnami/zookeeper:latest | xargs docker logs -f 
```

#### 密码认证

```shell
docker run -d --name zookeeper \
    -p 2181:2181 \
	-e ZOO_ENABLE_AUTH=yes \
    -e ZOO_SERVER_USERS=admin \
    -e ZOO_SERVER_PASSWORDS=password \
    -e ZOO_CLIENT_USER=admin \
    -e ZOO_CLIENT_PASSWORD=password \
    bitnami/zookeeper | xargs docker logs -f 
```

# Kafka

https://hub.docker.com/r/bitnami/kafka

#### 不设置密码认证 

连接不带密码认证的zookeeper

```shell
docker run -d --name kafka \
    --network tingnichui \
	--network-alias kafka \
    -p 9092:9092 \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://192.168.139.101:9092 \
    bitnami/kafka:latest | xargs docker logs -f 
```

#### 设置密码认证

```
addauth digest admin:password
setAcl / auth:admin:cdrwa
```

kafka设置sasl认证

```shell
docker run -d --name kafka \
	-p 9092:9092 \
    --link zookeeper \
    -e KAFKA_ZOOKEEPER_PROTOCOL=SASL \
    -e KAFKA_ZOOKEEPER_USER=admin \
    -e KAFKA_ZOOKEEPER_PASSWORD=password \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e ALLOW_PLAINTEXT_LISTENER=yes \
    -e KAFKA_CLIENT_LISTENER_NAME=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092，CONTROLLER://:9093 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://:9092 \
    -e KAFKA_CLIENT_USERS=user \
    -e KAFKA_CLIENT_PASSWORDS=password \
    -e KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT \
	bitnami/kafka | xargs docker logs -f 
```

```shell
docker run -d --name kafka_sasl \
    -p 9092:9092 \
    --network tingnichui \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_CLIENT_LISTENER_NAME=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,SASL_PLAINTEXT://:9093 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092,SASL_PLAINTEXT://localhost:9093 \
    -e KAFKA_CLIENT_USERS=user \
    -e KAFKA_CLIENT_PASSWORDS=password \
    -e KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,SASL_PLAINTEXT:SASL_PLAINTEXT \
    bitnami/kafka | xargs docker logs -f 
```

```shell
docker run \
    -d --name=kafka \
    -p 9092:9092 \
    --link zookeeper \
    -e KAFKA_ZOOKEEPER_PROTOCOL=SASL \
    -e KAFKA_ZOOKEEPER_USER=admin \
    -e KAFKA_ZOOKEEPER_PASSWORD=password \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_CFG_LISTENERS=INTERNAL://:9093,CLIENT://:9092 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=INTERNAL://127.0.0.1:9093,CLIENT://192.168.139.101:9092 \
    -e KAFKA_CLIENT_USERS=user \
    -e KAFKA_CLIENT_PASSWORDS=password \
    -e KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL=PLAIN \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,CLIENT:SASL_PLAINTEXT \
    -e KAFKA_CFG_INTER_BROKER_LISTENER_NAME=INTERNAL \
    bitnami/kafka:latest  | xargs docker logs -f 
```

https://zhuanlan.zhihu.com/p/586005021

# ZooNavigator

```shell
docker pull elkozmon/zoonavigator
```

```shell
docker run -d --name zoonavigator\
    -p 9000:9000 \
    -e HTTP_PORT=9000 \
    elkozmon/zoonavigator:latest | xargs docker logs -f 
```

---

# kafka-map

```shell
docker run -d \
    --name kafka-map \
    --network tingnichui \
	--network-alias kafka-map \
    -p 8080:8080 \
    -e DEFAULT_USERNAME=admin \
    -e DEFAULT_PASSWORD=admin \
    dushixiang/kafka-map:latest | xargs docker logs -f 
```

---

# minio

https://blog.csdn.net/BThinker/article/details/125412751

```
docker run -p 9000:9000 -p 9001:9001 \
     --name minio \
     -d --restart=always \
     -e "MINIO_ACCESS_KEY=aS8LytBsR8Nfkw8v" \
     -e "MINIO_SECRET_KEY=GkWfbLb9iPRKHaMrP5PddlHVDhTmBQk9" \
     minio/minio:RELEASE.2022-10-15T19-57-03Z
```

```
docker run -p 9001:9000 -p 9000:9001 \
    --name minio \
    -d --restart=always \
    -e "MINIO_ACCESS_KEY=aS8LytBsR8Nfkw8v" \
    -e "MINIO_SECRET_KEY=GkWfbLb9iPRKHaMrP5PddlHVDhTmBQk9" \
    minio/minio:RELEASE.2022-10-15T19-57-03Z server /data --console-address ":9001"
```

```
docker run -p 9000:9000 -p 9001:9001 \
    --name minio \
    -d --restart=always \
    minio/minio:RELEASE.2022-10-15T19-57-03Z server /data --console-address ":9001"
```

