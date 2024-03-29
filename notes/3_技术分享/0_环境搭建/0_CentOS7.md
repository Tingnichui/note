## 防火墙

```bash
systemctl status firewalld.service
```

```bash
systemctl stop firewalld.service
```

```bash
systemctl disable firewalld.service
```

---

## Java

0.下载

https://www.oracle.com/java/technologies/downloads/#java8

![image-20230405154627233](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230405154627233.png)

1.上传服务器并解压

用xftp，或者直接用xshell切换到解压目录，将文件拖动进去就行，我这里下载到/usr/local这个目录

```bash
cd /usr/local
tar -zxvf jdk-8u381-linux-x64.tar.gz
```

2.配置环境

编辑配置

```bash
vim /etc/profile
```

写入配置 路径换成自己的

```
export JAVA_HOME=/usr/local/jdk1.8.0_381
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JRE_HOME=$JAVA_HOME/jre 
```

生效配置

```bash
source /etc/profile
```

验证

```bash
java -version
```

参考文章

1. [centos7安装java(多种方式)](https://blog.csdn.net/m0_61035257/article/details/125705400) 

---

## Maven

下载地址：https://archive.apache.org/dist/maven/maven-3/

```
cd /usr/local/
wget https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -zxvf apache-maven-3.5.4-bin.tar.gz -C /usr/local
```

2.配置环境

编辑配置

```bash
vim /etc/profile
```

写入配置 路径换成自己的

```
export MAVEN_HOME=/usr/local/apache-maven-3.5.4
export PATH=$MAVEN_HOME/bin:$PATH
```

生效配置

```bash
source /etc/profile
```

验证

```bash
mvn -v
```

修改配置文件

```bash
# 新建仓库存在目录
mkdir -p /usr/local/apache-maven-3.5.4/repository

# 编辑配置文件
vim /usr/local/apache-maven-3.5.4/conf/settings.xml

# 指定本地仓库路径
<localRepository>/usr/local/apache-maven-3.5.4/repository</localRepository>

# 配置阿里云镜像仓库
<mirror>
  <id>alimaven</id>
  <name>aliyun maven</name>
  <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
  <mirrorOf>central</mirrorOf>
</mirror>
```



## MySQL

安装

查看 MariaDB

```bash
rpm -qa|grep mariadb
```

卸载 相关安装

```
rpm -e --nodeps 文件名
```

![image-20211124173745968](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/r3L86a5PeO4pmVY.png)

下载资源包 https://downloads.mysql.com/archives/community/

```bash
cd /usr/local/
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz
```

检查是否已安装mysql，有的话需要卸载

```bash
rpm -qa|grep mysql
# 停止服务
systemctl stop mysqld
# 卸载
rpm -e --nodeps mysql文件名
```

解压包

```bash
tar -Jxvf mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz 
# 重命名文件名称
mv mysql-8.0.20-linux-glibc2.12-x86_64/ mysql
# 删除安装包
rm -rf mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz 
```

配置环境变量

```bash
# 编辑配置
vim /etc/profile
# 写入配置 路径换成自己的
export PATH=$PATH:/usr/local/mysql/bin
# 生效配置
source /etc/profile
# 验证
mysql --version
```

创建用户组

```bash
cd /usr/local
groupadd mysql
useradd -r -g mysql mysql
```

创建数据目录

```bash
mkdir /usr/local/mysql/data
cd /usr/local/mysql
chown -R mysql .
chgrp -R mysql .
```

初始化musql

```bash
cd /usr/local/mysql
touch my.cnf
vim /usr/local/mysql/my.cnf
```

```
[mysql]
# 默认字符集
default-character-set=utf8mb4
[client]
port       = 3306
socket     = /tmp/mysql.sock
[mysqld]
port       = 3306
server-id  = 3306
user       = mysql
socket     = /tmp/mysql.sock
# 安装目录
basedir    = /usr/local/mysql
# 数据存放目录
datadir    = /usr/local/mysql/data
log-bin    = /usr/local/mysql/data/mysql-bin
innodb_data_home_dir      =/usr/local/mysql/data
innodb_log_group_home_dir =/usr/local/mysql/data
# 日志及进程数据的存放目录
log-error =/usr/local/mysql/data/mysql.log
pid-file  =/usr/local/mysql/data/mysql.pid
# 服务端字符集
character-set-server=utf8mb4
lower_case_table_names=1
autocommit =1
##### 以上涉及文件夹明，注意修改
skip-external-locking
key_buffer_size = 256M
max_allowed_packet = 1M
table_open_cache = 1024
sort_buffer_size = 4M
net_buffer_length = 8K
read_buffer_size = 4M
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 64M
thread_cache_size = 128
#query_cache_size = 128M
tmp_table_size = 128M
explicit_defaults_for_timestamp = true
max_connections = 500
max_connect_errors = 100
open_files_limit = 65535
binlog_format=mixed
binlog_expire_logs_seconds =864000
# 创建表时使用的默认存储引擎
default_storage_engine = InnoDB
innodb_data_file_path = ibdata1:10M:autoextend
innodb_buffer_pool_size = 1024M
innodb_log_file_size = 256M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
transaction-isolation=READ-COMMITTED
[mysqldump]
quick
max_allowed_packet = 16M
[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 4M
read_buffer = 2M
write_buffer = 2M
[mysqlhotcopy]
interactive-timeout
```

初始化mysql

```bash
mysqld --defaults-file=/usr/local/mysql/my.cnf --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql --initialize-insecure
```

启动mysql

```bash
mysqld_safe --defaults-file=/usr/local/mysql/my.cnf &
```

确认启动

```bash
ps -ef|grep mysql
```

首次修改密码

```sql
# 登录mysql
mysql -u root --skip-password
# 修改密码
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';
# 刷新权限
FLUSH PRIVILEGES;
```

平时修改密码

```bash
# linux
mysqladmin -u用户名 -p旧密码 password 新密码
# mysql命令行
# 设置密码
SET PASSWORD FOR '用户名'@'主机' = PASSWORD(‘密码');
# 刷新权限
FLUSH PRIVILEGES;
```

创建远程用户

```sql
USE mysql;
SELECT user,host,plugin,authentication_string FROM user;
# 创建用户
CREATE user 'root'@'%';
# 设置首次密码
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '密码';
# 授权用户所有权限，刷新权限
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
```

开放端口

```bash
# 查看端口状态：no 表示未开启
firewall-cmd --query-port=3306/tcp
# 永久开放端口
firewall-cmd --add-port=3306/tcp --permanent
# 重启防火墙
systemctl restart firewalld
```

设置开机自启---未设置成功

```bash
# 把 /usr/local/mysql/support-files/mysql.server 复制到 /etc/rc.d/init.d/mysqld并且改名叫MySQLD
cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld
# 授予执行的权限
chmod +x /etc/init.d/mysqld
# 添加为服务
chkconfig --add mysqld
# 查看服务表
chkconfig --list
# 设置开机自启 enable不生效，执行下面这个命令主要是看添加的服务是不是成功启用
systemctl start mysqld
```

参考文章

1. [Linux：CentOS7安装MySQL8（详）](https://www.cnblogs.com/secretmrj/p/15600144.html)
2. [centos7安装MySQL8并设置开机自启](https://blog.csdn.net/zzc12121/article/details/128328900) 
3. [二进制安装MySQL和设置开机自启](https://blog.csdn.net/2303_76463788/article/details/129891916)
4. [Centos7设置mysql开机自启](https://blog.csdn.net/weixin_43841151/article/details/127078463) 

---

## Redis

官网地址：https://redis.io/

下载并解压安装包

```bash
cd /usr/local
wget https://download.redis.io/releases/redis-6.2.12.tar.gz
tar -zxvf redis-6.2.12.tar.gz && mv redis-6.2.12/ redis && rm -rf redis-6.2.12.tar.gz
```

编译

```bash
cd /usr/local/redis
make && cd src/ && make install
```

设置环境变量

```bash
# 编辑配置
vim /etc/profile
# 写入配置 路径换成自己的
export PATH=$PATH:/usr/local/redis/src
# 生效配置
source /etc/profile
# 验证
redis-server --version
```

修改配置文件

```bash
vim /usr/local/redis/redis.conf
# 使用"/ 要搜索的内容"，回车，直接快速定位文档中的位置
# 注释下面 打开远程链接
bind 127.0.0.1 -::1
# 修改保护模式，不修改保护模式也是只能内网访问的 protected-mode yes 改成 protected-mode no
protected-mode no
# daemonize no 改为yes 后台一直运行
daemonize yes
# 设置密码，这里建议设置密码，否则可能会发生一些预料不到的事情，因为6379端口有漏洞
requirepass password
```

开放端口

```bash
# 查看端口状态：no 表示未开启
firewall-cmd --query-port=6379/tcp
# 永久开放端口
firewall-cmd --add-port=6379/tcp --permanent
# 重启防火墙
systemctl restart firewalld
```

启动

```bash
# 一次性启动
redis-server /usr/local/redis/redis.conf
```

开机自启

```bash
# 创建文件
vim /lib/systemd/system/redis.service
# 写入以下配置
[Unit]
Description=redis-server
After=network.target

[Service]
Type=forking
# ExecStart需要按照实际情况修改成自己的地址
ExecStart=/usr/local/redis/src/redis-server /usr/local/redis/redis.conf
PrivateTmp=true

[Install]
WantedBy=multi-user.target

# 设置开机自启
systemctl start redis.service
systemctl enable redis.service
# 重启redis
systemctl start redis.service
```

参考文章

1. [Centos安装Redis](https://blog.csdn.net/qq_38584262/article/details/125773286)
2. [Redis6设置自启动CentOS](https://blog.csdn.net/zwrlj527/article/details/113374863) 

---

## Nginx

```bash
# 环境配置
yum -y install gcc gcc-c++ make libtool zlib zlib-devel openssl openssl-devel pcre pcre-devel
# 下载安装包
cd /usr/local
wget http://nginx.org/download/nginx-1.18.0.tar.gz
# 解压安装包
tar -zxvf nginx-1.18.0.tar.gz
# 配置并编译
cd /usr/local/nginx-1.18.0
# 设置安装目录为 /usr/local/nginx 
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
# 编译安装
make && make install
```

配置环境

```bash
# 编辑配置
vim /etc/profile
# 写入配置 路径换成自己的
export PATH=$PATH:/usr/local/nginx/sbin
# 生效配置
source /etc/profile
# 验证
nginx -v
```

开放端口

```bash
# 查看端口状态：no 表示未开启
firewall-cmd --query-port=80/tcp
# 永久开放端口
firewall-cmd --add-port=80/tcp --permanent
# 重启防火墙
systemctl restart firewalld
```

启动命令

```bash
# 启动
nginx -c /usr/local/nginx/conf/nginx.conf
# 重启
nginx -s reload
```

设置开机自启

```bash
vim /etc/rc.local
# 写入编写配置
/usr/local/nginx/sbin/nginx
# 设置执行权限
chmod 755 /etc/rc.local
```

参考文章

1. [CentOS安装Nginx](https://blog.csdn.net/qq_33381971/article/details/123328191)

---

## Elasticsearch

下载并解压

```shell
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.0-linux-x86_64.tar.gz
```

```shell
tar -zxvf elasticsearch-7.12.0-linux-x86_64.tar.gz
```

修改elasticsearch.yml  中 data 和 logs 存储位置

![image-20230907230927707](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230907230927707.png)

修改后记得创建对应的文件夹

```shell
mkdir -p /home/tools/elasticsearch-7.12.0/data /home/tools/elasticsearch-7.12.0/logs
```

增加elastic用户

```shell
useradd elastic
```

```shell
passwd elastic
```

修改es和data logs属主，因为我这里data和logs在es中所有我就一条命令就行

```shell
chown -R elastic:elastic elasticsearch-7.12.0
```

切换用户

```shell
su elastic
```

启动一下看看

```shell
./bin/elasticsearch
```

出现以下错误

![image-20230912112402739](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230912112402739.png)

```
vi /etc/security/limits.conf

elastic soft nofile 65536
elastic hard nofile 65536
elastic soft nproc 4096
elastic hard nproc 4096
```

访问一下看看是否正常启动

```shell
curl 127.0.0.1:9200
```

后台启动

```shell
./bin/elasticsearch -d
```

设置密码

https://www.elastic.co/guide/en/elasticsearch/reference/7.12/security-minimal-setup.html

elasticsearch.yml添加如下内容,并重启

```yaml
xpack.security.enabled: true
xpack.license.self_generated.type: basic
xpack.security.transport.ssl.enabled: true
```

执行设置用户名和密码的命令,这里需要为4个用户分别设置密码，elastic, kibana,logstash_system,beats_system

```shell
bin/elasticsearch-setup-passwords interactive
```

参考文章

1. [ES详解 - 安装：ElasticSearch和Kibana安装](https://pdai.tech/md/db/nosql-es/elasticsearch-x-install.html)

## Kibana

下载与ElasicSearch一致的版本。

https://www.elastic.co/cn/downloads/kibana

https://www.elastic.co/downloads/past-releases#kibana

上传服务器后解压

```shell
tar -zxvf kibana-7.12.0-linux-x86_64.tar.gz
```

修改属主

```shell
chown -R elastic:elastic kibana-7.12.0-linux-x86_64
```

配置Kibana的远程访问

```shell
vi kibana-7.12.0-linux-x86_64/config/kibana.yml
```

![image-20230907234008922](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230907234008922.png)

设置中文

![image-20230909145918502](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230909145918502.png)

切换用户

```shell
su elastic
```

启动

```shell
./bin/kibana
```

后台启动

```shell
nohup ./bin/kibana &
```

配置 Kibana 使用密碼連接到 Elasticsearch

https://www.elastic.co/guide/en/elasticsearch/reference/7.12/security-minimal-setup.html

kibana.yml追加登录账户名

```yaml
elasticsearch.username: "kibana_system"
```

```shell
./bin/kibana-keystore create
```

```
./bin/kibana-keystore add elasticsearch.password
```

参考文章

1. [ES详解 - 安装：ElasticSearch和Kibana安装](https://pdai.tech/md/db/nosql-es/elasticsearch-x-install.html)