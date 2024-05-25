## 主从复制配置

### 设置主节点

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

```bash
service mysql restart
```

登录mysql

```bash
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

### 设置从节点

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

### 参考文章

1. 官方文档：https://dev.mysql.com/doc/refman/5.7/en/replication.html
2. [mysql 5.7主从配置](https://www.cnblogs.com/miaocbin/p/13889783.html)
3. [MySQL 5.7主从架构部署](https://www.cnblogs.com/panw/p/16300768.html)
4. [MySQL-----主从复制 Slave_SQL_Running:no](

## 新增从节点

> 新增从结点到复制拓扑

1、停止现有副本并记录副本状态信息，特别是源的二进制日志文件和中继日志文件位置。

```
STOP SLAVE;
SHOW SLAVE STATUS\G
```

```
mysql> STOP SLAVE;
Query OK, 0 rows affected (0.01 sec)

mysql> SHOW SLAVE STATUS\G
*************************** 1. row ***************************
               Slave_IO_State: 
                  Master_Host: xxx.xx.xxx.xxx
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000019
          Read_Master_Log_Pos: 720092675
               Relay_Log_File: VM-24-3-centos-relay-bin.000052
                Relay_Log_Pos: 720092888
        Relay_Master_Log_File: mysql-bin.000019
             Slave_IO_Running: No
            Slave_SQL_Running: No
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 720092675
              Relay_Log_Space: 720093151
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: 1d30f273-f8e6-11ee-95b6-00163e04f342
             Master_Info_File: /usr/local/mysql/data/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: 
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version:
```

Read_Master_Log_Pos: 720092675

Relay_Master_Log_File: mysql-bin.000019

2、关闭现有副本

```
shutdown;
exit
```

3、将数据目录从现有副本复制到新副本，包括日志文件和中继日志文件。

> 重要的
>
> - 在复制之前，请验证与现有副本相关的所有文件是否确实存储在数据目录中。例如，`InnoDB` 系统表空间、撤消表空间和重做日志可能存储在备用位置。 `InnoDB`表空间文件和每表文件表空间可能已在其他目录中创建。副本的二进制日志和中继日志可能位于数据目录之外的自己的目录中。检查为现有副本设置的系统变量，并查找已指定的任何替代路径。如果找到任何目录，也将这些目录复制过来。
> - 在复制过程中，如果文件已用于复制元数据存储库（请参阅 [第 16.2.4 节“中继日志和复制元数据存储库”）（](https://dev.mysql.com/doc/refman/5.7/en/replica-logs.html)这是 MySQL 5.7 中的默认设置），请确保还将这些文件从现有副本复制到新的复制品。如果表已用于存储库，则表位于数据目录中。
> - 复制后， `auto.cnf`从新副本上的数据目录副本中删除该文件，以便新副本以不同的生成的服务器 UUID 启动。服务器 UUID 必须是唯一的。

```bash
# 我这里将数据目录都放在 /usr/local/mysql/data 中
cd /usr/local/mysql/data
tar -zcvf mysql_20240503_bak.tar.gz my.cnf data/

# 新的从节点部署mysql 看我部署mysql的文章

# 删除新节点data文件
rm /usr/local/mysql/data /usr/local/mysql/my.cnf -rf

# 解压复制节点文件
cd /usr/local/mysql
tar -zxvf mysql_20240503_bak.tar.gz -C /usr/local

rm /usr/local/mysql/data/auto.cnf -rf
```

4、复制完成后，重新启动现有副本。

```
现有副本启动 不是这个新副本
```

5、在新副本上，编辑配置并为新副本提供一个唯一的服务器 ID（使用 [`server_id`](https://dev.mysql.com/doc/refman/5.7/en/replication-options.html#sysvar_server_id)系统变量），该 ID 不被源或任何现有副本使用。

```
vi my.cnf

# 设置主库集群唯一标识
server-id=3
```

6、启动新的副本服务器，指定该 [`--skip-slave-start`](https://dev.mysql.com/doc/refman/5.7/en/replication-options-replica.html#option_mysqld_skip-slave-start)选项以便复制尚未开始。使用性能架构复制表或问题[`SHOW SLAVE STATUS`](https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html)来确认新副本与现有副本相比具有正确的设置。还显示服务器 ID 和服务器 UUID，并验证这些对于新副本来说是否正确且唯一。

```
# 需要在[mysqld]中指定 skip-slave-start=1
vi my.cnf
skip-slave-start=1
```

```
service mysql start
```

```
# 出现提示时，输入旧 MySQL 服务器的 root 密码。
mysql_upgrade -uroot -p
```

```
mysql -uroot -p
```

```
RESET SLAVE;
change master to master_host="xxx.xxx.xxx.xxx", master_user="xxx", master_password="xxxxxx", master_log_file="mysql-bin.000019", master_log_pos=720092675;
```

7、通过发出以下语句启动复制线程 [`START SLAVE`](https://dev.mysql.com/doc/refman/5.7/en/start-slave.html)：

```
START SLAVE;
SHOW SLAVE STATUS\G;
```

### 参考文章

1. https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html

2. https://blog.csdn.net/jmwn99/article/details/122800962)

## 查看从库同步状态

### 参考文章

1. [细说show slave status参数详解（最全）【转】](https://www.cnblogs.com/paul8339/p/7615310.html)

