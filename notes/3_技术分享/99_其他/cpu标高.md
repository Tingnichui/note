```
ps -ef | grep lrb-agent
ps p 59278 -L -o pcpu,pid,tid,time,tname,cmd
ps p 59278 -L -o pcpu,pid,tid,time,tname
```

![image-20240321222039743](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222039743.png)

```
printf "%x\n" 59715
jstack -l 59278 | grep e943

```

![image-20240321222300112](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222300112.png)



```
printf "%x\n" 59718
jstack -l 59278 | grep e946
```

![image-20240321222314531](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222314531.png)





![image-20240321222641827](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222641827.png)



```
"lrb_maxwell_consumer_push_msg-0-C-1" #408 prio=5 os_prio=0 tid=0x00007f8214cb7800 nid=0xe943 runnable [0x00007f81b08f7000]
   java.lang.Thread.State: RUNNABLE
	at java.util.stream.AbstractPipeline.wrapSink(AbstractPipeline.java:518)
	at java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:472)
	at java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:708)
	at java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
	at java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:499)
	at org.apache.kafka.clients.consumer.internals.SubscriptionState.fetchablePartitions(SubscriptionState.java:414)
	- locked <0x00000000e934d750> (a org.apache.kafka.clients.consumer.internals.SubscriptionState)
	at org.apache.kafka.clients.consumer.internals.Fetcher.fetchablePartitions(Fetcher.java:1070)
	at org.apache.kafka.clients.consumer.internals.Fetcher.prepareFetchRequests(Fetcher.java:1106)
	at org.apache.kafka.clients.consumer.internals.Fetcher.sendFetches(Fetcher.java:246)
	- locked <0x00000000e9351578> (a org.apache.kafka.clients.consumer.internals.Fetcher)
	at org.apache.kafka.clients.consumer.KafkaConsumer.pollForFetches(KafkaConsumer.java:1296)
	at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1248)
	at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1216)
	at sun.reflect.GeneratedMethodAccessor246.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
	at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:205)
	at com.sun.proxy.$Proxy633.poll(Unknown Source)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.doPoll(KafkaMessageListenerContainer.java:1089)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.pollAndInvoke(KafkaMessageListenerContainer.java:1045)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.run(KafkaMessageListenerContainer.java:970)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at java.lang.Thread.run(Thread.java:750)

   Locked ownable 
```

```
"org.springframework.kafka.KafkaListenerEndpointContainer#0-0-C-1" #411 prio=5 os_prio=0 tid=0x00007f8216c15000 nid=0xe946 runnable [0x00007f81b03f5000]
   java.lang.Thread.State: RUNNABLE
	at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.checkAndGetCoordinator(AbstractCoordinator.java:832)
	- locked <0x00000000e9368b58> (a org.apache.kafka.clients.consumer.internals.ConsumerCoordinator)
	at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.coordinatorUnknown(AbstractCoordinator.java:822)
	at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.ensureCoordinatorReady(AbstractCoordinator.java:226)
	- locked <0x00000000e9368b58> (a org.apache.kafka.clients.consumer.internals.ConsumerCoordinator)
	at org.apache.kafka.clients.consumer.internals.ConsumerCoordinator.poll(ConsumerCoordinator.java:463)
	at org.apache.kafka.clients.consumer.KafkaConsumer.updateAssignmentMetadataIfNeeded(KafkaConsumer.java:1275)
	at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1241)
	at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1216)
	at sun.reflect.GeneratedMethodAccessor246.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
	at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:205)
	at com.sun.proxy.$Proxy633.poll(Unknown Source)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.doPoll(KafkaMessageListenerContainer.java:1089)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.pollAndInvoke(KafkaMessageListenerContainer.java:1045)
	at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.run(KafkaMessageListenerContainer.java:970)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at java.lang.Thread.run(Thread.java:750)

   Locked ownable synchronizers:
	- None
```



![image-20240321224246926](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321224246926.png)