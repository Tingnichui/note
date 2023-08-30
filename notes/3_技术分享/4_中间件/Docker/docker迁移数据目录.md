> 1. 在迁移前确认迁移的目标目录空间是否充足
> 2. 在迁移时需停止docker服务，务必在平台不使用时进行迁移

### 查看docker安装目录

Docker 的安装目录通常在 `/var/lib/docker`。

如果已经安装了 Docker，可以使用以下命令来查看 Docker 的安装目录：

```shell
docker info | grep 'Docker Root Dir'
```

```shell
docker system info | grep 'Docker Root Dir'
```

### 停掉docker

```shell
systemctl stop docker
```

查看dokcer服务是否停止完毕

```bash
systemctl status docker
ps -fe | grep docker
```

### 拷贝原数据目录到挂载目录

```
cp -av /var/lib/docker/* /home/docker-lib/
```

### 备份原有数据

```shell
tar -zcvf ./docker_images.tar.gz /var/lib/docker
```

```shell
mv /var/lib/docker /var/lib/docker.bak
```

### 创建软链接

```
ln -s /home/docker-lib /var/lib/docker
```

查看软链接是否生效

```bash
ll /var/lib/docker
```

### 启动docker服务

```
systemctl start docker
```

### 删掉备份目录

```
rm -rf /var/lib/docker_bk
```

## 参考文章

1. [linux查看docker安装目录怎么找？](https://www.yunshbk.com/jiaoyu/441.html)
2. [Docker数据目录迁移解决方案](https://www.cnblogs.com/cheyunhua/p/17056056.html)
3. [Docker目录迁移](https://www.python100.com/html/108434.html)
4. [软链接迁移docker存储目录](https://zhuanlan.zhihu.com/p/568784006)

