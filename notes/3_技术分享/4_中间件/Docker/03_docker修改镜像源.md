https://www.jianshu.com/p/dfd30e94b517

修改docker镜像仓库配置

```
vim /etc/docker/daemon.json
```

修改配置文件

```
{
  "registry-mirrors": ["https://registry.docker-cn.com","http://hub-mirror.c.163.com"]
}
```

使配置文件生效

```
systemctl daemon-reload
```

重启Docker

```
service docker restart
```

测试配置是否成功

```
docker search nginx
```

