## `top`命令查看服务占用内存情况

## 查看服务进程id

```
ps -ef | grep 服务名 
ps -aux | grep 服务名
```

## jstat命令

> 用jstat -gcutil 20886 1000 10命令，就是用jstat工具，对指定java进程（20886就是进程id，通过ps -aux | grep java命令就能找到），按照指定间隔，看一下统计信息，这里会每隔一段时间显示一下，包括新生代的两个S0、s1区、Eden区，以及老年代的内存使用率，还有young gc以及full gc的次数。
> 使用 jstat -gcutil 8968 500 5 表示每500毫秒打印一次Java堆状况（各个区的容量、使用容量、gc时间等信息），打印5次

```shell
jstat -gcutil 进程id 1000 10
```

![image-20240211172726358](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240211172726358.png)

```
S0 S1 E O M CCS YGC YGCT FGC FGCT GCT
0.00 0.00 100.00 99.94 90.56 87.86 875 9.307 3223 5313.139 5322.446

S0：幸存1区当前使用比例
S1：幸存2区当前使用比例
E：Eden Space（伊甸园）区使用比例
O：Old Gen（老年代）使用比例
M：元数据区使用比例
CCS：压缩使用比例
YGC：年轻代垃圾回收次数
FGC：老年代垃圾回收次数
FGCT：老年代垃圾回收消耗时间
GCT：垃圾回收消耗总时间
```

## jmap命令

> jmap -histo pid可以打印出当前堆中所有每个类的实例数量和内存占用

```
jmap -histo 进程id | head -n 15
```

![image-20240211172927310](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240211172927310.png)

> 把当前堆内存的快照转储到dumpfile_jmap.hprof文件中

```
jmap -dump:format=b,file=oom.hprof 进程id
```

## jvm命令

> 设置出现oom时自动导出一份快照

```shell
java -Xms15m -Xmx15m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/heapdump.hprof -jar web-api-0.0.1-SNAPSHOT.jar
```

> 打印gc日志

让线上系统定期打出来gc的日志：
-XX:+PrintGCTimeStamps
-XX:+PrintGCDeatils
-Xloggc:<filename>

参考文章

1. [线上OOM排查步骤总结](https://www.cnblogs.com/jelly12345/p/15007745.html)