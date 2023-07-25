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