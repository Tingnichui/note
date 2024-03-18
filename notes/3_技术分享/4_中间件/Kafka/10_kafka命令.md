进入容器

```bash
docker exec -it kafka bash
```

```bash
cd /opt/bitnami/kafka
```

查看消费组

```bash
# kafka未设置sasl
./bin/kafka-consumer-groups.sh --bootstrap-server 192.168.139.102:9092 --list
# kafka设置sasl
./bin/kafka-topics.sh --list --bootstrap-server 10.49.177.25:9092 --producer-property security.protocol=SASL_PLAINTEXT --producer-property sasl.mechanism=PLAIN --producer-property sasl.jaas.config='org.apache.kafka.common.security.scram.ScramLoginModule required username="user" password="password";'
```

创建topic

```bash
# 新版本使用这个命令
bin/kafka-topics.sh --bootstrap-server 192.168.139.102:9092 --create --partitions 1 --replication-factor 1 --topic TEST
# 旧版本使用这个命令
bin/kafka-topics.sh -zookeeper 192.168.139.102:2181 --create --partitions 5 --replication-factor 1 --topic TEST
```

手动发送消息

```bash
# 给TEST发送消息
bin/kafka-console-producer.sh --broker-list 192.168.139.102:9092 --topic TEST
```

查询topic消息

```bash
# –time-1 表示要获取指定 topic 所有分区当前的最大位移（历史总消息数），–time-2 表示获取当前最早位移（被消费的消息数），两个命令的输出结果相减便可得到所有分区当前的消息总数。

bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list 192.168.139.102:9092 --topic TEST --time -1

bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list 192.168.139.102:9092 --topic TEST --time -2
```



```shell
bin/kafka-console-producer.sh --broker-list 10.49.177.25:9092 --topic alarmForNational --producer-property security.protocol=SASL_PLAINTEXT --producer-property sasl.mechanism=PLAIN --producer-property sasl.jaas.config='org.apache.kafka.common.security.scram.ScramLoginModule required username="user" password="password";'
```

查看topic
bin/kafka-topics.sh --list --zookeeper 192.168.139.102:2181
bin/kafka-topics.sh --list --bootstrap-server 192.168.139.102:9092

删除topic
bin/kafka-topics.sh --delete --zookeeper 192.168.139.102:2181  --topic test
bin/kafka-topics.sh --delete --bootstrap-server 192.168.139.102:9092  --topic test

查询topic消息






参考文章

1. [悄悄掌握 Kafka 常用命令，再也不用全网搜索了（建议收藏）](https://cloud.tencent.com/developer/article/1761560)