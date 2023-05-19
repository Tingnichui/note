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

## 隔离级别

### 如何实现？能够解决幻读？

[【MySQL笔记】正确的理解MySQL的MVCC及实现原理](https://blog.csdn.net/SnailMann/article/details/94724197?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167162004516800192276489%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167162004516800192276489&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-94724197-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=MVCC&spm=1018.2226.3001.4187) 

> MVCC （多版本并发控制）主要是为了提高数据库并发性能，用更好的方式去处理读-写冲突，做到即使有读写冲突时，也能做到不加锁，非阻塞并发读，快照读就是 MySQL 实现 MVCC 理想模型的其中一个非阻塞读功能。实现原理：3个隐式字段，undo日志， Read View

3个隐式字段：**DB_TRX_ID**---最近修改(修改/插入)事务 ID、**DB_ROLL_PTR**---回滚指针，指向这条记录的上一个版本（存储于 rollback segment 里）、**DB_ROW_ID**---隐含的自增 ID（隐藏主键），如果数据表没有主键，InnoDB 会自动以`DB_ROW_ID`产生一个聚簇索引

Undo log日志（历史版本）：insert undo log：代表事务在 `insert` 新记录时产生的 `undo log`, 只在事务回滚时需要，并且在事务提交后可以被立即丢弃，update undo log：事务在进行 `update` 或 `delete` 时产生的 `undo log` ; 不仅在事务回滚时需要，在快照读时也需要；所以不能随便删除，只有在快速读或事务回滚不涉及该日志时，对应的日志才会被 `purge` 线程统一清除

Read View：在该事务执行的快照读的那一刻，会生成数据库系统当前的一个快照，记录并维护系统当前活跃事务的 ID ，所以我们知道 `Read View` 主要是用来做可见性判断的, 即当我们某个事务执行快照读的时候，对该记录创建一个 `Read View` 读视图，把它比作条件用来判断当前事务能够看到哪个版本的数据，既可能是当前最新的数据，也有可能是该行记录的`undo log`里面的某个版本的数据。

**读取已提交（rc）**生成ReadView的粒度是以每个**select**单位，所以A事务前后生成的ReadView不同。**可重复读（rr）**生成ReadView的粒度是以**事务**为粒度生成的，同一个事务只会生成一个ReadView所以避免了可重复读的问题

[MVCC能否解决幻读问题 ](https://blog.csdn.net/Edwin_Hu/article/details/124392174?ops_request_misc=&request_id=&biz_id=102&utm_term=mvvc%E5%8F%AF%E4%BB%A5%E8%A7%A3%E5%86%B3%E5%B9%BB%E8%AF%BB&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-124392174.142^v71^insert_chatgpt,201^v4^add_ask&spm=1018.2226.3001.4187)

MVCC在快照读的情况下可以解决幻读问题，但是在当前读的情况下是不能解决幻读的，事务A与事务B，事务B增加数据提交后，事务A通过update更新事务A的数据，由于update是当前读，所以此时会读取最新的数据(包括其他已经提交的事务)，从而导致幻读

### 事务隔离级别

#### 幻读如何解决？

1. 当前读与快照读的区别？
   - 当前读，读取的是最新版本，并且需要先获取对应记录的锁，例如`select ... lock in share mode`、`select ... for update`、`update `、`delete` 、`insert`
   - 快照读，读取某一个快照建立时的数据，也称为一致性读
2. MVCC能解决幻读吗?间隙锁的用途?
   - 不能，因此不能使用范围更新
   - [间隙锁详解](https://blog.csdn.net/qq_19734597/article/details/81030920?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167423646816800215054403%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167423646816800215054403&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-81030920-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E9%97%B4%E9%9A%99%E9%94%81&spm=1018.2226.3001.4187)，目的一方面是为了防止幻读；另外一方面，是为了满足其恢复和复制的需要

#### 持久性与一致性的区别？

与CAP的一致性区别?分布式事务如何实现隔离级别?

### 锁粒度

[MySQL锁详解](https://blog.csdn.net/qq_40378034/article/details/90904573?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166840665116800186551349%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166840665116800186551349&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-2-90904573-null-null.142^v63^js_top,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=mysql%E9%94%81&spm=1018.2226.3001.4187) 

[mysql锁（九）innodb下的记录锁，间隙锁，next-key锁](https://www.jianshu.com/p/bf862c37c4c9) 

全局锁、表级锁、行级锁。

**全局锁**使用场景为备份，

**表级锁**有两种，一是表锁，还有一个元数据锁（MDL），表锁需要显示调用，元数据锁不需要，元数据锁主要是为了保证读写的一致性，当对一个表进行增删改查时会加读锁，当对表做结构变更时会加写锁，读锁不互斥，读写锁之间、写锁之间是互斥的，用来保证变更表结构操作的安全性

**行锁**是由引擎实现的，行锁在需要的时候加上，在事务结束时才释放，所以将并发较高的锁尽量向后放，[死锁](https://blog.csdn.net/qq_24691007/article/details/122932768?ops_request_misc=&request_id=&biz_id=102&utm_term=mysql%E6%AD%BB%E9%94%81&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-2-122932768.nonecase&spm=1018.2226.3001.4187)默认等待时间是50s，mysql也有死锁检测。

**间隙锁（Gap Lock）：**只存在于rr级别下并且检索条件必须有索引，目的是通过防止间隙内有新数据被插入和防止已存在的数据，更新成间隙内的数据这两种方法防止幻读([Mysql如何解决幻读](https://blog.csdn.net/weixin_43059299/article/details/118851604?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167169007416800180626598%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167169007416800180626598&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-4-118851604-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=mysql%E5%B9%BB%E8%AF%BB&spm=1018.2226.3001.4187)) 

**next-key锁：**包含了记录锁和间隙锁，即锁定一个范围，并且锁定记录本身，InnoDB默认加锁方式是next-key 锁。

## 分区分表

[什么是分库分区分表](https://blog.csdn.net/miachen520/article/details/113839579) 

[数据库分区、分表、分库、分片](https://blog.csdn.net/weixin_42223833/article/details/113678698?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167427430616800215055770%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=167427430616800215055770&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-12-113678698-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%88%86%E5%8C%BA%E5%88%86%E8%A1%A8%E5%90%8E%E7%9A%84%E4%BA%8B%E5%8A%A1&spm=1018.2226.3001.4187) 

[在数据库分库分表之后，你该如何解决事务问题？](https://blog.csdn.net/woshinidadaye_/article/details/117400522?ops_request_misc=&request_id=&biz_id=102&utm_term=%E5%88%86%E5%8C%BA%E5%88%86%E8%A1%A8%E5%90%8E%E7%9A%84%E4%BA%8B%E5%8A%A1&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-117400522.142^v71^insert_chatgpt,201^v4^add_ask&spm=1018.2226.3001.4187) 

## SQL优化

### explain分析

[EXPLAIN用法和结果分析](https://blog.csdn.net/why15732625998/article/details/80388236?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166823555816782428610984%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166823555816782428610984&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-80388236-null-null.142^v63^js_top,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=explain&spm=1018.2226.3001.4187) 

type：system > const > eq_ref > ref > range > index > all

### DDL慢

> DDL（Data Definition Language）语句： `数据定义语言`，主要是进行定义/改变表的结构、数据类型、表之间的链接等操作。常用的语句关键字有 CREATE、DROP、ALTER 等。

#### 元数据锁（MDL）

大事务导致持有mdl写锁，等待执行结束或者kill掉事务

#### 大表

[Online DDL详解](https://blog.csdn.net/weixin_45238761/article/details/125343029?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167420361616800217063897%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167420361616800217063897&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-3-125343029-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=online%20ddl&spm=1018.2226.3001.4187) 

mysql5.6版本后加入的特性，用于支持DDL执行期间DML语句的并行操作，提高数据库的吞吐量

1. **COPY：**MySQL 5.6之前非Online(offline离线的而非在线的)，都是执行这种算法，会生成（临时）新表，将原表数据逐行拷贝到新表中（耗时长），在此期间会阻塞DML，整个流程都加锁
2. **INPLACE：** MySQL 5.6之后，无需拷贝全表数据到新表，但可能还是需要IN-PLACE方式（原地，无需生成新的临时表）重建整表。在准备和提交两个阶段时通常需要加MDL排他锁，执行期间可以并行DML，将所有对原表的DML操作记录在日志文件row log中
3. **INSTANT：**MySQL 8.0.12，只该操作仅仅修改元数据。在准备和执行期间，表上没有独占的元数据锁，并且表数据不受影响，因此操作是即时的。允许并发DML。目前仅支持在表最后增加新列；

### 全局优化配置optimizer_trace

[手把手教你认识OPTIMIZER_TRACE](https://www.modb.pro/db/406511) 

### 写入慢

[MySQL插入数据很慢优化思路](https://blog.csdn.net/weixin_38370441/article/details/115678398) 

[Mysql数据库insert报慢查询](https://blog.csdn.net/xiaolyuh123/article/details/78793626) 

[针对 MySQL/InnoDB 刷盘调优](https://blog.csdn.net/yangjianrong1985/article/details/125289330?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167421861816800184179358%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=167421861816800184179358&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-125289330-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E6%89%B9%E9%87%8F%E5%88%B7%E7%9B%98%E4%BC%98%E5%8C%96&spm=1018.2226.3001.4187) 

[mysql刷盘机制详解](https://blog.csdn.net/qq_40687433/article/details/112540401?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167421875116800222818308%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=167421875116800222818308&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-112540401-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%88%B7%E7%9B%98%20%E6%98%AF%E4%BB%80%E4%B9%88&spm=1018.2226.3001.4187) 

1. 索引优化
2. 批量刷盘优化

### 回表优化

1. 索引下推
2. 索引覆盖

### B+树性质

[换一个角度看 B+ 树](https://mp.weixin.qq.com/s?__biz=MzUxODAzNDg4NQ==&mid=2247502059&idx=1&sn=ccbee22bda8c3d6a98237be769a7c89c&scene=21#wechat_redirect) 

1. 为什么叶子节点是双向链表
   - 对范围查找非常有帮助，不需要从根节点查询，节省查询需要的时间

2. 为什么不是Skiplist
   - [Mysql的索引为什么使用B+树而不使用跳表](https://blog.csdn.net/qwer123451234123/article/details/124305626)，跳表多层链表结构，层数太高IO开销大
3. 哈希索引与B+索引的比较
   - [哈希索引和B+树索引的区别 (Hash索引 和 B+tree索引 区别)](https://blog.csdn.net/weixin_43841693/article/details/107301253?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167428215116782429741935%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=167428215116782429741935&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-2-107301253-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%93%88%E5%B8%8C%E7%B4%A2%E5%BC%95%E4%B8%8EB%2B%E7%B4%A2%E5%BC%95%E7%9A%84%E6%AF%94%E8%BE%83&spm=1018.2226.3001.4187) 
   - 大多数场景下，都会有组合查询，范围查询、排序、分组、模糊查询等查询特征，Hash 索引无法满足要求，建议数据库使用B+树索引
   - 在离散型高，数据基数大，且等值查询时候，Hash索引有优势。

4. 查询数据的过程
   - [mysql执行查询全流程解析](https://bbs.huaweicloud.com/blogs/314468)

5. 范围查询过程
   - [mysql范围查询流程](https://blog.csdn.net/wys0912/article/details/127113007)

## 日志

[mysql里面的日志](https://blog.csdn.net/pengchenxin/article/details/123627046) 

### binlog

应用场景 复制：MySQL 主从复制在 Master 端开启 binlog，Master 把它的二进制日志传递给 slaves 并回放来达到 master-slave 数据一致的目的

数据恢复：通过 mysqlbinlog 工具恢复数据

格式差异 STATMENT 、 ROW 和 MIXED。

### redolog

用途

- redo log 包括两部分：一个是内存中的日志缓冲( redo log buffer )，另一个是磁盘上的日志文件( redo logfile)。

  事务提交后不需要每一次都把数据写入磁盘中，先写到redo log日志中，然后写入磁盘。

  redo log 和写表的区别就在于随机写和顺序写。MySQL 的表数据是随机存储在磁盘中的，而 redo log 是一块固定大小的连续空间。而磁盘顺序写入要比随机写入快几个数量级。

如何保证数据不丢失

- 同时我们很容易得知， 在innodb中，既有redo log 需要刷盘，还有 数据页 也需要刷盘， redo log存在的意义主要就是降低对 数据页 刷盘的要求 ** 。在上图中， write pos 表示 redo log 当前记录的 LSN (逻辑序列号)位置， check point 表示 数据页更改记录 刷盘后对应 redo log 所处的 LSN(逻辑序列号)位置。write pos 到 check point 之间的部分是 redo log 空着的部分，用于记录新的记录；check point 到 write pos 之间是 redo log 待落盘的数据页更改记录。当 write pos追上check point 时，会先推动 check point 向前移动，空出位置再记录新的日志。启动 innodb 的时候，不管上次是正常关闭还是异常关闭，总是会进行恢复操作。因为 redo log记录的是数据页的物理变化，因此恢复的时候速度比逻辑日志(如 binlog )要快很多。重启innodb 时，首先会检查磁盘中数据页的 LSN ，如果数据页的LSN 小于日志中的 LSN ，则会从 checkpoint 开始恢复。还有一种情况，在宕机前正处于checkpoint 的刷盘过程，且数据页的刷盘进度超过了日志页的刷盘进度，此时会出现数据页中记录的 LSN 大于日志中的 LSN，这时超出日志进度的部分将不会重做，因为这本身就表示已经做过的事情，无需再重做。

### undolog

事务回滚控制

-  undo log主要记录了数据的逻辑变化，比如一条 INSERT 语句，对应一条DELETE 的 undo log ，对于每个 UPDATE 语句，对应一条相反的 UPDATE 的 undo log ，这样在发生错误时，就能回滚到事务之前的数据状态。同时， undo log 也是 MVCC(多版本并发控制)实现的关键。

## 高可用（主从）

### 数据一致性怎么解决?

1. 强制走主
2. 实现方案——AOP DB拦截器

### 写入如何扩展?

1. 纵向  增加DB配置
2. 横向 分库分表

### 主从延迟风险规避?

1. 切面拦截 强制走主
2. 按一致性要求分离

## 性能优化

### 缓冲区

#### changeBuffer

> [change buffer(写缓冲)](https://blog.csdn.net/qq_42979842/article/details/108031299?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167431898516782425633514%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167431898516782425633514&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-108031299-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=changeBuffer&spm=1018.2226.3001.4187) 
>
> change buffer就是在**非唯一普通索引页**不在buffer pool中时，对页进行了写操作的情况下，先将记录变更缓冲，等未来数据被读取时，再将 change buffer 中的操作merge到原数据页的技术。在MySQL5.5之前，叫插入缓冲(insert buffer)，只针对insert做了优化；现在对delete和update也有效，叫做写缓冲(change buffer)。

普通索引与唯一索引处理差异？

**唯一索引**

- 所有的更新操作都要先判断这个操作是否违反唯一性约束。而这必须要将数据页读入内存才能判断。
- 如果都已经读入到内存了，那直接更新内存会更快，就没必要使用 change buffer 了。

  因此，唯一索引的更新就不能使用 change buffer，实际上也只有普通索引可以使用。

**普通索引**

- 不需要判断唯一性，正常使用 change buffer 更新。

#### 批量刷盘

[MySQL数据和日志的刷盘机制以及双一配置](https://blog.csdn.net/weixin_43767015/article/details/118549790?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167431916716800225515323%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167431916716800225515323&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-118549790-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%88%B7%E7%9B%98&spm=1018.2226.3001.4187) 

[细说MySQL中磁盘与CPU的交互——神秘的Buffer Pool](https://blog.csdn.net/qq_39093474/article/details/125582792) 

数据不丢失如何解决?

缓冲区的几个链表用途?

### 分库分表

#### 水平拆分

##### 分布式事务解决方案

1. cap
2. base最终一致
3. 具体框架——tcc seata saga
4. 理论基础——二阶/三阶段提交

##### 分片规则如何设计

1. 尽量离散
2. 尽量避免分布式事务
3. 业务逻辑——不同业务分片规则冲突？

##### 数据如何迁移

1. 停机迁移——跑批工具、数据校验、业务低峰
2. 平滑迁移
   1. 数据完整性校验——切读流量动态校验、灰度切流、监控告警
   2. 兼容性发布——先双写在增量

#### 垂直拆分

1. 为什么反范式设计？——结合业务场景&性能
2. 拆分思路
   1. 字段访问频率
   2. 业务模型

#### 冷热分离

1. 为什么冷数据归档——避免大表影响性能
2. 分离规则
   1. 定时任务滚动归档
   2. 业务实时归档

## 索引相关

### 索引数据结构

1. hash

2. B+——聚族索引和非聚族索引

3. full-text

   - [MySQL 之全文索引](https://blog.csdn.net/mrzhouxiaofei/article/details/79940958?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167428506016800188540195%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167428506016800188540195&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-3-79940958-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=mysql%E5%85%A8%E6%96%87%E7%B4%A2%E5%BC%95&spm=1018.2226.3001.4187) 

     MySQL 5.6 以前的版本，只有 MyISAM 存储引擎支持全文索引；

     MySQL 5.6 及以后的版本，MyISAM 和 InnoDB 存储引擎均支持全文索引;

     只有字段的数据类型为 char、varchar、text 及其系列才可以建全文索引。

     最小搜索长度和最大搜索长度


### 锁机制

1. 表锁
   1. 共享锁
   2. 排它锁
   3. 意向锁
   
      [mysql的共享锁(S)、排他锁(X)、意向共享锁(IS)、意向排他锁(IX)的关系](https://blog.csdn.net/u010841296/article/details/87909468) 
   
      为了防止表级别上的请求冲突
   
      **意向共享锁**（intention shared lock, IS）：事务有意向对表中的某些行加**共享锁**（S锁）
   
      **意向排他锁**（intention exclusive lock, IX）：事务有意向对表中的某些行加**排他锁**（X锁）
   
      即：意向锁是有数据引擎自己维护的，用户无法手动操作意向锁，在为数据行加共享 / 排他锁之前，InooDB 会先获取该数据行所在在数据表的对应意向锁。
   
      意向共享锁、意向排他锁之间不互斥，但是于普通的共享/排他锁互斥（表级锁，不与行级锁互斥），因为不与行级锁互斥，所以并不影响并发
   4. MDL锁
2. 行锁
   1. 共享锁
   2. 排它锁
3. 区间锁
   1. 间隙锁
   2. 临键锁

### 索引类型区别?

为什么不用Btree？B+的结构？

为什么不用skiplist？Redis什么结构采用Skiplist？为什么不用B+？

为什么不用hash？

为什么不用红黑树？红黑树怎样的结构？旋转是在做什么？

### 磁盘预读机制

磁盘缓冲区用途?

MRR参数作用?

### 索引优化

1. 最左匹配，[深入浅析Mysql联合索引原理 之 最左匹配原则](https://blog.csdn.net/qq_27559331/article/details/89632566?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167146375316782412577892%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=167146375316782412577892&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~pc_rank_34-10-89632566-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=MySQL%20%E7%B4%A2%E5%BC%95%E7%9A%84%E6%9C%80%E5%B7%A6%E5%8E%9F%E5%88%99&spm=1018.2226.3001.4187)，在mysql建立联合索引时会遵循最左前缀匹配的原则，即最左优先，在检索数据时从联合索引的最左边开始匹配，a/b/c索引，`WHRER b = 1 AND a=1`可以命中索引，查询优化器会自己调整顺序
2. 优化回表
   - [索引覆盖](https://blog.csdn.net/Aplumage/article/details/117015144?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167422740116800188593542%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167422740116800188593542&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_click~default-1-117015144-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E7%B4%A2%E5%BC%95%E8%A6%86%E7%9B%96&spm=1018.2226.3001.4187)，必须要存储索引的列值，而哈希索引、空间索引和全文索引等都不存储索引列值，所以MySQL只能使用B-Tree索引做覆盖索引
   - [索引下推](https://blog.csdn.net/nizhongli37/article/details/114976587?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167422838816782428663420%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167422838816782428663420&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-114976587-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E7%B4%A2%E5%BC%95%E4%B8%8B%E6%8E%A8&spm=1018.2226.3001.4187)，MySQL5.6添加的，在数据库检索数据过程中为减少回表次数而做的优化
3. 避免全表扫几种方式 ?同样的条件为什么偶尔命中偶尔不命中索引?哪些情况会导致索引失效?

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
