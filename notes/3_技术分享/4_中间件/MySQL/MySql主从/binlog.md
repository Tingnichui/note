> 我这边都是通过命令动态修改，一旦mysql重启则会失效。永久生效需要将相关配置写入配置文件

```mysql
# 查看已有binlog文件
SHOW BINARY LOGS;
# 查看binlog过去时间设置
show variables like 'expire_logs_days';
# 查看binlog文件大小设置
show variables like 'max_binlog_size';


# 设置binlog过去时间为7天
set global expire_logs_days = 7;
# 设置binlog文件大小为1M 1*1024*1024=52428800，此处我用来测试用的，具体binlog大小根据实际情况设置 
set global max_binlog_size = 1048576;



```

官方文档：https://dev.mysql.com/doc/refman/5.7/en/binary-log.html

## 手动删除日志文件

官方文档：https://dev.mysql.com/doc/refman/5.7/en/purge-binary-logs.html

要安全清除二进制日志文件，请按照以下步骤操作：

1. 在每个副本上，用来[`SHOW SLAVE STATUS`](https://dev.mysql.com/doc/refman/5.7/en/show-slave-status.html)检查它正在读取哪个日志文件。
2. 使用 获取复制源服务器上的二进制日志文件列表[`SHOW BINARY LOGS`](https://dev.mysql.com/doc/refman/5.7/en/show-binary-logs.html)。
3. 确定所有副本中最早的日志文件。这是目标文件。如果所有副本都是最新的，则这是列表中的最后一个日志文件。
4. 备份您要删除的所有日志文件。（此步骤是可选的，但始终建议这样做。）
5. 清除所有日志文件，但不包括目标文件。



```mysql
SHOW BINARY LOGS;

# 删除某日志文件之前的
PURGE BINARY LOGS TO 'mysql-bin.010';
# 删除某日期之前的
PURGE BINARY LOGS BEFORE '2019-04-02 22:46:26';
```

参考文章

1. [mysql修改binlog保存的天数](https://blog.csdn.net/Hu_wen/article/details/80582013)
2. [MySQL修改 mysql-bin 日志保存天数以及文件大小限制](https://www.cnblogs.com/miracle-luna/p/13575058.html)
3. [MySQL Binlog 深度解析](https://juejin.cn/post/7105727720549515300)
4. [MySQL Binlog日志保留时长配置 & 删除方法](https://blog.csdn.net/liuwei0376/article/details/120435808)

