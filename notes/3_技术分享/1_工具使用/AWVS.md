https://hub.docker.com/r/secfa/docker-awvs

```shell
# 创建最新的容器 221109177 之后的版本必须加上 --cap-add LINUX_IMMUTABLE  但是我启动不起来
docker pull secfa/docker-awvs
docker run -it --name awvs -d -p 13443:3443 --cap-add LINUX_IMMUTABLE --privileged secfa/docker-awvs | xargs docker logs -f
 
#创建 221109177 版本的容器 一定要有--privileged 不然启动不了
docker pull secfa/docker-awvs:221109177
docker run -it --name awvs -d --privileged -p 13443:3443 secfa/docker-awvs:221109177 | xargs docker logs -f

# 登陆地址
https://YOUR_IP:13443/

# 默认账号密码
Username:admin@admin.com
password:Admin123
AWVS Version:230628115
```



![image-20230812020607639](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230812020607639.png)

设置登录

![image-20230812020947486](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230812020947486.png)

![image-20230812021114832](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230812021114832.png)

## 参考文章

1. 