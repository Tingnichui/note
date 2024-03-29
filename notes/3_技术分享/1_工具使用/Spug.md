```bash
 
docker cp jdk-8u381-linux-x64.tar.gz spug:/
docker exec -it spug bash
tar xf jdk-8u381-linux-x64.tar.gz -C /opt
 
curl -o apache-maven-3.8.8-bin.tar.gz http://apache.mirrors.pair.com/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
tar xf apache-maven-3.8.8-bin.tar.gz -C /opt/
echo -e 'export JAVA_HOME=/opt/jdk1.8.0_381\nexport PATH=$PATH:$JAVA_HOME/bin:/opt/apache-maven-3.6.3/bin' > /etc/profile.d/java.sh


# [可选]配置阿里云镜像加速下载，在159-164行（<mirrors\>标签内）添加以下内容
vi /opt/apache-maven-3.8.8/conf/settings.xml

<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>

# 退出并重启容器
exit
docker restart spug
```

