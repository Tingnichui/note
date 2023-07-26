> -  仅支持GA版本之间升级。
> -  5.6 → 5.7 ，建议先将5.6升级至最新版，再升级到5.7。
> -  不支持跳版本升级。例如，不支持5.5直接升级到5.7。
> -  5.5 → 5.7 ，建议先将5.5 升级至最新，再从5.5 → 5.6最新，再5.6 → 5.7 最新。
> -  在同一个发行版系列中，例如支持5.7.x → 5.7.y，也支持跳发行版本，如从5.7.x → 5.7.z。
> -  回退方案要提前考虑好，最好升级前要备份(特别是往8.0版本升级)。
> -  降低停机时间（停业务的时间），在业务不繁忙期间升级，做好足够的预演。
> -  
> -  同一个大版本中的小版本升级，比如5.7.19到5.7.28。
> -  跨版本升级，但只支持跨一个版本升级，比如5.5到5.6，5.6到5.7。
> -  不支持跨版本的直接升级，比如直接从5.5到5.7，可以先从5.5升级到5.6，再从5.6升级到5.7。

# Logical Upgrade

## 5.7小版本升级

#### 全量备份

```mysql
mysqldump -uroot -p --quick --add-drop-table --routines --events --all-databases --flush-logs --single-transaction --force > /home/backup/mysql/alldata.sql
```

#### 关闭mysql

```mysql
show variables like 'innodb_fast_shutdown';
# 确保数据都刷到硬盘上，更改成0
set global innodb_fast_shutdown=0;
# 关闭数据库
shutdown;
exit
```

#### 备份旧数据

备份旧msyql配置文件/etc/my.cnf和 数据库目录：/data/mysql/data

```shell
# 查看数据库目录
cat my.cnf | grep datadir
# 打包压缩数据库文件
tar -zcvf mysql_data.tar.gz /var/lib/mysql
```

#### 升级

##### 1.docker 部署新的 mysql

```shell
docker pull mysql:5.7.42
```

配置文件 和 数据库目录挂载 旧mysql的

```shell
docker run --name=mysql-5.7.42 \
   -p 3307:3306 \
   -v /home/mysql-5.7.42/my.cnf:/etc/my.cnf \
   -v /home/mysql-5.7.42/data:/var/lib/mysql \
   --privileged=true \
   -d mysql:5.7.42
```

进入容器中运行mysql_upgrade 检查并升级 MySQL 表

错误[The mysql.session exists but is not correctly configured](https://blog.csdn.net/lwei_998/article/details/80119023)

```shell
# 出现提示时，输入旧 MySQL 5.6 服务器的 root 密码。
docker exec -it mysql-5.7.42 mysql_upgrade -uroot -p
```

重新启动容器来完成升级

```
docker restart mysql-5.7.42
```

##### 2.二进制安装新的mysql

二进制下载地址 https://downloads.mysql.com/archives/community/

```
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /usr/local
tar zxvf /path/to/mysql-VERSION-OS.tar.gz
ln -s full-path-to-mysql-VERSION-OS mysql
cd mysql
mkdir mysql-files
chown mysql:mysql mysql-files
chmod 750 mysql-files
bin/mysqld --initialize --user=mysql
bin/mysql_ssl_rsa_setup
bin/mysqld_safe --user=mysql &
# Next command is optional
$> cp support-files/mysql.server /etc/init.d/mysql.server
```



#### 参考文章

1. mysql官方文档 https://dev.mysql.com/doc/refman/5.7/en/upgrade-binary-package.html
2. https://dev.mysql.com/doc/refman/5.7/en/docker-mysql-getting-started.html#docker-upgrading





## TODO

确认mysql版本

```shell
mysql --version
```

### 备份

> 数据 + 用户

##### 全量备份

```
mkdir -p /home/backup/mysql/ && mysqldump -uroot -p --quick --events --all-databases --flush-logs --delete-master-logs --single-transaction > /home/backup/mysql/alldata.sql
```

- --quick : 该选项在导出大表时很有用，它强制 mysqldump 从服务器查询取得记录直接输出而不是取得所有记录后将它们缓存到内存中。
- --all-databases : 导出所有数据库
- --flush-logs : 生成新的二进制日志文件
- --single-transaction : 此选项会将隔离级别设置为：REPEATABLE READ。并且随后再执行一条START TRANSACTION语句，让整个数据在dump过程中保证数据的一致性，这个选项对InnoDB的数据表很有用，且不会锁表。但是这个不能保证MyISAM表和MEMORY表的数据一致性。 为了确保使用`--single-transaction`命令时，保证dump文件的有效性。需没有下列语句`ALTER TABLE, CREATE TABLE, DROP TABLE, RENAME TABLE, TRUNCATE TABLE`，因为一致性读不能隔离上述语句。所以如果在dump过程中，使用上述语句，可能会导致dump出来的文件数据不一致或者不可用。

##### 增量备份

需要开启`log_bin`



### 参考文章

1. [mysql全量备份和增量备份](https://www.jianshu.com/p/d3f77f7da512)
2. [如何将源数据库的用户与权限导出，再导入到目标数据库](https://support.huaweicloud.com/drs_faq/drs_12_0001.html)