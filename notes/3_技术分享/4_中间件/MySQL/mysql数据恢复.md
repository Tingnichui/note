刷盘binlog

```sql
flush logs;
```

查看是否开启了binlog

```sql
show variables like '%log_bin%'; 
```

查看binlog是否是row格式

```sql
show variables like 'binlog_format';
```

查询 BINLOG 位置

```sql
show VARIABLES like 'datadir';
```

查询最新的binlog

```sql
show master status;
```

锁表

```sql
lock tables 表名 read;
```

查看binlog日志

```sql
show binlog events in 'binlog.000067';

# 通过 offset 查看 BINLOG 信息
show BINLOG events in 'mysql-bin.000034' limit 9000,  10;

# 通过 position 查看 binlog 信息
show BINLOG events in 'mysql-bin.000034' from 1742635 limit 10;
```

确定恢复范围进行恢复

```sql
mysqlbinlog  --start-position='起始Pos' --stop-position='结束Pos' D:/Develop/Mysql/mysql-8.0.27-winx64/data/binlog.000067 | mysql -uroot -p
```

## mysqlbinlog使用

mysqlbinlog.exe 可以从日志文件中读取指定时间段的数据库语句变更详细日志。

```
mysqlbinlog --base64-output=decode-rows -v --database=<数据库名称> --start-datetime="<起始时间>" --stop-datetime="<截至时间>" <日志文件> > <输出文件>
```

```
### 使用mysqlbinlog将二进制日志转化为明文SQL日志
mysqlbinlog mysql-bin.000123 > /data1/000123.sql
mysqlbinlog --set-charset=utf8 mysql-bin.000123 > /data1/000123.sql
```

```
mysqlbinlog --no-defaults --database=chunhui --base64-output=decode-rows -v binlog.000003 binlog1.sql
```

```shell
mysqlbinlog --no-defaults --database=chunhui --base64-output=decode-rows -v -v binlog.000003 | grep 'INSERT INTO `chunhui`.`jljs_class_record`' -A 10
```

## 参开文章

1. [Mysql 通过 binlog日志 恢复数据（数据搞丢看过来）](https://blog.csdn.net/Jokers_lin/article/details/126449539)
2. [MySQL 误操作后数据恢复（update,delete忘加where条件）](https://www.cnblogs.com/gomysql/p/3582058.html)
3. [MySQL 5.7 - 通过 BINLOG 恢复数据](https://www.cnblogs.com/michael9/p/11923483.html)
4. [mysqlbinlog 使用详解（附应用实例 恢复数据 日常维护）](https://www.cnblogs.com/faster/p/16274217.html)
