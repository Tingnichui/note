下载地址

https://eclipse.dev/mat/downloads.php

使用教程

https://juejin.cn/post/7030664794843660302

https://cloud.tencent.com/developer/article/1828595

### 4.2.1 outgoing reference与incoming reference

当右键单击任何对象时，将看到下拉菜单，如果选择“ListObjects”菜单项，可以查看对象的outgoing reference（对象的引出）和incoming reference（对象的引入）。

![在这里插入图片描述](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/5a1bb054d903470b9568f37dd6bf5c69~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

Incomming Reference 指的是引用当前对象的对象，Outgoing Reference 指的是当前对象引用的对象。对象的incomming reference 保证对象处于 alive 从而免于被垃圾回收掉 ；Outgoing reference 则展示了对象内部的具体内容，有助于我们分析对象的属性 。

我们看看第一个最大的char[]的Incomming Reference：

## 4.3 Dominator Tree支配树

列出Heap Dump中处于活跃状态中的最大的几个对象，默认按 retained size进行排序，因此很容易找到占用内存最多的对象。

排在第一的最大的对象就是占用内存最多的对象，它在树中的子节点都是被该对象直接或间接引用的对象（这意味着当这个对象被回收的时候它的子节点对象也会被回收）。

一般定位OOM的时候，都是直接查看支配树的最大的对象，我们的Heap Dump中的支配树中，很明显ArrayList占用了最大的内存，里面的元素就是一个个拼接的UUID字符串，就是因为这个原因导致了OOM