## docker安装

### 5.7

```shell
docker run --name mysql \
    --restart=always \
    -p 3306:3306 \
    -v /home/application/mysql/log:/var/log/mysql  \
    -v /home/application/mysql/data:/var/lib/mysql  \
    -v /home/application/mysql/conf:/etc/mysql/conf.d \
    -e TZ=Asia/Shanghai  \
    -e MYSQL_ROOT_PASSWORD=password  \
    -d mysql:5.7.42
```

### 8.0

```shell
docker run --name mysql \
    --restart=always \
    -p 3306:3306 \
    -v /home/application/mysql/log:/var/log/mysql  \
    -v /home/application/mysql/data:/var/lib/mysql  \
    -v /home/application/mysql/conf:/etc/mysql/conf.d \
    -e TZ=Asia/Shanghai  \
    -e MYSQL_ROOT_PASSWORD=password  \
    -d mysql:8.2.0
```

## 二进制安装

### 5.7

> 此处版本为5.7.44

[MySQL基础知识（二）-超详细 Linux安装MySQL5.7完整版教程及遇到的坑](https://cloud.tencent.com/developer/article/2190175)

```bash
# 卸载残留
rpm -qa | grep mysql
rpm -qa | grep mariadb

rpm -e --nodeps `rpm -qa|grep mariadb`
rpm -e --nodeps `rpm -qa|grep mysql`

# 下载解压
cd /usr/local/
wget https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.44-linux-glibc2.12-x86_64.tar.gz
tar -zxvf mysql-5.7.44-linux-glibc2.12-x86_64.tar.gz -C /usr/local
mv mysql-5.7.44-linux-glibc2.12-x86_64 mysql

# 创建mysql用户组和用户
groupadd mysql
useradd -r -g mysql mysql

# 创建数据目录并赋予权限
mkdir -p /usr/local/mysql/data
chown mysql:mysql -R /usr/local/mysql/data

# 创建配置文件
vim /usr/local/mysql/my.cnf


[mysqld]
bind-address=0.0.0.0
port=3306
user=mysql
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
socket=/tmp/mysql.sock
log-error=/usr/local/mysql/data/mysql.err
pid-file=/usr/local/mysql/data/mysql.pid
#character config
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true

[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

# 初始化数据库 设置默认配置文件 等
/usr/local/mysql/bin/mysqld --defaults-file=/usr/local/mysql/my.cnf --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/ --user=mysql --initialize


# 查看root用户密码
cat /usr/local/mysql/data/mysql.err

# 启动mysql服务
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
service mysql start

# 配置环境变量
vim /etc/profile
# 写入配置 路径换成自己的
export PATH=$PATH:/usr/local/mysql/bin
# 生效配置
source /etc/profile
# 验证
mysql --version

# 修改密码
mysql -uroot -p

SET PASSWORD = PASSWORD('123456');
ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
FLUSH PRIVILEGES;
use mysql;
update user set host = '%' where user = 'root';
FLUSH PRIVILEGES;
```

卸载 https://blog.csdn.net/gdkyxy2013/article/details/105116602

```
# 该卸载方式只适用于本文章的安装方式，其他方式自行测试
rm /usr/local/mysql -rf
rm mysql-5.7.44-linux-glibc2.12-x86_64.tar.gz -rf
rm /etc/init.d/mysql -rf

whereis mysql
find / -name mysql
rm -rf /var/lib/selinux/targeted/active/modules/100/mysql
rm -rf /usr/share/selinux/targeted/default/active/modules/100/mysql /usr/share/bash-completion/completions/mysql
```

### 8.0

安装

查看 MariaDB

```bash
rpm -qa|grep mariadb
```

卸载 相关安装

```shell
rpm -e --nodeps 文件名
rpm -e --nodeps `rpm -qa|grep mariadb`
```

![image-20211124173745968](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/r3L86a5PeO4pmVY.png)

下载资源包 https://downloads.mysql.com/archives/community/

```shell
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