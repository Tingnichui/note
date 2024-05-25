## innodb_buffer_pool_size

### 概念

- **数据缓存**
  InnoDB数据页面
- **索引缓存**
  索引数据
- **缓冲数据**
  脏页（在中修改尚未刷新(写入)到磁盘的数据）
- **内部结构**
  如自适应哈希索引，行锁等。

**查看当前innodb_buffer_pool_size大小**

```
SELECT @@innodb_buffer_pool_size/1024/1024/1024; #字节转为G
```



> 用于缓存索引和数据的内存大小，这个当然是越多越好， 数据读写在内存中非常快， 减少了对磁盘的读写。 当数据提交或满足检查点条件后才一次性将内存数据刷新到磁盘中。然而内存还有操作系统或数据库其他进程使用， 根据经验，推荐设置innodb-buffer-pool-size为服务器总可用内存的75%。 若设置不当， 内存使用可能浪费或者使用过多。 对于繁忙的服务器， buffer pool 将划分为多个实例以提高系统并发性， 减少线程间读写缓存的争用。buffer pool 的大小首先受 innodb_buffer_pool_instances 影响， 当然影响较小。

### 检查

```sql
show status like 'Innodb_buffer_pool_read%';
```

![image-20240525142806811](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240525142806811.png)

**innodb_buffer_pool_reads ：**表示InnoDB缓冲池无法满足的请求数。需要从磁盘中读取。

**innodb_buffer_pool_read_requests：**表示从内存中读取逻辑的请求数。

**计算方式命中率：**`Performance = (Innodb_buffer_pool_read_requests-Innodb_buffer_pool_reads)/Innodb_buffer_pool_read_requests * 100%`

（531650410428 - 62005626 ）/ 531650410428 * 100 = 99.98833714320843

命中率越高越好

### 调整

> 建议设置物理内存的**50%-75%**

**Innodb_buffer_pool_pages_data**：Innodb buffer pool缓存池中包含数据的页的数目，包括脏页。单位是page

```
show global status like 'Innodb_buffer_pool_pages_data';# 483914
```

**Innodb_buffer_pool_pages_total**：innodb buffer pool的页总数目。单位是page。

```
show global status like 'Innodb_buffer_pool_pages_total';# 786432
```

**计算：**`val = Innodb_buffer_pool_pages_data / Innodb_buffer_pool_pages_total * 100%`

483914 / 786432 * 100 = 61.53284708658854

val > 95% 则增加 innodb_buffer_pool_size， 建议使用物理内存的 75%
val < 95% 则减少 innodb_buffer_pool_size， 
建议设置大小为： Innodb_buffer_pool_pages_data * Innodb_page_size * 1.05 / (1024*1024*1024) 这个计算不怎么准

**在线调整innodb_buffer_pool_size大小：**这里设置的是 12G = 12 * 1024 * 1024 * 1024

```
SET GLOBAL innodb_buffer_pool_size = 12884901888；
```

### 参考文章

1. [mysql参数之innodb_buffer_pool_size大小设置 - Ruthless - 博客园](https://www.cnblogs.com/linjiqin/p/11430698.html)
2. [Mysql优化之innodb_buffer_pool_size](https://juejin.cn/post/7159470754370125837)

