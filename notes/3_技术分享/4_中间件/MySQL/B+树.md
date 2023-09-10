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
