# docker network

[docker network详解、教程](https://blog.csdn.net/wangyue23com/article/details/111172076) 

[Docker网络（host、bridge、none）详细介绍](https://blog.csdn.net/heian_99/article/details/104914945?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167301096316800211599992%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167301096316800211599992&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-104914945-null-null.142^v70^one_line,201^v4^add_ask&utm_term=docker%20network%20host&spm=1018.2226.3001.4187) 

[Docker学习：容器五种(3+2)网络模式 | bridge模式 | host模式 | none模式 | container 模式 | 自定义网络模式详解](https://blog.csdn.net/succing/article/details/122433770?ops_request_misc=&request_id=&biz_id=102&utm_term=docker%20%E5%AE%B9%E5%99%A8%E8%AE%BF%E9%97%AEhost%E7%BD%91%E7%BB%9C&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-9-122433770.142^v70^one_line,201^v4^add_ask&spm=1018.2226.3001.4187) 

```bash
# 创建
docker network create tingnichui
# 加入nginx到mynet网络
docker network connect tingnichui nginx
#将nginx移除mynet局域网络
docker network disconnect tingnichui nginx
```