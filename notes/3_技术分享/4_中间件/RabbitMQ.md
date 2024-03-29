### 主要构成

[超详细的RabbitMQ入门，看这篇就够了！](https://developer.aliyun.com/article/769883#slide-15) 

[MQ - RabbitMQ - 架构及工作原理](https://blog.csdn.net/maihilton/article/details/80928661) 

- Broker：消息队列服务进程。此进程包括两个部分：Exchange和Queue。
  - Exchange：消息队列交换机。**按一定的规则将消息路由转发到某个队列**。
    - Direct Exchange：直接匹配,通过Exchange名称+RountingKey来发送与接收消息.
    - Fanout exchange：广播订阅,向所有的消费者发布消息,但是只有消费者将队列绑定到该路由器才能收到消息,忽略Routing Key
    - Topic exchange：主题匹配订阅,这里的主题指的是RoutingKey,RoutingKey可以采用通配符,如:*或#，RoutingKey命名采用.来分隔多个词,只有消息这将队列绑定到该路由器且指定RoutingKey符合匹配规则时才能收到消息;
    - Headers exchange：消息头订阅,消息发布前,为消息定义一个或多个键值对的消息头,然后消费者接收消息同时需要定义类似的键值对请求头:(如:x-mactch=all或者x_match=any)，只有请求头与消息头匹配,才能接收消息,忽略RoutingKey.
  - Queue：消息队列，存储消息的队列。
- Producer：消息生产者。生产方客户端将消息同交换机路由发送到队列中。
- Consumer：消息消费者。消费队列中存储的消息。

### 消息丢失

[解决RabbitMQ消息丢失问题和保证消息可靠性（一）](https://juejin.cn/post/6844903906074427400) 

[《RabbitMQ》 | 消息丢失也就这么回事](https://cloud.tencent.com/developer/article/1896271) 

1. publisher 发送消息到 exchange：publisher-confirm 和 publisher-return
2. exchange 分发到 queue：持久化
3. queue 投递到 customer：当确认消息被消费者消费后就会立即删除

### 重复消费

接口幂等

### 顺序消费



## 参考

1. [消息队列详解：ActiveMQ、RocketMQ、RabbitMQ、Kafka](https://www.dingsky.com/article/20.html)