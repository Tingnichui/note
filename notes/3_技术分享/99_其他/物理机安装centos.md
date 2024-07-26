### 系统安装

下载centos镜像

使用balenaEtcher将镜像装到u盘里面

u盘启动进入install的时候不要直接安装

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/a46527424609c5bd86460d7eab52ecd2.png)

需要先按E进入修改卷标页面，修改第2行内容为 

```
/images/pxeboot/vmlinuz initrd=initrd.img linux dd quiet
```

按ctrl + x 执行上面的启动项

然后屏幕上就会列出硬盘设备的详细信息，

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/8431eca6b37e6b13cbae6613b491e385.png)

从列表中挑出当前作为介质的U盘的代码（比如sda4）然后重起系统，修改启动条目为：

```
/images/pxeboot/vmlinuz inst.stage2=hd:/dev/sda4 quiet
```

使用Ctrl+x执行启动安装。这时候就能进入我们熟悉的界面安装了。

## 网卡驱动

网卡驱动安装，自己百度

可以用手机通过usb共享网络给物理机，暂时解决一下

找不到对应的网卡可以看下这边文章

[linux中各种最新网卡2.5G网卡驱动，不同型号的网卡需要不同的驱动，整合各种网卡驱动，包括有线网卡、无线网卡、Wi-Fi热点](https://blog.csdn.net/u014374009/article/details/134176665#comments_33731443)

我的网卡是 `Intel Corporation Device 125c (rev 04)`

用上面的教程使用 `sh update.sh` 更新内核版本之后成功有网，至于是什么我就不在乎了，有网就行

## 参考文章

 https://blog.csdn.net/yu619251940/article/details/127450107

 [Linux教程-centos挂载u盘并复制文件 - 蜜獾互联网 - 博客园](https://www.cnblogs.com/ratelcloud/p/17696571.html)
 https://post.m.smzdm.com/p/al855r5e/
 https://linux.cc.iitk.ac.in/mirror/centos/elrepo/kernel/el7/x86_64/RPMS/
 https://www.cnblogs.com/BlogNetSpace/p/15188982.html
 https://www.cnblogs.com/DeepRS/p/15812385.html
 https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://blog.csdn.net/duapple/article/details/128679984&ved=2ahUKEwjOhduJ17CHAxXJevUHHfeTBAIQFnoECBEQAQ&usg=AOvVaw0oi81w0wk3YvTQMzt23j3M
https://blog.51cto.com/u_15077549/4316908