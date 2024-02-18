## 安装: telnet-server和xinetd

### 查看是否安装

```
rpm -qa telnet-server
```

```
rpm -qa xinetd
```

### 安装

```
yum list |grep telnet
```

```
yum list |grep xinetd
```

![image-20231212192533574](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20231212192533574.png)

执行安装

```
yum -y install telnet.x86_64
yum -y install telnet-server.x86_64
yum -y install xinetd.x86_64
```

### 设置开机自启

```
systemctl enable xinetd.service
systemctl enable telnet.socket
```

### 开启service

```
systemctl start telnet.socket
systemctl start xinetd
```

### 开启防火墙端口：

```
firewall-cmd --permanent --add-port=23/tcp
firewall-cmd --reload
```

## 登录

> 默认root账户不能登录

### 打开日志，登录一下查看是否能够成功登录

```
tail -f /var/log/secure 
```

无法登录

![image-20231212194342273](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20231212194342273.png)

### 解决方法

**方式一：**创建一个账号 useradd xxx  passwd xxx

```
useradd temproot
passwd temproot
usermod -g root temproot
chmod -R 775 /mnt/huaren/*
```

**方式二：**修改配置使其能够登录

```
echo 'pts/0' >>/etc/securetty
echo 'pts/1' >>/etc/securetty
或者
vi /etc/securetty
pts/0
pts/1
```

> 可能还需要添加下 pts/3 和 pts/4

输入正确的密码还是不能登录

主机端执行:`tail /var/log/secure`

看到了`access denied: tty 'pts/3' is not secure !`

再添加一个

```sh
echo 'pts/3' >>/etc/securetty
```

重启了`telnet`后再登录一切正常了

### 重启验证登录

> 视情况要不要重启，如果是生产还是不要了

```
reboot
```

## 关闭服务

```
systemctl disable xinetd.service
systemctl disable telnet.socket
systemctl stop xinetd.service
systemctl stop telnet.socket
```

## 参考文章：

1. [CentOS服务器安装Telnet来远程连接服务器](https://developer.aliyun.com/article/686282)
1. [记一次手动将OpenSSH从7.4升级到9.3的过程](https://www.cnblogs.com/jianzhan/p/ssh-update.html)