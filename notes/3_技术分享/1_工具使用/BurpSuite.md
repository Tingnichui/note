下载https://portswigger.net/burp/releases#community



#### 设置代理

选择【Proxy】→【Proxy setting】，配置代理监听器，默认监听`127.0.0.1:8080`且是运行状态，若端口有被占用请更改端口，否则无法拦截请求![image-20240212192328617](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240212192328617.png)

浏览器设置代理（谷歌浏览器为例）

http和https 不能同时设置，只能设置一个，因为http不走ssl

![image-20240212193452955](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240212193452955.png)

#### 安装CA证书

使用内部浏览器时不需要安装CA证书，使用外部浏览器时，若未安装CA证书则无法拦截HTTPS请求。在安装Burp的CA证书之前，应确保BurpSuite和外部浏览器已成功建立代理连接，连接代理后，直接浏览器访问`127.0.0.1:8080`，会进入很简单的欢迎页面，点击【CA Aertificate】下载证书，双击安装证书，将证书安装到“受信任的根证书颁发机构”即可，或者进入证书页面导入下载的证书

![请添加图片描述](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/919af093c2cc4d429445447360e7382a.png)

#### 目标设置

目标范围设置是在套件范围内告诉BurpSuite哪些主机和URL是我们需要的，设置目标范围可以更准确地获取到目标信息。选择【Target】→【Scope】，配置要包含后要排除的范围，默认是添加URL前缀即可，若此条件无法满足范围要求，可使用高级范围设置，勾选【Use advanced scope control】，设置目标后，选择【Proxy】→【Options】，配置客户端和服务端拦截规则，选择只拦截目标范围内的，拦截到的数据就会很明确

![image-20240212195807745](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240212195807745.png)

## 参考文章

1. [Burp Suite使用指南](https://t0data.gitbooks.io/burpsuite/content/chapter2.html)
2. [渗透测试工具Burp Suite详解](https://blog.csdn.net/Waffle666/article/details/111083913)
3. [Burp Suite安装及常用功能介绍](https://blog.csdn.net/Q0717168/article/details/118035672)
4. [APP各种抓包教程](https://cloud.tencent.com/developer/article/2316324)
5. https://www.cnblogs.com/ssan/p/12693141.html
6. http://www.snowywar.top/?p=2447



