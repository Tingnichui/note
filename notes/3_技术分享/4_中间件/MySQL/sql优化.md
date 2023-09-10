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

