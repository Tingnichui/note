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