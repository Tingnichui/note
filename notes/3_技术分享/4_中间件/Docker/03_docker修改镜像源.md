https://www.jianshu.com/p/dfd30e94b517

修改docker镜像仓库配置

```
vim /etc/docker/daemon.json
```

修改配置文件

```
{
 "registry-mirrors" : [
   "https://mirror.ccs.tencentyun.com",
   "http://registry.docker-cn.com",
   "http://docker.mirrors.ustc.edu.cn",
   "http://hub-mirror.c.163.com"
 ],
 "insecure-registries" : [
   "registry.docker-cn.com",
   "docker.mirrors.ustc.edu.cn"
 ],
 "debug" : true,
 "experimental" : true
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

参考文章

1. https://blog.csdn.net/weixin_40118894/article/details/117222349
