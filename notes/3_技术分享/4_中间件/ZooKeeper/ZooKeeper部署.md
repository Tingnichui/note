## docker部署

> docker文档： https://hub.docker.com/r/bitnami/zookeeper

```bash
docker pull bitnami/zookeeper:3.9.2
```

#### 不带密码认证

```bash
docker run -d --name zookeeper \
    -p 2181:2181 \
    -e ALLOW_ANONYMOUS_LOGIN=yes \
    bitnami/zookeeper:3.9.2 | xargs docker logs -f
```

#### 密码认证

```bash
docker run -d --name zookeeper \
    -p 2181:2181 \
    -e ZOO_ENABLE_AUTH=yes \
    -e ZOO_SERVER_USERS=admin \
    -e ZOO_SERVER_PASSWORDS=password \
    -e ZOO_CLIENT_USER=admin \
    -e ZOO_CLIENT_PASSWORD=password \
    bitnami/zookeeper:3.9.2 | xargs docker logs -f 
```