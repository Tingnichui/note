# docker镜像导出导入

https://blog.csdn.net/q_hsolucky/article/details/122717206

镜像打包

```
docker save -o mysql_5.7.42.tar mysql:5.7.42
```

载入镜像包

```
docker load -i mysql_5.7.42.tar
```