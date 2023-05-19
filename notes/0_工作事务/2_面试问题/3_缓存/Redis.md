## 分布式锁

#### Redis与Zookeeper

[【redis】redis和zookeeper分布式锁的区别(优点、缺点)](https://blog.csdn.net/m0_45406092/article/details/118185561) 

redis（[AP](https://gudaoxuri.gitbook.io/microservices-architecture/wei-fu-wu-hua-zhi-ji-shu-jia-gou/cap)）和zookeeper（[CP](https://gudaoxuri.gitbook.io/microservices-architecture/wei-fu-wu-hua-zhi-ji-shu-jia-gou/cap)）分布式锁的区别，关键就在于高可用性和强一致性的选择，redis的性能高于zk太多了，可在一致性上又远远不如zk 

#### 高可用

[redis 系列之——高可用（主从、哨兵、集群）](https://xie.infoq.cn/article/6c3500c66c3cdee3d72b88780)

主从模式：master 节点挂掉后，需要手动指定新的 master，可用性不高，基本不用。

哨兵模式：master 节点挂掉后，哨兵进程会主动选举新的 master，可用性高，但是每个节点存储的数据是一样的，浪费内存空间。数据量不是很多，集群规模不是很大，需要自动容错容灾的时候使用。

集群模式：数据量比较大，QPS 要求较高的时候使用。 Redis Cluster 是 Redis 3.0 以后才正式推出，时间较晚，目前能证明在大规模生产环境下成功的案例还不是很多，需要时间检验。

#### Redlock

[Redlock（redis分布式锁）原理分析](https://www.cnblogs.com/rgcLOVEyaya/p/RGC_LOVE_YAYA_1003days.html) 

[RedLock: 看完这篇文章后请不要有任何疑惑了](https://heapdump.cn/article/2410537) 

[我用了上万字，走了一遍Redis实现分布式锁的坎坷之路，从单机到主从再到多实例，原来会发生这么多的问题](https://blog.csdn.net/qq_33591903/article/details/119920411) 

单节点实现：setnx expire + lua，根据需求设置redis key 值，value使用uuid可以在释放锁时做校验防止被他人释放锁

多节点实现：客户端依次对多个实例请求加锁，只要一半以上（不包含一半）的节点成功，则视为加锁成功，客户端随后可以执行临界代码。但是在解锁的时候，需要对所有的实例进行解锁。

#### Redisson

[分布式锁中的王者方案 - Redisson](https://xie.infoq.cn/article/d8e897f768eb1a358a0fd6300) 

## 高可用

#### 集群方案

1. 结构

   - cluster集群
   - proxy集群

2. 热点数据倾斜

   - [什么？Redis 怎么会数据倾斜了](https://juejin.cn/post/7171814667235360776) 
   - 数据量倾斜：当某个实例上出现热点 key，会导致其访问非常频繁。
     - BIg Key
     - Slot 分配不均匀
     - Hash Tag
   - 数据访问倾斜：在默写情况下，当实例上的数据不是均匀分布的，这就会导致某些实例上会有很多数据。
     - 热点数据多副本

3. 雪崩/击穿/穿透

   - [Redis 缓存击穿（失效）、缓存穿透、缓存雪崩怎么解决？](https://www.51cto.com/article/703396.html) 

   - 雪崩

     缓存雪崩指的是大量的请求无法在 Redis 缓存系统中处理，请求全部打到数据库，导致数据库压力激增，甚至宕机

     解决方案：过期时间添加随机值；接口限流；

   - 击穿

     高并发流量，访问的这个数据是热点数据，请求的数据在 DB 中存在，但是 Redis 存的那一份已经过期，后端需要从 DB 从加载数据并写到 Redis，可能会把 DB 压垮，导致服务不可用

     解决方案：不设置过期时间或设置随机值；预热；获取分布式锁，获取锁成功才执行数据库查询和写数据到缓存的操作

   - 穿透

     意味着有特殊请求在查询一个不存在的数据，即数据不存在 Redis 也不存在于数据库。导致每次请求都会穿透到数据库，缓存成了摆设，对数据库产生很大压力从而影响正常服务。

     解决方法：

     ​	缓存空值：当请求的数据不存在 Redis 也不存在数据库的时候，设置一个缺省值(比如：None)。当后续再次进行查询则直接返回空值或者缺省值。

     ​	布隆过滤器：在数据写入数据库的同时将这个 ID 同步到到布隆过滤器中，当请求的 id 不存在布隆过滤器中则说明该请求查询的数据一定没有在数据库中保存，就不要去数据库查询了。

4. 主从同步过程

5. 扩容数据一致性

#### 持久化方式

[Redis专题：万字长文详解持久化原理](https://segmentfault.com/a/1190000039208726) 

RDB快照：RDB持久化方案是按照指定时间间隔对你的数据集生成的时间点快照（point-to-time snapshot）。它以紧缩的二进制文件保存Redis数据库某一时刻所有数据对象的内存快照，可用于Redis的数据备份、转移与恢复。

AOF：AOF是Append Only File的缩写，它是Redis的完全持久化策略，从1.1版本开始支持；这里的file存储的是引起Redis数据修改的命令集合（比如：set/hset/del等），这些集合按照Redis Server的处理顺序追加到文件中。当重启Redis时，Redis就可以从头读取AOF中的指令并重放，进而恢复关闭前的数据状态。

#### 哨兵模式

[通俗易懂讲解Redis的哨兵模式](https://www.51cto.com/article/712529.html) 

[Redis专题：深入解读哨兵模式](https://zhuanlan.zhihu.com/p/354720754) 

哨兵是Redis的一种工作模式，以监控节点状态及执行故障转移为主要工作，哨兵总是以固定的频率去发现节点、故障检测，然后在检测到主节点故障时以安全的方式执行故障转移，确保集群的高可用性。

#### LRU淘汰策略

缓存淘汰算法--LRU算法

LRU（Least recently used，最近最少使用）算法根据数据的历史访问记录来进行淘汰数据，其核心思想是“如果数据最近被访问过，那么将来被访问的几率也更高”。

## 高性能

[Redis为什么这么快？](https://blog.csdn.net/qq_35190492/article/details/122293594) 

[redis为什么快？](https://blog.csdn.net/weixin_43001336/article/details/122773260) 

1. 高效的数据结构

   [图解 Redis 数据结构](https://mp.weixin.qq.com/s?__biz=MzAwNDA2OTM1Ng==&mid=2453155662&idx=1&sn=0037ba5cbc057d5f07d1b318ccf72b6a&scene=21#wechat_redirect) 

   [Redis—5种基本数据结构](https://mp.weixin.qq.com/s?__biz=MzAwNDA2OTM1Ng==&mid=2453141673&idx=2&sn=199d99d7ee267b7562d964356d678eed&scene=21#wechat_redirect) 

   [Redis—跳跃表](https://mp.weixin.qq.com/s?__biz=MzAwNDA2OTM1Ng==&mid=2453141687&idx=2&sn=23936a54d263d56cf26972a00a287feb&scene=21#wechat_redirect) 
2. 基于内存，相比于磁盘要快
3. 单线程操作，省去多线程时CPU上下文会切换的时间，也不用考虑锁的问题（单线程指的是网络请求模块使用一个线程）
4. Redis 中要使用 I/O 多路复用这种技术
5. Redis的自定义协议
6. Redis基于Reactor模式开发了自己的网络事件处理器，称之为文件事件处理器(File Event Hanlder)。文件事件处理器由Socket、IO多路复用程序、文件事件分派器(dispather)，事件处理器(handler)四部分组成。

## 其他

1. 延迟队列的实现

2. pipline批量执行

3. scan避免阻塞

   [Redis中Scan命令踩坑记 ](https://segmentfault.com/a/1190000022299817) 

   [Redis Scan 原理解析与踩坑](https://www.lixueduan.com/posts/redis/redis-scan/) 

   

   