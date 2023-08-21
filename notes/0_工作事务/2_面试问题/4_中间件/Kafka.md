消息队列通信的两种模式

1. 点对点模式

   点对点模式通常是基于拉取或者轮询的消息传送模型，这个模型的特点是发送到队列的消息被一个且只有一个消费者进行处理。生产者将消息放入消息队列后，由消费者主动的去拉取消息进行消费。点对点模型的的优点是消费者拉取消息的频率可以由自己控制。但是消息队列是否有消息需要消费，在消费者端无法感知，所以在消费者端需要额外的线程去监控。

2.  发布订阅模式

   发布订阅模式是一个基于消息送的消息传送模型，该模型可以有多种不同的订阅者。生产者将消息放入消息队列后，队列会将消息推送给订阅过该类消息的消费者。由于是消费者被动接收推送，所以无需感知消息队列是否有待消费的消息！但是consumer1、consumer2、consumer3由于机器性能不一样，所以处理消息的能力也会不一样，但消息队列却无法感知消费者消费的速度！所以推送的速度成了发布订阅模模式的一个问题！假设三个消费者处理速度分别是8M/s、5M/s、2M/s，如果队列推送的速度为5M/s，则consumer3无法承受！如果队列推送的速度为2M/s，则consumer1、consumer2会出现资源的极大浪费！



## 基础架构及术语

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215237.png)

- **Producer：**消息和数据的生产者，主要负责生产`Push`消息到指定Broker的Topic中。
- **kafka cluster**：
  - **Broker：**Kafka节点就是被称为Broker，Broker主要负责创建Topic，存储Producer所发布的消息，记录消息处理的过程，现是将消息保存到内存中，然后持久化到磁盘。每个服务器上有一个或多个kafka的实例，我们姑且认为每个broker对应一台服务器。每个kafka集群内的broker都有一个**不重复**的编号。
  - **Topic：**同一个Topic的消息可以分布在一个或多个Broker上，一个Topic包含一个或者多个Partition分区，数据被存储在多个Partition中。
  - **Partition：**分区；在这里被称为Topic物理上的分组，一个Topic在Broker中被分为1个或者多个Partition，也可以说为每个Topic包含一个或多个Partition，(一般为kafka节. 点数CPU的总核心数量)分区在创建Topic的时候可以指定。分区才是真正存储数据的单元。Topic的分区，每个topic可以有多个分区，分区的作用是做负载，提高kafka的吞吐量。同一个topic在不同的分区的数据是不重复的，partition的表现形式就是一个一个的文件夹！
  - **replication-factor：**复制因子；这个名词在上图中从未出现，在我们下一章节创建Topic时会指定该选项，意思为创建当前的Topic是否需要副本，如果在创建Topic时将此值设置为1的话，代表整个Topic在Kafka中只有一份，该复制因子数量建议与Broker节点数量一致。:每一个分区都有多个副本，副本的作用是做备胎。当主分区（Leader）故障的时候会选择一个备胎（Follower）上位，成为Leader。在kafka中默认副本的最大数量是10个，且副本的数量不能大于Broker的数量，follower和leader绝对是在不同的机器，同一机器对同一个分区也只可能存放一个副本（包括自己）。
  - **Message**：每一条发送的消息主体。
- **Consumer：**消息和数据的消费者，主要负责主动到已订阅的Topic中拉取消息并消费，为什么Consumer不能像Producer一样的由Broker去push数据呢？因为Broker不知道Consumer能够消费多少，如果push消息数据量过多，会造成消息阻塞，而由Consumer去主动pull数据的话，Consumer可以根据自己的处理情况去pull消息数据，消费完多少消息再次去取。这样就不会造成Consumer本身已经拿到的数据成为阻塞状态。
- **Consumer Group**：我们可以将多个消费组组成一个消费者组，在kafka的设计中同一个分区的数据只能被消费者组中的某一个消费者消费。同一个消费者组的消费者可以消费同一个topic的不同分区的数据，这也是为了提高kafka的吞吐量！
- **ZooKeeper：**ZooKeeper负责维护整个Kafka集群的状态，存储Kafka各个节点的信息及状态，实现Kafka集群的高可用，协调Kafka的工作内容。

## 工作流程分析

### 发送数据

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215252.png)

消息写入leader后，follower是主动的去leader进行同步的！producer采用push模式将数据发布到broker，每条消息追加到分区中，顺序写入磁盘，所以保证**同一分区**内的数据是有序的！写入示意图如下：

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215312.png)

如果某个topic有多个partition，producer又怎么知道该将数据发往哪个partition呢？kafka中有几个原则：

1. partition在写入的时候可以指定需要写入的partition，如果有指定，则写入对应的partition。
2. 如果没有指定partition，但是设置了数据的key，则会根据key的值hash出一个partition。
3. 如果既没指定partition，又没有设置key，则会轮询选出一个partition。

ACK应答机制保证消息不丢失，在生产者向队列写入数据的时候可以设置参数来确定是否确认kafka接收到数据：

- 0代表producer往集群发送数据不需要等到集群的返回，不确保消息发送成功。安全性最低但是效率最高。
- 1代表producer往集群发送数据只要leader应答就可以发送下一条，只确保leader发送成功。
- all代表producer往集群发送数据需要所有的follower都完成从leader的同步才会发送下一条，确保leader发送成功和所有的副本都完成备份。安全性最高，但是效率最低。

如果往不存在的topic写数据，能不能写入成功呢？kafka会自动创建topic，分区和副本的数量根据默认配置都是1。

### 保存数据

**Partition 结构**

Partition在服务器上的表现形式就是一个一个的文件夹，每个partition的文件夹下面会有多组segment文件，每组segment文件又包含.index文件、.log文件、.timeindex文件（早期版本中没有）三个文件， log文件就实际是存储message的地方，而index和timeindex文件为索引文件，用于检索消息。

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215337.png)

这个partition有三组segment文件，每个log文件的大小是一样的，但是存储的message数量是不一定相等的（每条的message大小不一致）。文件的命名是以该segment最小offset来命名的，如000.index存储offset为0~368795的消息，kafka就是利用分段+索引的方式来解决查找效率的问题

**Message结构**

log文件就实际是存储message的地方，我们在producer往kafka写入的也是一条一条的message，那存储在log中的message是什么样子的呢？消息主要包含消息体、消息大小、offset、压缩类型……等等！我们重点需要知道的是下面三个：
　　1、 offset：offset是一个占8byte的有序id号，它可以唯一确定每条消息在parition内的位置！
　　2、 消息大小：消息大小占用4byte，用于描述消息的大小。
　　3、 消息体：消息体存放的是实际的消息数据（被压缩过），占用的空间根据具体的消息而不一样。

**存储策略**

无论消息是否被消费，kafka都会保存所有的消息。那对于旧数据有什么删除策略呢？

- 基于时间，默认配置是168小时（7天）。
- 基于大小，默认配置是1073741824。

需要注意的是，kafka读取特定消息的时间复杂度是O(1)，所以这里删除过期的文件并不会提高kafka的性能

### 消费数据

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215326.png)

​		消费者在拉取消息的时候也是**找leader**去拉取。

​		多个消费者可以组成一个消费者组（consumer group），每个消费者组都有一个组id！同一个消费组者的消费者可以消费同一topic下不同分区的数据，但是不会组内多个消费者消费同一分区的数据

​		消费者组内的消费者小于partition数量的，会出现某个消费者消费多个partition数据的情况，消费的速度也就不及只处理一个partition的消费者的处理速度！如果是消费者组的消费者多于partition的数量，那会不会出现多个消费者消费同一个partition的数据呢？上面已经提到过不会出现这种情况！多出来的消费者不消费任何partition的数据。所以在实际的应用中，建议**消费者组的consumer的数量与partition的数量一致**！

​		查找消息的时候是怎么利用segment+offset配合查找的呢？假如现在需要查找一个offset为368801的message是什么样的过程呢？我们先看看下面的图：

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/WeChat Screenshot_20190325215338.png)

1. 先找到offset的368801message所在的segment文件（利用二分法查找），这里找到的就是在第二个segment文件。
2. 打开找到的segment中的.index文件（也就是368796.index文件，该文件起始偏移量为368796+1，我们要查找的offset为368801的message在该index内的偏移量为368796+5=368801，所以这里要查找的**相对offset**为5）。由于该文件采用的是稀疏索引的方式存储着相对offset及对应message物理偏移量的关系，所以直接找相对offset为5的索引找不到，这里同样利用二分法查找相对offset小于或者等于指定的相对offset的索引条目中最大的那个相对offset，所以找到的是相对offset为4的这个索引。
3. 根据找到的相对offset为4的索引确定message存储的物理偏移位置为256。打开数据文件，从位置为256的那个地方开始顺序扫描直到找到offset为368801的那条Message。

​		这套机制是建立在offset为有序的基础上，利用**segment**+**有序offset**+**稀疏索引**+**二分查找**+**顺序查找**等多种手段来高效的查找数据！至此，消费者就能拿到需要处理的数据进行处理了。那每个消费者又是怎么记录自己消费的位置呢？在早期的版本中，消费者将消费到的offset维护zookeeper中，consumer每间隔一段时间上报一次，这里容易导致重复消费，且性能不好！在新的版本中消费者消费到的offset已经直接维护在kafk集群的__consumer_offsets这个topic中！





### 主题和日志

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/v2-c709f26c7794161b7974a40edfe1a2a3_1440w.webp)

主题和日志官方被称为是`Topic and log`。 Topic是记录发布到的类别或者订阅源的名称，Kafka的Topic总是多用户的；也就是说，一个Topic可以有零个、一个或者多个消费者订阅写入它的数据。  每个Topic Kafka集群都为一个Partition分区日志。

每个Partition分区都是一个有序的记录序列(不可变),如果有新的日志会按顺序结构化添加到末尾，分区中的记录每个都按顺序的分配一个ID号，称之为偏移量，在整个Partition中具有唯一性。如上图所示，有Partition、Partition1、Partition2，其中日志写入的顺序从Old到New，ID号从0-12等。

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/v2-2fd3e8b1bb90e366f4c10230e9c0ba33_1440w.webp)

实际上，以消费者为单位地保留的唯一元数据是消费者在日志中的偏移或位置。这个偏移量由消费者控制的：消费者通常会在读取记录时线性地推进偏移量，但事实上，由于消费者的位置时由消费者控制的，所以它可以按照自己喜欢的任何顺序进行消费记录。例如，消费者可以重置之前的偏移量来处理之前的数据，或者直接从最新的偏移量开始消费。 这些功能的组合意味着Kafka消费者非常的不值一提，他们可以很随便，即使这样，对集群或者其他消费者没有太大影响。例如：可以使用命令工具来“tail”任何Topic的内容，而不会更改任何现有使用者所使用的内容。

日志中分区有几个用途。首先，他们允许日志的大小超出适合单台服务器的大小，每个单独的分区必须适合托管它的服务器，但是一个主题可能有许多分区，因此它可以处理任意数量的数据，其次，他们作为并行的单位-更多的是在一点上。

### **Distribution(分布)**

日志Partition分区分布在Kafka集群中的服务器上，每台服务器都处理数据并请求共享分区。为了实现容错，每个Partition分区被复制到多个可配置的Kafka集群中的服务器上。

**名词介绍：**

`leader`：领导者

`followers`：追随者

每个Partition分区都有一个`leader`(领导者)服务器，是每个Partition分区，假如我们的Partition1分区分别被复制到了三台服务器上，其中第二台为这个Partition分区的领导者，其它两台服务器都会成为这个Partition的`followers`(追随者)。其中Partition分片的`leader`(领导者)处理该Partition分区的所有读和写请求，而`follower`(追随者)被动地复制`leader`(领导者)所发生的改变，如果该Partition分片的领导者发生了故障等，两个`follower`(追随者)中的其中一台服务器将自动成为新的`leader`领导者。每台服务器都充当一些分区的`leader`(领导者)和一些分区的`follower`(追随者)，因此集群内的负载非常平衡。

> 注意：上面讲的`leader`和`follower`仅仅是每个Partition分区的领导者和追随者，并不是我们之前学习到的整个集群的主节点和备节点，希望大家不要混淆。

### **Geo-Replication(地域复制)**

Kafka Mirrormaker为集群提供地域复制支持，使用MirrorMaker，可以跨多个机房或云端来复制数据，可以在主动/被动方案中使用它进行备份和恢复；在主动方案中，可以使数据更接近用户，或支持数据位置要求。

### **Producers(生产者)**

生产者将数据发布到他们选择的Topic，生产者负责选择分配给Topic中的哪个分区的记录。这可以通过循环方式来完成，只是为了负载均衡，或者可以根据一些语义分区函数(比如基于记录中的某个键)来完成。

### **Consumers(消费者)**

![image-20230821192136571](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230821192136571.png)



**名词介绍**

Consumers：消费者

Consumers Group：消费者组

Consumers Group name：消费者组名

`Consumers`使用`Consumers Group name`标记自己，并且发布到Topic的每个记录被传递到每个订阅`Consumers Group`中的一个Consumers实例，Consumers实例可以在单独的进程中，也可以在不同的机器，如果所有Consumers实例具有相同的`Consumers Group`，则记录将有效地在Consumers上进行负载均衡。

如果所有Consumers实例在不同的`Consumers Group`中，则每个记录将广播到所有Consumers进程中。

两个Kafka Cluster，托管了四个Partition(分区)，从P0-P3，包含两个`Consumers Group`分别是`Consumer Group A`和`Consumer Group B`，`Consumners Group A`有两个Consumers实例，B有四个Consumers实例。也就是消费者A组有两个消费者，B组有四个消费者。 然后，更常见的是，我们发现Topic有少量的`Consumers Group`，每个消费者对应一个用户组，每个组有许多消费者实例组成，用于可伸缩和容错，这只不过是发布/订阅语义，其中订阅者是一组消费者，而不是单个进程。

在Kfaka中实现消费者的方式是通过在消费者实例上划分日志中的Partition分区，以便每个实例在任何时间点都是分配的“相同份额”，维护消费者组成功资格的过程由Kafka动态协议实现，如果新的消费者实例加入该消费者组，新消费者实例将从该组的其它成员手里接管一些分区；如果消费者实例故障，其分区将分发给其余消费者实例。

Kafka仅提供分区内记录的总顺序，而不是Topic中不同分区之间的记录。对于大多数应用程序而言，按分区排序和按键分许数据的能力已经足够，但是如果你需要记录总顺序，则可以使用只有一个分区的Topic来实现，尽管这意味着每个消费者组只有一个消费者进程。

### **Consumer Group**

我们开始处有讲到消息系统分类：P-T-P模式和发布/订阅模式，也有说到我们的Kafka采用的就是发布订阅模式，即一个消息产生者产生消息到Topic中，所有的消费者都可以消费到该条消息，采用异步模型；而P-T-P则是一个消息生产者生产的消息发不到Queue中，只能被一个消息消费者所消费，采用同步模型 其实发布订阅模式也可以实现P-T-P的模式，即将多个消费者加入一个消费者组中，例如有三个消费者组，每个组中有3个消息消费者实例，也就是共有9个消费者实例，如果当Topic中有消息要接收的时候，三个消费者组都会去接收消息，但是每个人都接收一条消息，然后消费者组再将这条消息发送给本组内的一个消费者实例，而不是所有消费者实例，到最后也就是只有三个消费者实例得到了这条消息，当然我们也可以将这些消费者只加入一个消费者组，这样就只有一个消费者能够获得到消息了。

### **Guarantees(担保)**

在高级别的Kafka中提供了以下保证：

- 生产者发送到特定Topic分区的消息将按照其发送顺序附加。也就是说，如果一个Producers生产者发送了M1和M2，一般根据顺序来讲，肯定是先发送的M1，随后发送的M2，如果是这样，假如M1的编号为1，M2的编号为2，那么在日志中就会现有M1，随后有M2。
- 消费者实例按照他们存储在日志中的顺序查看记录。
- 对于具有复制因子N的Topic，Kafka最多容忍N-1个服务器故障，则不会丢失任何提交到日志的记录。

## 参考文章

1. [Kafka详解](https://zhuanlan.zhihu.com/p/163836793)

2. ###### [再过半小时，你就能明白kafka的工作原理了](https://www.cnblogs.com/sujing/p/10960832.html)