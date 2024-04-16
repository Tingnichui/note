## 设置主节点

修改配置

```bash
vi /usr/local/mysql/my.cnf
```

```
# 设置主库集群唯一标识
server-id=1
# 主库开启二进制文件功能，（名称可自定义）
log-bin=mysql-bin
```

重启mysql

```
service mysql restart 
```

登录mysql

```
/usr/local/mysql/bin/mysql -uroot -p123456
```

查看二进制文件配置是否生效

```sql
show master status;
show master logs;
```

查看log_bin是否开起

```sql
show variables like "%log_bin";
```

创建复制用户

```sql
grant replication slave on *.* to "repl"@"%" identified by "123456";
flush privileges;
```

刷新所有表并阻止写入语句

```sql
FLUSH TABLES WITH READ LOCK;
```

获取复制源的二进制日志坐标

> 查看当前二进制日志文件名和位置 在设置副本时需要File Position
>
> 如果源之前在未启用二进制日志记录的情况下运行，SHOW MASTER STATUS则mysqldump --master-data显示的日志文件名和位置值将为空。在这种情况下，稍后在指定源日志文件和位置时需要使用的值是空字符串 ('') 和4。

```sql
SHOW MASTER STATUS\G
```

在从库设置好之后释放锁

```sql
# UNLOCK TABLES;
```

## 设置从节点

> 如果源上的数据库包含现有数据，则需要将此数据复制到每个副本。此处不做操作，详细看[文档](https://dev.mysql.com/doc/refman/5.7/en/replication-snapshot-method.html)

修改配置

```bash
vi /usr/local/mysql/my.cnf
```

```sql
#设置从库集群唯一标识 不能与主数据库重复
server-id=2
```

重启服务

```
service mysql restart
```

登录mysql

```
/usr/local/mysql/bin/mysql -uroot -p123456
```

设置源配置

> 从主节点查询二进制坐标，master_log_file 和 master_log_pos 一定要一致，要不然Slave_SQL_Running=NO

```sql
change master to master_host="192.168.0.1", master_user="repl", master_password="123456", master_log_file="mysql-bin.000002", master_log_pos=2865;
```

启动复制线程

```sql
START SLAVE;
```

查看复制状态

> 启动之后如果不报错即可执行如下命令查看复制的状态：

```sql
show slave status \G;
```

主要查看下面两个参数状态，只要都是yes，表示主从通信正常。
Slave_IO_Running=Yes
Slave_SQL_Running=Yes
如果均为yes则正常，否则需根据last_error信息进行调试

**<u>成功之后将主节点的锁释放掉</u>**

## 参考文章

1. 官方文档：https://dev.mysql.com/doc/refman/5.7/en/replication.html
2. [mysql 5.7主从配置](https://www.cnblogs.com/miaocbin/p/13889783.html)
3. [MySQL 5.7主从架构部署](https://www.cnblogs.com/panw/p/16300768.html)
4. [MySQL-----主从复制 Slave_SQL_Running:no](https://blog.csdn.net/jmwn99/article/details/122800962)