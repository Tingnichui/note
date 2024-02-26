## SVN服务端

### 安装SVN

```shell
# Ubuntu
apt-get install subversion

# Centos
yum install subversion
```

查看是否安装成功，可以查看版本。

```shell
svnserve --version
```

### 创建版本库目录

创建SVN版本库目录，为后面创建版本库提供存放位置，也是最后启动SVN服务的根目录。

我们在/usr路径下创建svn目录作为版本库目录。

```bash
mkdir -p /usr/svn
cd /usr/svn
```

### 启动SVN服务

执行SVN启动命令，其中参数`-d`表示以守护进程的方式启动， `-r`表示设置的根目录。

```awk
svnserve -d -r /usr/svn/
```

关闭svn命令：

```ebnf
killall svnserve
```

### 参考文章

1. [Linux搭建SVN服务器详细教程](https://segmentfault.com/a/1190000040860576)

---

## SVN客户端

> 在windows系统中，安装TortoiseSVN软件，创建一个本地目录，右键选择SVN Checkout测试下，URL填写`svn://IP/dev`，dev替换成你创建的版本库名称。

### 安装

#### tortoisesvn

下载地址：https://tortoisesvn.net/downloads.zh.html

![image-20240226141148317](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240226141148317.png)

按需更改默认安装位置



![image-20240226135916180](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240226135916180.png)



#### tortoisesvn语言包

下载地址：https://tortoisesvn.net/downloads.zh.html

![image-20240226141411140](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240226141411140.png)

### 使用

[SVN详细使用教程](https://zhuanlan.zhihu.com/p/349437775)
