https://blog.csdn.net/qq_29974229/article/details/133878576

https://gitee.com/qqmiller/openssh-9.5p1-.x86_64.git



https://rpmfind.net/

```shell
# 创建备份目录
cd /opt/ && mkdir backup
# 备份opensll
mv /usr/bin/openssl  /opt/backup/openssl.old
mv /usr/lib64/openssl /opt/backup/lib64-openssl.old
# 备份openssh
mv /etc/ssh/sshd_config /opt/backup/sshd_config.backup
mv /etc/pam.d/sshd /opt/backup/sshd.backup
# 压缩一份 备份
tar -zcvf /opt/openssl-ssh.tar.gz /opt/backup/

# 移除openssl
yum -y remove openssl
# 移除openssh 这个步骤可能包含了ssl
rpm -e --nodeps `rpm -qa | grep openssh`

# 安装依赖
yum -y install gcc pam-devel zlib-devel openssl-devel

# 安装openssl
cd /opt/ && tar -xzvf openssl-1.1.1w.tar.gz && cd openssl-1.1.1w/
./config --prefix=/usr
make && make install

# 安装openssh
cd /opt/ && tar -zxvf openssh-9.5p1.tar.gz && cd openssh-9.5p1
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-zlib --with-pam --with-md5-passwords
# --with-tcp-wrappers--without-hardening
make && make install

# 配置
chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key
cp -a contrib/redhat/sshd.init /etc/init.d/sshd
chmod u+x /etc/init.d/sshd
mv /opt/backup/sshd.backup /etc/pam.d/sshd
mv /opt/backup/sshd_config.backup /etc/ssh/sshd_config
## 修改状态为yes
vim /etc/ssh/sshd_config
PermitRootLogin yes
PubkeyAuthentication yes
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

chkconfig --add sshd
chkconfig sshd on
systemctl restart sshd
ssh -V

# 关闭权限校验
setenforce 0
或者
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```



```shell
#!/bin/bash
# 使用教程地址 https://lblog.net/?p=282
# 备份
cd /opt/ && mkdir backup
mv /usr/bin/openssl  /opt/backup/openssl.old
mv /usr/lib64/openssl /opt/backup/lib64-openssl.old
mv /etc/ssh/sshd_config /opt/backup/sshd_config.backup
mv /etc/pam.d/sshd /opt/backup/sshd.backup
tar -zcvf /opt/openssl-ssh.tar.gz /opt/backup/

# 卸载
yum -y remove openssl
rpm -e --nodeps `rpm -qa | grep openssh`
# 安装依赖
yum -y install gcc pam-devel zlib-devel openssl-devel

# 安装openssl
cd /opt/ && tar -xzvf openssl-1.1.1w.tar.gz && cd openssl-1.1.1w/
./config --prefix=/usr/local/ssl -d shared
make && make install
echo '/usr/local/ssl/lib' >> /etc/ld.so.conf
ldconfig -v

# 安装openssh
cd /opt/ && tar -zxvf openssh-9.5p1.tar.gz && cd openssh-9.5p1
./configure --prefix=/usr/local/openssh --with-zlib=/usr/local/zlib --with-ssl-dir=/usr/local/ssl
make && make install

# 修改配置
echo 'PermitRootLogin yes' >> /usr/local/openssh/etc/sshd_config
#echo 'PubkeyAuthentication yes' >> /usr/local/openssh/etc/sshd_config
#echo 'PasswordAuthentication yes' >> /usr/local/openssh/etc/sshd_config

# sshd
cp -a /opt/openssh-9.5p1/contrib/redhat/sshd.init /etc/init.d/sshd
chmod u+x /etc/init.d/sshd

# 创建软连接
ln -s /usr/local/openssh/bin/* /usr/bin/
ln -s /usr/local/openssh/sbin/sshd /usr/sbin/sshd
# 假如到系统管理并且重启
chkconfig --add sshd
chkconfig sshd on
systemctl restart sshd
ssh -V
```



ssh升级后无法登陆报错 /bin/bash: Permission denied

https://blog.csdn.net/ct_666/article/details/118340501

```
setenforce 0
或者
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```



## 设置telnet登录

升级过程中会卸载旧版本 `ssh` 导致远程无法连接,所以先安装一个 `telnet` 以防万一

此处是[教程](telnet远程连接服务器.md) 

## 备份

- 为了避免升级过程中出现的意外导致服务器无法进行连接,建议对重要的内容先进行备份

- 在主机服务商那里为主机创建快照,防止最糟糕的事情发生

- 备份 openssl openssh  相关文件

- ```
   yum install -y lrzsz
   ```

## 升级openssl

https://ftp.openssl.org/source/

查看openssl版本

```
openssl version
```

安装依赖

```
yum -y install gcc*
```

查找openssl 相关目录，然后备份

```
[root@localhost ~]# whereis openssl
openss:[root@localhost ~]# whereis openssl
openssl: /usr/bin/openssl /usr/lib64/openssl /usr/share/man/man1/openssl.1ssl.gz
[root@localhost ~]# mv /usr/bin/openssl /usr/bin/openssl.bak
[root@localhost ~]# mv /usr/lib64/openssl /usr/lib64/openssl.bak
```

 卸载 openssl (这一步看个人需要，我有洁癖所以我卸载了)

```
yum remove openssl -y
```

安装

> 目录选择了/usr 是因为系统最初始的openssl的目录就是/usr 这样可以省去的软连接、更新链接库的问题

```
tar -xzvf openssl-1.1.1w.tar.gz

cd openssl-1.1.1w/

./config --prefix=/usr

make && make install
```

验证

```
[root@vm206 openssl-1.1.1w]# whereis openssl

openssl: /usr/bin/openssl /usr/lib64/openssl /usr/include/openssl /usr/share/man/man1/openssl.1ssl.gz /usr/share/man/man1/openssl.1
                                                                        
[root@localhost openssl-1.1.1w]# openssl version
OpenSSL 1.1.1w  11 Sep 2023


[root@localhost ~]# whereis openssl
openssl: /usr/bin/openssl.bak-20231213 /usr/bin/openssl /usr/lib64/openssl.bak-20231213 /usr/include/openssl /usr/share/man/man1/openssl.1
[root@localhost ~]# openssl version
OpenSSL 1.1.1w  11 Sep 2023
```

*#可以看到我这边的目录和老版本的openssl的目录保持了一致，唯一不同的是多了一个/usr/include/openssl 库目录*

*#如果不加prefix ,openssl的默认路径如下*

```bash
Bin：  /usr/local/bin/openssl

include库  ：/usr/local/include/openssl

lib库：/usr/local/lib64/

engine库：/usr/lib64/openssl/engines
```

## 升级openssh

可用版本下载，

http://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/

http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/

我这里下载的是`openssh-9.5p1.tar.gz`

安装依赖

```
yum -y install gcc pam-devel zlib-devel openssl-devel
```

备份

> *通过whereis ssh sshd找出bin文件、源文件，然后备份。 man手册不需要备份。*

```
[root@localhost home]# whereis ssh sshd
ssh: /usr/bin/ssh /etc/ssh /usr/share/man/man1/ssh.1.gz
sshd: /usr/sbin/sshd /usr/share/man/man8/sshd.8.gz
[root@localhost home]# mv /usr/bin/ssh /usr/bin/ssh-bak-20231213
[root@localhost home]# mv /etc/ssh /etc/ssh-bak-20231213
[root@localhost home]# mv /usr/sbin/sshd /usr/sbin/sshd-bak-2023121
```

备份验证文件

```
mv /etc/pam.d/sshd  /etc/pam.d/sshd-bak-20231213
```

卸载旧版本

```sh
yum remove openssh -y
# rpm -e --nodeps强制卸载
rpm -e --nodeps `rpm -qa | grep openssh`
```

编译配置

```sh
tar -zxvf openssh-9.5p1.tar.gz
cd openssh-9.5p1
./configure --prefix=/usr --sysconfdir=/etc/ssh  --with-pam   --with-ssl-dir=/usr/local/lib64/
# ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib --with-md5-passwords 
```

编译安装

```sh
make && make install
```

调整文件权限

```sh
chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key
```

复制配置文件

```sh
cp -a contrib/redhat/sshd.init /etc/init.d/sshd
chmod u+x /etc/init.d/sshd
```

还原配置文件

```sh
mv sshd.backup /etc/pam.d/sshd
mv sshd_config.backup /etc/ssh/sshd_config
```

添加开机启动

```sh
chkconfig --add sshd
chkconfig sshd on
```

重启sshd

```sh
systemctl restart sshd
#重启

ssh -V
#查看版本
```

成功升级到`OpenSSH_9.3p1, OpenSSL 1.0.2k-fips 26 Jan 2017`

## 参考文章

1. [升级openssh升级过程](https://www.sudytech.com/_s80/2018/0729/c3276a26030/page.psp)
2. https://www.cnblogs.com/jianzhan/p/ssh-update.html
3. [Openssh升级方法](https://blog.csdn.net/Katie_ff/article/details/131623844)
4. https://www.cnblogs.com/simendavid/p/17792570.html

