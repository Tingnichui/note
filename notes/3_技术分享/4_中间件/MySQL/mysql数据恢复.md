https://www.cnblogs.com/gomysql/p/3582058.html

https://www.cnblogs.com/billyxp/p/3460682.html?spm=a2c6h.12873639.article-detail.7.26855d92PMdEdi



https://blog.csdn.net/ruanchengshen/article/details/127902441

https://www.cnblogs.com/michael9/p/11923483.html

https://www.cnblogs.com/faster/p/16274217.html



[Mysql 通过 binlog日志 恢复数据（数据搞丢看过来）](https://blog.csdn.net/Jokers_lin/article/details/126449539)

```
#锁表,防止数据被污染
lock tables 表名 read;

show binlog events in 'binlog.000067';


mysqlbinlog  --start-position='起始Pos' --stop-position='结束Pos' D:/Develop/Mysql/mysql-8.0.27-winx64/data/binlog.000067 | mysql -uroot -p

```

通过应用程序 mysqlbinlog.exe 可以从日志文件中读取指定时间段的数据库语句变更详细日志。

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

```
mysqlbinlog --no-defaults -v -v --base64-output=decode-rows binlog.000003 |grep -B 15 'INSERT INTO `chunhui`.`jljs_class_record`'
```

