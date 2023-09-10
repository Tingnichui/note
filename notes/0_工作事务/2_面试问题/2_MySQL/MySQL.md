## 主要组成

### 存储引擎区别

lnnoDB和MyISAM区别?

[Mysql第三章：存储引擎（MyISAM和Innodb）](https://blog.csdn.net/huyiju/article/details/80968962?ops_request_misc=&request_id=&biz_id=102&utm_term=%E5%AD%98%E5%82%A8%E5%BC%95%E6%93%8Emyisam%E5%92%8Cinnodb&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-7-80968962.142^v71^insert_chatgpt,201^v4^add_ask&spm=1018.2226.3001.4187) 

MyISAM

1. 数据索引和存储数据分离
2. 索引结构为B+树，数据域存储的内容为实际数据的地址（非聚簇索引）
3. 执行读取操作的速度很快，而且不占用大量的内存和存储资源
4. 不支持事务，插入或更新数据时操作需要锁定整个表，效率便会低一些

Innodb

1. 索引文件和数据文件是不分离的
2. 二级索引存储对应主键的值而不是数据地址
3. 支持事务，使用MVCC多版本控制器来控制事务

### 版本差异

不同版本的加锁差异

### 组成部分

> MySQL 数据库由 Server 层和 Engine 层组成。Server 层有 SQL 分析器、SQL优化器、SQL 执行器，用于负责 SQL 语句的具体执行过程；Engine 层负责存储具体的数据，如最常使用的 InnoDB 存储引擎，还有用于在内存中存储临时结果集的 TempTable 存储引擎。
>
> 优化器：优化器的选择是基于成本，它会分析所有可能的执行计划，哪个索引的成本越低，优先使用哪个索引。这种优化器称之为：CBO（Cost-based Optimizer，基于成本的优化器）

复合索引的优化?

大量回表索引失效问题? 优化器如何判断?

[mysql回表致索引失效](https://blog.csdn.net/sz85850597/article/details/91999015?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167423423616800222837055%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167423423616800222837055&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-1-91999015-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%9B%9E%E8%A1%A8%E7%B4%A2%E5%BC%95%E5%A4%B1%E6%95%88&spm=1018.2226.3001.4187)，通过强制走索引，问题在于当一条sql查询超过表中超过大概17%的记录且不能使用覆盖索引时，会出现索引的回表代价太大而选择全表扫描的现象。且这个比例随着单行记录的字节大小的增加而略微增大。

## 其他参数优化

lnnodb_buffer_pool_size

Sync_binlog

query cache

MRR

## 事务

ACID四大特性

- 持久性与一致性的区别?
- 与CAP的一致性区别?
- 原子性含义?
- 持久性如何实现?

代码如何控制?

binlog、redolog、undolog的应用
