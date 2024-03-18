## Kafka

### docker部署

| 配置名称                       |                                                              |
| ------------------------------ | ------------------------------------------------------------ |
| KAFKA_CFG_LISTENERS            | 指定 Kafka 服务器监听客户端连接的地址和端口，区分Broker节点与Controller节点 |
| KAFKA_CFG_ADVERTISED_LISTENERS | **广播给客户端的地址和端口**，通常配置为 **Kafka 所在服务器的外网地址**。 |
|                                |                                                              |

#### 部署准备

```bash
# 拉去镜像
docker pull bitnami/kafka:3.7.0
# 创建数据挂载目录
mkdir -p /home/application/kafka/kafka_data
# 挂载目录授权 NOTE: As this is a non-root container, the mounted files and directories must have the proper permissions for the UID 1001.
chown -R 1001:1001 /home/application/kafka/kafka_data
```

#### 不设置安全认证

```bash
docker run -d --name kafka \
	--restart=always \
    -p 9092:9092 \
    --link zookeeper \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://192.168.139.102:9092 \
    -v /home/application/kafka/kafka_data:/bitnami/kafka \
    bitnami/kafka:3.7.0 | xargs docker logs -f 
```

#### 设置密码认证

```bash
docker run -d --name kafka \
	-p 9092:9092 \
    --link zookeeper \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    
    -e ALLOW_PLAINTEXT_LISTENER=yes \
    -e KAFKA_CLIENT_LISTENER_NAME=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENERS=PLAINTEXT://:9092，CONTROLLER://:9093 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://:9092 \
    -e KAFKA_CLIENT_USERS=user \
    -e KAFKA_CLIENT_PASSWORDS=password \
    -e KAFKA_CFG_SASL_MECHANISM_INTER_BROKER_PROTOCOL=SASL_PLAINTEXT \
    -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT \
	bitnami/kafka:3.7.0 | xargs docker logs -f 
```

```
addauth digest admin:password
setAcl / auth:admin:cdrwa
```

kafka设置sasl认证

```shell
# zk设置了sasl
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

```bash
# zk未设置安全认证
docker run -d --name kafka \
	--restart=always \
    -p 9092:9092 \
    --link zookeeper \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://192.168.139.102:9092 \
    bitnami/kafka:3.7.0 | xargs docker logs -f 
```



```shell
docker run -d --name kafka_sasl \
    -p 9092:9092 \
    --link zookeeper \
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

#### 参考文章

1. https://hub.docker.com/r/bitnami/kafka
2. https://zhuanlan.zhihu.com/p/586005021
3. [Kafka服务端参数配置](https://blog.csdn.net/weixin_52851967/article/details/128173919)
4. [一文搞懂Kafka中的listeners和advertised.listeners以及其他通信配置](https://blog.51cto.com/szzdzhp/5683496)
5. [kafka各种环境安装(window,linux,docker,k8s),包含KRaft模式](https://blog.csdn.net/qq_38263083/article/details/132341449)



## tar部署

#### 参考文章

1. 官方文档：https://kafka.apache.org/documentation/#quickstart

