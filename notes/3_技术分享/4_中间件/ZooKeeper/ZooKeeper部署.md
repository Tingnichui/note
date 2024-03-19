## docker部署

> docker文档： https://hub.docker.com/r/bitnami/zookeeper

部署准备

```bash
# 拉取镜像
docker pull bitnami/zookeeper:3.9.2
# 创建数据挂载目录
mkdir -p /home/application/zookeeper/zookeeper_data
# 挂载目录授权 NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID 1001.
chown -R 1001:1001 /home/application/zookeeper/zookeeper_data
```

#### 不带密码认证

```bash
docker run -d --name zookeeper \
    -p 2181:2181 \
    -e ALLOW_ANONYMOUS_LOGIN=yes \
    -v /home/application/zookeeper/zookeeper_data:/bitnami/zookeeper \
    bitnami/zookeeper:3.9.2 | xargs docker logs -f
```

#### 密码认证

```bash
docker run -d --name zookeeper \
    -p 2181:2181 \
    -v /home/application/zookeeper/zookeeper_data:/bitnami/zookeeper \
    -e ZOO_ENABLE_AUTH=yes \
    -e ZOO_SERVER_USERS=admin \
    -e ZOO_SERVER_PASSWORDS=password \
    -e ZOO_CLIENT_USER=admin \
    -e ZOO_CLIENT_PASSWORD=password \
    bitnami/zookeeper:3.9.2 | xargs docker logs -f 
```





## 二进制部署

下载地址：https://archive.apache.org/dist/zookeeper/

我这里下载3.9.2

> 自zk3.5.5版本以后，已编译的jar包，尾部有bin标识，应该使用的是apache-zookeeper-3.x.x-bin.tar.gz

![image-20240319141651485](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240319141651485.png)

```bash
cd /usr/local
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.9.2/apache-zookeeper-3.9.2-bin.tar.gz

tar -zxvf apache-zookeeper-3.9.2-bin.tar.gz -C /usr/local

mv apache-zookeeper-3.9.2-bin zookeeper

cp /usr/local/zookeeper/conf/zoo_sample.cfg /usr/local/zookeeper/conf/zoo.cfg 

mkdir -p /usr/local/zookeeper/data

vim /usr/local/zookeeper/conf/zoo.cfg

/usr/local/zookeeper/bin/zkServer.sh start

ps -ef | grep zookeeper

netstat  -anp | grep 2181
```

参考文章

1. [Linux安装Zookeeper](https://cloud.tencent.com/developer/article/2149351)

