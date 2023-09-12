> 默认不带参数的导出，导出文本内容大概如下：创建数据库判断语句-删除表-创建表-锁表-禁用索引-插入数据-启用索引-解锁表。
>
> ```
> Usage: mysqldump [OPTIONS] database [tables]
> OR     mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
> OR     mysqldump [OPTIONS] --all-databases [OPTIONS]
> ```

#### 导出所有数据库

```
mysqldump -uroot -p --all-databases >/tmp/all.sql
```

#### 导出db1、db2两个数据库的所有数据

```
mysqldump -uroot -p --databases db1 db2 >/tmp/user.sql
```

#### 忽略某些库

```
mysql -e "show databases;" -uroot -p| grep -Ev "Database|information_schema|mysql|test" | xargs mysqldump -uroot -p --databases > mysql_dump.sql
```

#### 导出db1中的a1、a2表

注意导出指定表只能针对一个数据库进行导出，且导出的内容中和导出数据库也不一样，导出指定表的导出文本中没有创建数据库的判断语句，只有删除表-创建表-导入数据

```
mysqldump -uroot -p --databases db1 --tables a1 a2  >/tmp/db1.sql
```

#### 条件导出，导出db1表a1中id=1的数据

如果多个表的条件相同可以一次性导出多个表

字段是整形

```
mysqldump -uroot -proot --databases db1 --tables a1 --where='id=1'  >/tmp/a1.sql
```

字段是字符串,并且导出的sql中不包含drop table,create table

```
mysqldump -uroot -proot --no-create-info --databases db1 --tables a1 --where="id='a'"  >/tmp/a1.sql
```

#### 生成新的binlog文件,-F

有时候会希望导出数据之后生成一个新的binlog文件,只需要加上-F参数即可

```
mysqldump -uroot -proot --databases db1 -F >/tmp/db1.sql
```

#### 只导出表结构不导出数据，--no-data

```
mysqldump -uroot -proot --no-data --databases db1 >/tmp/db1.sql
```

跨服务器导出导入数据

```
mysqldump --host=h1 -uroot -proot --databases db1 |mysql --host=h2 -uroot -proot db2
```

将h1服务器中的db1数据库的所有数据导入到h2中的db2数据库中，db2的数据库必须存在否则会报错

```
mysqldump --host=192.168.80.137 -uroot -proot -C --databases test |mysql --host=192.168.80.133 -uroot -proot test 
```

 加上-C参数可以启用压缩传递。

#### 将主库的binlog位置和文件名追加到导出数据的文件中，--dump-slave

注意：--dump-slave命令如果当前服务器是从服务器那么使用该命令会执行stop slave来获取master binlog的文件和位置，等备份完后会自动执行start slave启动从服务器。但是如果是大的数据量备份会给从和主的延时变的更大，使用--dump-slave获取到的只是当前的从服务器的数据执行到的主的binglog的位置是（relay_mater_log_file,exec_master_log_pos),而不是主服务器当前的binlog执行的位置，主要是取决于主从的数据延时。

该参数在在从服务器上执行，相当于执行show slave status。当设置为1时，将会以CHANGE MASTER命令输出到数据文件；设置为2时，会在change前加上注释。

该选项将会打开--lock-all-tables，除非--single-transaction被指定。

在执行完后会自动关闭--lock-tables选项。--dump-slave默认是1。

```
mysqldump -uroot -proot --dump-slave=1 --databases db1 >/tmp/db1.sql
```

#### 将当前服务器的binlog的位置和文件名追加到输出文件，--master-data

该参数和--dump-slave方法一样，只是它是记录的是当前服务器的binlog，相当于执行show master status，状态（file,position)的值。

注意：--master-data不会停止当前服务器的主从服务

#### -opt

等同于--add-drop-table, --add-locks, --create-options, --quick, --extended-insert, --lock-tables, --set-charset, --disable-keys 该选项默认开启, 可以用--skip-opt禁用.

```
mysqldump -uroot -p --host=localhost --all-databases --opt
```

#### 保证导出的一致性状态--single-transaction

该选项在导出数据之前提交一个BEGIN SQL语句，BEGIN 不会阻塞任何应用程序且能保证导出时数据库的一致性状态。它只适用于多版本存储引擎（它不显示加锁通过判断版本来对比数据），仅InnoDB。本选项和--lock-tables 选项是互斥的，因为LOCK TABLES 会使任何挂起的事务隐含提交。要想导出大表的话，应结合使用--quick 选项。

```
--quick, -q
不缓冲查询，直接导出到标准输出。默认为打开状态，使用--skip-quick取消该选项。
```

#### --lock-tables, -l

开始导出前，锁定所有表。用READ LOCAL锁定表以允许MyISAM表并行插入。对于支持事务的表例如InnoDB和BDB，--single-transaction是一个更好的选择，因为它根本不需要锁定表。

请注意当导出多个数据库时，--lock-tables分别为每个数据库锁定表。因此，该选项不能保证导出文件中的表在数据库之间的逻辑一致性。不同数据库表的导出状态可以完全不同。

#### 导出存储过程和自定义函数--routines, -R

```
mysqldump  -uroot -p --host=localhost --all-databases --routines
```

#### 压缩备份 

```
压缩备份
mysqldump -uroot -p -P3306 -q -Q --set-gtid-purged=OFF --default-character-set=utf8 --hex-blob --skip-lock-tables --databases abc 2>/abc.err |gzip >/abc.sql.gz
还原
gunzip -c abc.sql.gz |mysql -uroot -p -vvv -P3306 --default-character-set=utf8 abc 1> abc.log 2>abc.err
```

### 参考文章

1. [MySQL mysqldump数据导出详解 ](https://www.cnblogs.com/chenmh/p/5300370.html)