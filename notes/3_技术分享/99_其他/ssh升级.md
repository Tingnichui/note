## 前置操作

1. 为了避免升级过程中出现的意外导致服务器无法进行连接,建议对重要的内容先进行备份

2. 在主机服务商那里为主机创建快照,防止最糟糕的事情发生

3. 备份 /etc/pam.d/sshd 文件

   ```shell
   mv /etc/pam.d/sshd /etc/pam.d/sshd-bak
   ls -l /etc/pam.d/sshd*
   -rw-r--r-- 1 root root 904 Nov 25  2021 /etc/pam.d/sshd-bak
   ```

## 安装telnet

升级过程中会卸载旧版本 `ssh` 导致远程无法连接,所以先安装一个 `telnet`

```
rpm -q telnet-server
#检查是否安装了telnet服务端
rpm -q telnet
#检查是否安装了telnet客户端
```

提示`package telnet-server is not installed`表示未安装

```
yum install telnet-server  -y
#安装telnet服务端

yum install telnet -y
#安装telnet客户端
```

### 启动

```sh
systemctl enable telnet.socket
#设置开机启动该

systemctl start telnet.socket
#打开服务
```

防火墙开放`23`端口

使用`telnet ip地址`进行连接登录

### 允许root登录

默认系统不允许root用户使用telnet远程登陆

```sh
echo 'pts/0' >>/etc/securetty
echo 'pts/1' >>/etc/securetty
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

## 参考文章

1. [升级openssh升级过程](https://www.sudytech.com/_s80/2018/0729/c3276a26030/page.psp)
2. https://www.cnblogs.com/jianzhan/p/ssh-update.html