> **1.下载NSSM**
>
> **2.根据windows平台，将32/64位nssm.exe文件解压至任意文件夹**
>
> **3.cmd定位至nssm.exe所在目录，如你操作系统是32bit，请对应32位的nssm.exe文件，如你操作系统是64bit，请对应64位的nssm.exe**
>
> **4.输入 nssm install {服务名称}，即注册Windows服务的名称。**





下载地址：http://nssm.cc/download

![image-20240119172836626](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119172836626.png)



解压 `nssm-2.24.zip`

编写启动bat

![image-20240119173934847](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119173934847.png)

切换到nssm解压目录，根据电脑操作系统选择切换到win32还是win64，执行服务注册 `nssm install 服务名称`

![image-20240119174110245](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119174110245.png)



选择应用bat

![image-20240119174301433](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119174301433.png)

点击install service

![image-20240119174338293](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119174338293.png)



任务管理器查看注册的服务，注册成功时暂停状态，需要启动

![image-20240119174417323](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240119174417323.png)



## 常用命令

```
NSSM常用命令，如下：

1.安装服务：nssm install 服务名称

2.删除服务：nssm remove 服务名称

3.删除服务确定：nssm remove 服务名称 confirm

4.修改服务（显示界面修改）：nssm edit 服务名称

5.启动服务：nssm start 服务名称

6.停止服务：nssm stop 服务名名称

7.停止服务：nssm stop 服务名称
```



## 参考文章

1. [小巧又实用的NSSM封装windows服务工具介绍](https://zhuanlan.zhihu.com/p/455904037)