## 查看redis持久化策略

##### 查看redis.conf

```shell
# RDB持久化的规则
save 900 1
save 300 10
save 60 10000
# 是否启用AOF持久化 
# appendonly配置项定义了是否启用AOF持久化，appendfilename配置项定义了AOF文件的路径和文件名
appendonly no
appendfilename "appendonly.aof"
```

##### `INFO persistence`命令

```bash
127.0.0.1:6379> INFO persistence
# Persistence
loading:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0 # 上一次RDB持久化以来发生变化的键数量
rdb_bgsave_in_progress:0
rdb_last_save_time:1689902579 # Redis最后一次进行RDB持久化的时间
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:0
aof_enabled:0 # AOF持久化启用状态 0表示未启用；1表示启用
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1 # -1，表示没有AOF重写正在进行
aof_current_rewrite_time_sec:-1 # -1，表示没有AOF重写正在进行
aof_last_bgrewrite_status:ok # ok，表示上一次AOF重写和写入操作都成功。
aof_last_write_status:ok # ok，表示上一次AOF重写和写入操作都成功。
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0
```

## 备份

```shell
# 后台异步保存当前数据库的数据到磁盘中的RDB文件。
BGSAVE
# 在后台异步重写AOF文件，去掉AOF文件中的无用命令，减小AOF文件的大小。
BGREWRITEAOF
# 同步保存当前数据库的数据到磁盘中的RDB文件，并阻塞Redis服务器，直到保存完毕
SAVE
# 保存数据并关闭Redis服务器
SHUTDOWN
```

## 恢复

将dump.rdb和appendonly.aof放到安装目录下，启动redis

## 参考文章

1. [Redis RDB持久化详解（原理+配置策略）](http://c.biancheng.net/redis/rdb.html)
2. [如何查看redis是否持久化](https://blog.51cto.com/u_16175435/6729103)
3. [redis数据备份与恢复](https://blog.csdn.net/lonely_baby/article/details/129172469)