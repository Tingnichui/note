5.7.25mysql集群搭建



## 一.部署mysql

[本文部署过程在这里](./00_mysql安装)

## 二.MGR集群部署

### 1.核心配置讲解

> 每个节点都需要配置

修改my.cnf下的[mysqld]，每个服务配置保持一致，除了部分配置需要按照节点所在IP设置

```
For advice on how to change settings please see
http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]配置组为mysql服务运行参数配置，java、navicat等客户端连接使用该部分socket配置
[mysqld]

###集群中各服务器需要单独配置的项###
# 服务ID，官方建议server_id最好为1，2，3这样的自增量，且每台都不同
server_id = 1 
# 本节点的IP地址和端口，注意该端口是组内成员之间通信的端口，而不是MySQL对外提供服务的端口
# 如果服务器开启了防火墙，需要允许33071
loose-group_replication_local_address = '192.168.139.101:33071'
# 种子节点的IP和端口号，新成员加入到集群的时候需要联系种子节点获取复制数据，启动集群的节点不使用该选项
loose-group_replication_group_seeds = '192.168.139.101:33071,192.168.139.102:33071'
# mysql默认通过dns查找其他服务器，如果多台服务器hostname配置相同，将无法正确解析，此处配置使集群中以IP为服务器标识
report_host=192.168.139.101
#不再进行反解析（ip不反解成域名），加快数据库的反应时间
skip-name-resolve

###集群中各服务器需要单独配置的项###
# mysql mgr集群所有节点同时离线（如机房停电等）后，无法自动开启集群
# 此时各节点启动后，并没有组成集群，各自具有读写能力，如果客户端连接不同节点进行操作，就会造成数据不一致，此时再创建集群，就会遇到问题
# 将所有节点默认设置为只读状态，创建集群/加入集群后，由mgr自动修改其只读状态，避免客户端连接而数据不一致
# 普通用户只读
read_only=1
# 超级权限用户只读
super_read_only=1

# 跳过权限检查，用于mysql服务修复
# skip-grant-tables
# mysql日志时间默认为utc，改为与系统一致
log_timestamps=SYSTEM
#mysql数据文件目录
#datadir=/data/mysql/data
#mysql以socket方式运行的sock文件位置
#socket=/data/mysql/mysql.sock
#错误日志位置
#log-error=/data/mysql/log/mysqld.log
#是否支持符号链接，即数据库或表可以存储在my.cnf中指定datadir之外的分区或目录，为0不开启
# symbolic-links=0
# 比较名字时忽略大小写，创建表时，大写字母将转为小写字母
# 特别关注：集群所有节点设置必须一致
lower_case_table_names=1

###MGR集群配置###
# 特别关注：以下参数，除loose-group_replication_bootstrap_group需要在不同节点灵活配置外，集群所有节点建议设置一致
# 在MGR中，必须使用InnoDB存储引擎，使用其他存储引擎可能会导致MGR发生错误。设置系统变量disabled_storage_engines以防止其他存储引擎被使用
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY" 
# 配置默认引擎为INNODB
default_storage_engine=INNODB
# 全局事务
gtid_mode = ON 
# 强制GTID的一致性
enforce_gtid_consistency = ON 
# 将master.info元数据保存在系统表中
master_info_repository = TABLE 
# 将relay.info元数据保存在系统表中
relay_log_info_repository = TABLE 
# 禁用二进制日志事件校验
binlog_checksum = NONE 
# 级联复制，即设置每个节点都要转存binlog
log_slave_updates = ON 
# 开启二进制日志记录
log_bin = binlog 
# 以行的格式记录
binlog_format = ROW 
# 设置多线程复制类型为逻辑时钟（5.7新增）提高效率，默认为数据库（DATABASE）
slave_parallel_type=logical_clock
slave_parallel_workers=16
slave_preserve_commit_order=ON
# 使用哈希算法将其编码为散列
transaction_write_set_extraction = XXHASH64 
# 自增长字段配置，由于集群中所有节点都可能执行写操作，所有自增字段需要配置起始偏移以及自增量，避免多服务器重复
# 配置加载顺序
# 1.服务器启动时加载本地配置 auto_increment_increment和 auto_increment_offset
# 2.组复制插件启动时，如果auto_increment_increment和 auto_increment_offset都配置为1，则分别使用group_replication_auto_increment_increment和 server_id 的值替代
# 3.组复制插件停止时，如果启动时执行了替代，将两个还原为本地配置
#group_replication_auto_increment_increment可配置，默认为7，不支持group_replication_auto_increment_offset参数，即server_id必定替代auto_increment_offset
# 单主模式下，可以配置自增量为1，多主模式下，官方建议自增配置为集群内成员数
auto_increment_increment=1
auto_increment_offset=1
group_replication_auto_increment_increment=1

#测试用：关闭binlog，配置skip-log-bin 或 disable-log-bin，该配置在binlog相关配置之后才能生效，因为mysql遵循后配置优先生效原则
#skip-log-bin

# 启动自动加载插件，否则需要在启动后执行 install plugin group_replication soname 'group_replication.so';
plugin_load = 'group_replication=group_replication.so'
# MGR配置项变量使用loose-前缀表示Server启用时没有加载复制插件也能继续启动
# 组名，可以自定义，格式是UUID，集群所有主机需要一致
loose-group_replication_group_name = '620245b8-87f4-4591-b805-898e2ee8043a'
# 启用MGR单主模式，以下2个参数用于切换单主模式与多主模式
loose-group_replication_single_primary_mode = ON
loose-group_replication_enforce_update_everywhere_checks = OFF
# 在服务器启动时不要自动开启复制插件，这一步十分重要，可以确保在启动组复制之前，可以进行一些配置修改，如配置同步用户，配置同步规则等，配置完成后，才能正常组建集群
# 集群组建完成后，可以改成on，后期节点故障后重启服务即可自动加入集群
loose-group_replication_start_on_boot = OFF 
# 这个变量告诉插件是否开启“引导组”的功能。
# 一般来说一个组中需要且只能有一个server将次参数设置为on，但是在搭建时，都先使用off，防止启动时出现脑裂的情况，即所有节点各自创建新的复制组
# 所以，在第一个server启动上线后，再开启这个参数，启动复制组后，立即关闭
loose-group_replication_bootstrap_group = OFF
# 允许加入复制组的实例自身存在binlog，否则会报异常：[ERROR] Plugin group_replication reported: \'This member has more executed transactions than those present in the group.
loose-group_replication_allow_local_disjoint_gtids_join = ON
# IP白名单，可以不配置，默认为AUTOMATIC，即自动识别 127.0.0.1 以及 服务器当前所在局域网的所有IP（10，172.16 - 172.31，192.168）
# 配置格式支持：ip、ip/子网掩码、AUTOMATIC
# 如果集群中的各服务器不在同一个局域网，则需要明确配置白名单
# MySQL 8.0.22之前使用 group_replication_ip_whitelist，之后使用 group_replication_ip_allowlist
# group_replication_ip_whitelist='192.168.11.13/24'
```

确认一下是否修改了以下配置为当前节点IP

```
# 服务ID，官方建议server_id最好为1，2，3这样的自增量，且每台都不同
server_id = 1 
# 如果服务器开启了防火墙，需要允许33071
loose-group_replication_local_address = '192.168.139.101:33071'
# 种子节点的IP和端口号，新成员加入到集群的时候需要联系种子节点获取复制数据，启动集群的节点不使用该选项
loose-group_replication_group_seeds = '192.168.139.101:33071,192.168.139.102:33071'
# mysql默认通过dns查找其他服务器，如果多台服务器hostname配置相同，将无法正确解析，此处配置使集群中以IP为服务器标识
report_host=192.168.139.101
```

修改完后重启mysql服务

```bash
service mysql restart
```

### 2.主节点设置

修改my.cnf配置

```
###集群中各服务器需要单独配置的项###
# 服务ID，官方建议server_id最好为1，2，3这样的自增量，且每台都不同
server_id = 1 
# 本节点的IP地址和端口，注意该端口是组内成员之间通信的端口，而不是MySQL对外提供服务的端口
# 如果服务器开启了防火墙，需要允许33071
loose-group_replication_local_address = '192.168.139.101:33071'
# 种子节点的IP和端口号，新成员加入到集群的时候需要联系种子节点获取复制数据，启动集群的节点不使用该选项
loose-group_replication_group_seeds = '192.168.139.101:33071,192.168.139.102:33071'
# mysql默认通过dns查找其他服务器，如果多台服务器hostname配置相同，将无法正确解析，此处配置使集群中以IP为服务器标识
report_host=192.168.139.101
#不再进行反解析（ip不反解成域名），加快数据库的反应时间
skip-name-resolve

###集群中各服务器需要单独配置的项###
# mysql mgr集群所有节点同时离线（如机房停电等）后，无法自动开启集群
# 此时各节点启动后，并没有组成集群，各自具有读写能力，如果客户端连接不同节点进行操作，就会造成数据不一致，此时再创建集群，就会遇到问题
# 将所有节点默认设置为只读状态，创建集群/加入集群后，由mgr自动修改其只读状态，避免客户端连接而数据不一致
# 普通用户只读
read_only=1
# 超级权限用户只读
super_read_only=1

# mysql日志时间默认为utc，改为与系统一致
log_timestamps=SYSTEM
# 比较名字时忽略大小写，创建表时，大写字母将转为小写字母
# 特别关注：集群所有节点设置必须一致
lower_case_table_names=1

###MGR集群配置###
# 特别关注：以下参数，除loose-group_replication_bootstrap_group需要在不同节点灵活配置外，集群所有节点建议设置一致
# 在MGR中，必须使用InnoDB存储引擎，使用其他存储引擎可能会导致MGR发生错误。设置系统变量disabled_storage_engines以防止其他存储引擎被使用
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY" 
# 配置默认引擎为INNODB
default_storage_engine=INNODB
# 全局事务
gtid_mode = ON 
# 强制GTID的一致性
enforce_gtid_consistency = ON 
# 将master.info元数据保存在系统表中
master_info_repository = TABLE 
# 将relay.info元数据保存在系统表中
relay_log_info_repository = TABLE 
# 禁用二进制日志事件校验
binlog_checksum = NONE 
# 级联复制，即设置每个节点都要转存binlog
log_slave_updates = ON 
# 开启二进制日志记录
log_bin = binlog 
# 以行的格式记录
binlog_format = ROW 
# 设置多线程复制类型为逻辑时钟（5.7新增）提高效率，默认为数据库（DATABASE）
slave_parallel_type=logical_clock
slave_parallel_workers=16
slave_preserve_commit_order=ON
# 使用哈希算法将其编码为散列
transaction_write_set_extraction = XXHASH64 
# 自增长字段配置，由于集群中所有节点都可能执行写操作，所有自增字段需要配置起始偏移以及自增量，避免多服务器重复
# 配置加载顺序
# 1.服务器启动时加载本地配置 auto_increment_increment和 auto_increment_offset
# 2.组复制插件启动时，如果auto_increment_increment和 auto_increment_offset都配置为1，则分别使用group_replication_auto_increment_increment和 server_id 的值替代
# 3.组复制插件停止时，如果启动时执行了替代，将两个还原为本地配置
#group_replication_auto_increment_increment可配置，默认为7，不支持group_replication_auto_increment_offset参数，即server_id必定替代auto_increment_offset
# 单主模式下，可以配置自增量为1，多主模式下，官方建议自增配置为集群内成员数
auto_increment_increment=1
auto_increment_offset=1
group_replication_auto_increment_increment=1


# 启动自动加载插件，否则需要在启动后执行 install plugin group_replication soname 'group_replication.so';
plugin_load = 'group_replication=group_replication.so'
# MGR配置项变量使用loose-前缀表示Server启用时没有加载复制插件也能继续启动
# 组名，可以自定义，格式是UUID，集群所有主机需要一致
loose-group_replication_group_name = 'bb6df095-24ac-4aa7-b09d-ddc9508f6940'
# 启用MGR单主模式，以下2个参数用于切换单主模式与多主模式
loose-group_replication_single_primary_mode = ON
loose-group_replication_enforce_update_everywhere_checks = OFF
# 在服务器启动时不要自动开启复制插件，这一步十分重要，可以确保在启动组复制之前，可以进行一些配置修改，如配置同步用户，配置同步规则等，配置完成后，才能正常组建集群
# 集群组建完成后，可以改成on，后期节点故障后重启服务即可自动加入集群
loose-group_replication_start_on_boot = OFF 
# 这个变量告诉插件是否开启“引导组”的功能。
# 一般来说一个组中需要且只能有一个server将次参数设置为on，但是在搭建时，都先使用off，防止启动时出现脑裂的情况，即所有节点各自创建新的复制组
# 所以，在第一个server启动上线后，再开启这个参数，启动复制组后，立即关闭
loose-group_replication_bootstrap_group = OFF
# 允许加入复制组的实例自身存在binlog，否则会报异常：[ERROR] Plugin group_replication reported: \'This member has more executed transactions than those present in the group.
loose-group_replication_allow_local_disjoint_gtids_join = ON
# IP白名单，可以不配置，默认为AUTOMATIC，即自动识别 127.0.0.1 以及 服务器当前所在局域网的所有IP（10，172.16 - 172.31，192.168）
# 配置格式支持：ip、ip/子网掩码、AUTOMATIC
# 如果集群中的各服务器不在同一个局域网，则需要明确配置白名单
# MySQL 8.0.22之前使用 group_replication_ip_whitelist，之后使用 group_replication_ip_allowlist
# group_replication_ip_whitelist='192.168.11.13/24'
```

重启服务

```
service mysql restart
```

登录mysql

```bash
/usr/local/mysql/bin/mysql -uroot -p123456
```

创建用户和同步规则

```mysql
SET SQL_LOG_BIN=0;
set global super_read_only=off;

# 创建集群复制专用用户，配置用户复制权限
grant replication slave on *.* to 'repl_user'@'%' identified by 'Repl_pass_123';
flush privileges;
# 配置同步规则
CHANGE MASTER TO MASTER_USER='repl_user', MASTER_PASSWORD='Repl_pass_123' FOR CHANNEL 'group_replication_recovery';

set global super_read_only=on;
SET SQL_LOG_BIN=1;
```

开启引导组

```mysql
set global group_replication_bootstrap_group=on;
start group_replication;
set global group_replication_bootstrap_group=off;
```

查看集群信息

```mysql
# 可以查询集群节点信息
select * from performance_schema.replication_group_members;
# 查询主节点
select * from performance_schema.global_status where variable_name like '%group%';
# 查询节点状态，如只读状态，主节点可读写OFF，从节点只读ON
show global variables like '%super%';
```

修改配置

[配置修改](#4.修改配置)

### 3.启动其他节点

修改my.cnf配置

```bash
vi my.cnf
```

```
###集群中各服务器需要单独配置的项###
# 服务ID，官方建议server_id最好为1，2，3这样的自增量，且每台都不同
server_id = 2
# 本节点的IP地址和端口，注意该端口是组内成员之间通信的端口，而不是MySQL对外提供服务的端口
# 如果服务器开启了防火墙，需要允许33071
loose-group_replication_local_address = '192.168.139.102:33071'
# 种子节点的IP和端口号，新成员加入到集群的时候需要联系种子节点获取复制数据，启动集群的节点不使用该选项
loose-group_replication_group_seeds = '192.168.139.101:33071,192.168.139.102:33071'
# mysql默认通过dns查找其他服务器，如果多台服务器hostname配置相同，将无法正确解析，此处配置使集群中以IP为服务器标识
report_host=192.168.139.102
#不再进行反解析（ip不反解成域名），加快数据库的反应时间
skip-name-resolve

###集群中各服务器需要单独配置的项###
# mysql mgr集群所有节点同时离线（如机房停电等）后，无法自动开启集群
# 此时各节点启动后，并没有组成集群，各自具有读写能力，如果客户端连接不同节点进行操作，就会造成数据不一致，此时再创建集群，就会遇到问题
# 将所有节点默认设置为只读状态，创建集群/加入集群后，由mgr自动修改其只读状态，避免客户端连接而数据不一致
# 普通用户只读
read_only=1
# 超级权限用户只读
super_read_only=1

# mysql日志时间默认为utc，改为与系统一致
log_timestamps=SYSTEM
# 比较名字时忽略大小写，创建表时，大写字母将转为小写字母
# 特别关注：集群所有节点设置必须一致
lower_case_table_names=1

###MGR集群配置###
# 特别关注：以下参数，除loose-group_replication_bootstrap_group需要在不同节点灵活配置外，集群所有节点建议设置一致
# 在MGR中，必须使用InnoDB存储引擎，使用其他存储引擎可能会导致MGR发生错误。设置系统变量disabled_storage_engines以防止其他存储引擎被使用
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY" 
# 配置默认引擎为INNODB
default_storage_engine=INNODB
# 全局事务
gtid_mode = ON 
# 强制GTID的一致性
enforce_gtid_consistency = ON 
# 将master.info元数据保存在系统表中
master_info_repository = TABLE 
# 将relay.info元数据保存在系统表中
relay_log_info_repository = TABLE 
# 禁用二进制日志事件校验
binlog_checksum = NONE 
# 级联复制，即设置每个节点都要转存binlog
log_slave_updates = ON 
# 开启二进制日志记录
log_bin = binlog 
# 以行的格式记录
binlog_format = ROW 
# 设置多线程复制类型为逻辑时钟（5.7新增）提高效率，默认为数据库（DATABASE）
slave_parallel_type=logical_clock
slave_parallel_workers=16
slave_preserve_commit_order=ON
# 使用哈希算法将其编码为散列
transaction_write_set_extraction = XXHASH64
# 自增长字段配置，由于集群中所有节点都可能执行写操作，所有自增字段需要配置起始偏移以及自增量，避免多服务器重复
# 配置加载顺序
# 1.服务器启动时加载本地配置 auto_increment_increment和 auto_increment_offset
# 2.组复制插件启动时，如果auto_increment_increment和 auto_increment_offset都配置为1，则分别使用group_replication_auto_increment_increment和 server_id 的值替代
# 3.组复制插件停止时，如果启动时执行了替代，将两个还原为本地配置
#group_replication_auto_increment_increment可配置，默认为7，不支持group_replication_auto_increment_offset参数，即server_id必定替代auto_increment_offset
# 单主模式下，可以配置自增量为1，多主模式下，官方建议自增配置为集群内成员数
auto_increment_increment=1
auto_increment_offset=1
group_replication_auto_increment_increment=1


# 启动自动加载插件，否则需要在启动后执行 install plugin group_replication soname 'group_replication.so';
plugin_load = 'group_replication=group_replication.so'
# MGR配置项变量使用loose-前缀表示Server启用时没有加载复制插件也能继续启动
# 组名，可以自定义，格式是UUID，集群所有主机需要一致
loose-group_replication_group_name = 'bb6df095-24ac-4aa7-b09d-ddc9508f6940'
# 启用MGR单主模式，以下2个参数用于切换单主模式与多主模式
loose-group_replication_single_primary_mode = ON
loose-group_replication_enforce_update_everywhere_checks = OFF
# 在服务器启动时不要自动开启复制插件，这一步十分重要，可以确保在启动组复制之前，可以进行一些配置修改，如配置同步用户，配置同步规则等，配置完成后，才能正常组建集群
# 集群组建完成后，可以改成on，后期节点故障后重启服务即可自动加入集群
loose-group_replication_start_on_boot = OFF 
# 这个变量告诉插件是否开启“引导组”的功能。
# 一般来说一个组中需要且只能有一个server将次参数设置为on，但是在搭建时，都先使用off，防止启动时出现脑裂的情况，即所有节点各自创建新的复制组
# 所以，在第一个server启动上线后，再开启这个参数，启动复制组后，立即关闭
loose-group_replication_bootstrap_group = OFF
# 允许加入复制组的实例自身存在binlog，否则会报异常：[ERROR] Plugin group_replication reported: \'This member has more executed transactions than those present in the group.
loose-group_replication_allow_local_disjoint_gtids_join = ON
# IP白名单，可以不配置，默认为AUTOMATIC，即自动识别 127.0.0.1 以及 服务器当前所在局域网的所有IP（10，172.16 - 172.31，192.168）
# 配置格式支持：ip、ip/子网掩码、AUTOMATIC
# 如果集群中的各服务器不在同一个局域网，则需要明确配置白名单
# MySQL 8.0.22之前使用 group_replication_ip_whitelist，之后使用 group_replication_ip_allowlist
# group_replication_ip_whitelist='192.168.11.13/24'
```

重启服务

```
service mysql restart
```

登录mysql

```bash
/usr/local/mysql/bin/mysql -uroot -p123456
```

创建用户和同步规则

```mysql
SET SQL_LOG_BIN=0;
set global super_read_only=off;

# 创建集群复制专用用户，配置用户复制权限
grant replication slave on *.* to 'repl_user'@'%' identified by 'Repl_pass_123';
flush privileges;
# 配置同步规则
CHANGE MASTER TO MASTER_USER='repl_user', MASTER_PASSWORD='Repl_pass_123' FOR CHANNEL 'group_replication_recovery';

set global super_read_only=on;
SET SQL_LOG_BIN=1;
```

加入引导组

```mysql
start group_replication;
```

查看集群信息

```mysql
# 可以查询集群节点信息
select * from performance_schema.replication_group_members;
# 查询主节点
select * from performance_schema.global_status where variable_name like '%group%';
# 查询节点状态，如只读状态，主节点可读写OFF，从节点只读ON
show global variables like '%super%';
```

修改配置

[配置修改](#4.修改配置)

### 4.修改配置

```bash
vi my.cnf
```

集群组建完成后，可以改成on，后期节点故障后重启服务即可自动加入集群

```
loose-group_replication_start_on_boot = ON
```

```
# 这个变量告诉插件是否开启“引导组”的功能。
# 一般来说一个组中需要且只能有一个server将次参数设置为on，但是在搭建时，都先使用off，防止启动时出现脑裂的情况，即所有节点各自创建新的复制组
# 所以，在第一个server启动上线后，再开启这个参数，启动复制组后，立即关闭
loose-group_replication_bootstrap_group = OFF
```

```bash
service mysql restart
```

## 三、测试

- [ ] 搭建成功时需要测试条目
  - [ ] 集群信息是否正常，两条服务信息
  - [ ] 主库信息是否正常，主库是否正确，主库可以正常写入数据
  - [ ] 从库信息是否正常，从库不可以写入数据
  - [ ] 主库写入数据，查看从库是否同步数据、数据是否保持一致
- [ ] 正常重启使用`service mysql stop|start`
  - [ ] 主库，从节点 重启后是否正常加入复制组、数据是否正确

## 参考文章

1. [MySQL 中常见的几种高可用架构部署方案](https://www.cnblogs.com/ricklz/p/17335755.html)

2. [MySQL MGR集群搭建（CentOS7 + MySQL 5.7.35）](https://www.cnblogs.com/xiaoyaozhe/p/17671323.html)

3. 

   