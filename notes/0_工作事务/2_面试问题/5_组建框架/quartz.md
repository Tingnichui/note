### 核心元素

Quartz核心要素有Scheduler、Trigger、Job、JobDetail，其中trigger和job、jobDetail为元数据，而Scheduler为实际进行调度的控制器。

- Trigger - 触发器 - 你什么时候去做？

Trigger用于定义调度任务的时间规则，在Quartz中主要有四种类型的Trigger：SimpleTrigger、CronTrigger、DataIntervalTrigger和NthIncludedTrigger。

- Job&Jodetail - 任务 - 你要做什么事？

Quartz将任务分为Job、JobDetail两部分，其中Job用来定义任务的执行逻辑，而JobDetail用来描述Job的定义（例如Job接口的实现类以及其他相关的静态信息）。对Quartz而言，主要有两种类型的Job，StateLessJob、StateFulJob

- Scheduler - 任务调度 - 你什么时候需要去做什么事？

实际执行调度逻辑的控制器，Quartz提供了DirectSchedulerFactory和StdSchedulerFactory等工厂类，用于支持Scheduler相关对象的产生

## 参考文章

[Quartz原理解密](https://juejin.cn/post/6844903760624353293) 