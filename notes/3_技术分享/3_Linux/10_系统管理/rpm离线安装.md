```
yum -y install gcc pam-devel zlib-devel openssl-devel
```



```shell
yum deplist openssl-devel

yum install yum-utils -y
# 全量下载rpm 下载到当前目录
repotrack openssl-devel

# 离线安装
rpm -Uvh --force --nodeps *.rpm 
```



参考文章

1. https://www.cnblogs.com/whjblog/p/17061153.html
2. https://www.cnblogs.com/sunbines/p/16965202.html

