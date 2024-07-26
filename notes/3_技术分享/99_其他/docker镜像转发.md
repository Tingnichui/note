购买域名

Cloudflare 注册账号

增加站点

![image-20240726231922597](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726231922597.png)

获取到cloudflare给的dns地址

![image-20240726232204041](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726232204041.png)

修改域名dns服务器（以阿里云为例）

![image-20240726230557153](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726230557153.png)

修改完之后等带生效



首先 fork https://github.com/ciiiii/cloudflare-docker-proxy 仓库到自己账号下。

![image-20240726232421111](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726232421111.png)

![image-20240726232528575](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726232528575.png)



![image-20240726232615034](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240726232615034.png)

修改docker镜像配置

```
vim /etc/docker/daemon.json
```

```
{
 "registry-mirrors" : [
   "修改成自己的地址"
 ],
 "insecure-registries" : [
   "registry.docker-cn.com",
   "docker.mirrors.ustc.edu.cn"
 ],
 "debug" : true,
 "experimental" : true
}
```

```
systemctl daemon-reload
service docker restart
```

```bash
# docker pull nginx:latest
docker pull docker.lixd.xyz/library/nginx:latest  # 拉取 Docker 官方镜像

# docker pull quay.io/coreos/etcd:latest
docker pull quay.lixd.xyz/coreos/etcd:latest  # 拉取 Quay 镜像

# docker pull gcr.io/google-containers/busybox:latest
docker pull gcr.lixd.xyz/google-containers/busybox:latest  # 拉取 GCR 镜像

# docker pull k8s.gcr.io/pause:latest
docker pull k8s-gcr.lixd.xyz/pause:latest  # 拉取 k8s.gcr.io 镜像

# docker pull registry.k8s.io/pause:latest
docker pull k8s.lixd.xyz/pause:latest  # 拉取 registry.k8s.io 镜像

# docker pull ghcr.io/github/super-linter:latest
docker pull ghcr.lixd.xyz/github/super-linter:latest  # 拉取 GitHub 容器镜像

# docker pull docker.cloudsmith.io/public/repo/image:latest
docker pull cloudsmith.lixd.xyz/public/repo/image:latest  # 拉取 Cloudsmith 镜像
```

## 参考文章

1. [基于 Cloudflare Workers 和 cloudflare-docker-proxy 搭建镜像加速服务](https://www.cnblogs.com/KubeExplorer/p/18264358)