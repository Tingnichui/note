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