## 工具

jdk exe安装包——用于提取jdk，可以在[oracle](https://www.oracle.com/java/technologies/downloads/#java8-windows)下载

UniversalExtractor——用于解压文件，在我的笔记—软件—PC有提供[下载链接](https://www.aliyundrive.com/s/YTLXkDFtni3)

## 流程

##### 1.下载安装包

我这里是从oracle下载的最新的jdk-8u361-windows-x64.exe

![image-20230226215517671](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226215517671.png)

##### 2.解压

![image-20230226215632451](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226215632451.png)

##### 3.解压jdk-8u361-windows-x64\.rsrc\1033\JAVA_CAB10目录下的111文件，解压后有个tools压缩包，把它再解压就是想要的jdk包

![image-20230226215822639](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226215822639.png)

![image-20230226220359585](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226220359585.png)

![image-20230226220558811](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226220558811.png)

##### 4.管理员启动cmd，切换到tools目录下，运行以下命令后，再bin目录下执行 java -version，查看是否成功

```bash
for /r %x in (*.pack) do .\bin\unpack200 -r "%x" "%~dx%~px%~nx.jar"
```

![image-20230226220720590](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230226220720590.png)

## 参考文章

[将Java JDK安装文件提取为绿色版(免安装版)](https://www.52gh.top/code/java_jdk.html) 