### 斐讯n1刷openwrt软路由

[《玩转N1盒子1》N1盒子刷最新F大OPENRT软路由固件 保姆级教程](https://www.bilibili.com/video/BV1pS4y1c7GY/?spm_id_from=333.1007.top_right_bar_window_default_collection.content.click&vd_source=6ca7f50b2771122db2bed50a3e9677d3) 此[教程](https://www.wudilad.com/?p=1359)十分详细

大概流程：主路为路由模式，主路由ip192.168.10.2，旁路由设置静态ip为192.168.10.2，dns与网关指向主路由192.168.10.1，关闭dhcp

##### 1.[F大的恩山OP原文地址](https://www.right.com.cn/forum/thread-4076037-1-1.html) 

##### 2.下载固件 

链接：https://pan.baidu.com/s/1kbvtyxpcmniLKN_ziH-kqQ 提取码：jla9

选最新的下就行了，我这里是78+

2024.03.06 84+ 可以使用

##### 3.写盘

下载后的固件解压缩将img文件通过写盘[balenaEtcher](https://www.balena.io/etcher/)写入u盘（斐讯n1挑u盘，最好使用老一点的u盘）

##### 4.u盘插入n1启动（不连接网线）

连接wifi 密码password，登录192.168.1.1，通过晶晨宝盒安装

![image-20221203105210220](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221203105210220.png)

##### 5.修改地址

成功后拔掉u盘，重新启动n1，再次进入192.168.1.1修改lan口静态地址

![image-20221203105419405](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221203105419405.png)

![image-20221203105743294](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221203105743294.png)

##### 6.测试

连上网线，连接主路由，打开看一下是否有网，有网就说明成功了，如果没有的话，通过ip地址访问一下百度等网站，如果通过ip访问成功说明dns有问题。

> 注意：主路由要是路有模式，我之前的主路由是桥接模式，结果怎么弄都不行，出现了连接不上网络，dns错误，还有明明配置了passwall，n1测试也是通的，但是连接n1的设配却无妨访问，这一切都是因为主路由是桥接模式。这样子配置旁路由只有连接n1的设备才能科学上学

### smartDns配置

 [抛却繁琐，只需1分钟来设置smartdns](https://www.right.com.cn/FORUM/thread-4108395-1-1.html)

![image-20221204152818627](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204152818627.png)

![image-20221204143604980](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204143604980.png)

![image-20221204143702613](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204143702613.png)

![image-20221204143820668](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204143820668.png)

![image-20221204143920295](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204143920295.png)

![image-20221204144520464](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20221204144520464.png)

### 修改docker分区

[OpenWRT解决Docker空间不足的问题](https://huaweicloud.csdn.net/63311ca9d3efff3090b5281c.html?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-1-122290989-blog-126481588.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Eactivity-1-122290989-blog-126481588.pc_relevant_default&utm_relevant_index=1) 

[openwrt中docker目录扩容](https://blog.csdn.net/m0_59092234/article/details/126481588?ops_request_misc=&request_id=&biz_id=102&utm_term=OpenWrt%20docker%E7%A9%BA%E9%97%B4%E6%89%A9%E5%AE%B9&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-126481588.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&spm=1018.2226.3001.4187) 