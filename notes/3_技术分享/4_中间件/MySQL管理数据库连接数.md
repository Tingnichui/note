## 查看数据库连接数

```mysql
show full processlist;
```

```mysql
select * from information_schema.processlist order by id;
```

information_schema.processlist 表中的数据与`SHOW FULL PROCESSLIST`命令的输出结果相同。

![image-20230716143406109](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230716143406109.png)

  Id - 连接的唯一标识；
  User - 客户端的用户名，event_scheduler 是监控计划事件的线程；
  Host - 客户端的主机名和端口号；
  db - 默认的数据库，如果没有设置显示为 NULL；
  Command - 该线程正在执行的命令类型；
  Time - 该线程处于当前状态的秒数；
  State - 该线程正在执行的操作、事件或者状态；
  Info - 该线程正在执行的语句，NULL 表示没有执行任何语句。

1. 若不加上full选项，则最多显示100条记录
2. 若以root帐号登录，你能看到所有用户的当前连接。如果是其它普通帐号，只能看到自己占用的连接

## KILL 命令终止线程

```mysql
KILL [CONNECTION | QUERY] pid;
```

  KILL CONNECTION终止该连接正在执行的语句之后终止连接线程，这是默认值；`kill 33;`终止33线程连接
  KILL QUERY终止该连接正在执行的语句，但不会终止连接线程。

## 查看MySQL数据库状态

```mysql
show status;
```

```mysql
show status like '%变量名称%';
show status where variable_name = '变量名称';
```

```
Aborted_clients 由于客户没有正确关闭连接已经死掉，已经放弃的连接数量
Aborted_connects 尝试已经失败的MySQL服务器的连接的次数
Connections 试图连接MySQL服务器的次数
Created_tmp_tables 当执行语句时，已经被创造了的隐含临时表的数量
Delayed_insert_threads 正在使用的延迟插入处理器线程的数量
Delayed_writes 用INSERT DELAYED写入的行数
Delayed_errors 用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数
Flush_commands 执行FLUSH命令的次数
Handler_delete 请求从一张表中删除行的次数
Handler_read_first 请求读入表中第一行的次数
Handler_read_key 请求数字基于键读行
Handler_read_next 请求读入基于一个键的一行的次数
Handler_read_rnd 请求读入基于一个固定位置的一行的次数
Handler_update 请求更新表中一行的次数
Handler_write 请求向表中插入一行的次数
Key_blocks_used 用于关键字缓存的块的数量
Key_read_requests 请求从缓存读入一个键值的次数
Key_reads 从磁盘物理读入一个键值的次数
Key_write_requests 请求将一个关键字块写入缓存次数
Key_writes 将一个键值块物理写入磁盘的次数
Max_used_connections 同时使用的连接的最大数目
Not_flushed_key_blocks 在键缓存中已经改变但是还没被清空到磁盘上的键块
Not_flushed_delayed_rows 在INSERT DELAY队列中等待写入的行的数量
Open_tables 打开表的数量
Open_files 打开文件的数量
Open_streams 打开流的数量(主要用于日志记载）
Opened_tables 已经打开的表的数量
Questions 发往服务器的查询的数量
Slow_queries 要花超过long_query_time时间的查询数量
Threads_connected 当前打开的连接的数量
Threads_running 不在睡眠的线程数量
Uptime 服务器工作了多少秒
```

## 其他

```mysql
SELECT * FROM performance_schema.threads;
```

performance_schema.threads 表中存储了所有线程的详细信息，包括各种 MySQL 后台服务器线程。这种方式对服务器的性能影响更小，因为访问该表不需要 mutex 互斥锁；提供了更多的信息，例如线程属于前台还是后台线程，线程在服务器中的位置等；提供了后台线程的信息，可以用于 DBA 执行监控；可以启用或者禁用线程监控和历史事件记录。

## 参考文章

1. [MySQL查看数据库连接数](https://blog.csdn.net/wujizhishui/article/details/119995800)
2. [MySQL 查看和终止正在运行的连接线程](http://www.mark-to-win.com/tutorial/51590.html)