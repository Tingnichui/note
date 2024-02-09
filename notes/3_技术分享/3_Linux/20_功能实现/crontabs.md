centos 或者红帽系统下检查服务是否安装：

```
systemctl status crond
```

安装

```shell
# crond 安装：
yum -y install crontabs
# 启动 crond 服务: 
systemctl start crond
# 关闭 crond 服务: 
systemctl stop crond
# crond设置开机自启动: 
systemctl enable crond
# 重新载入配置
systemctl reload crond
# 查看 crontab 服务是否已经加入了开机启动
chkconfig crond --list
# 加入开机自动启动
chkconfig crond on
```

基础命令

crontab(选项)(参数)

```
-e：编辑该用户的计时器设置；
-l：列出该用户的计时器设置；
-r：删除该用户的计时器设置；
-u<用户名称>：指定要设定计时器的用户名称。
```

编写shell脚本 脚本中也使用绝对路径

```shell
#!/bin/bash

echo 'hello world' $(date "+%Y-%m-%d %H:%M:%S") >> /home/log.txt
```

添加定时任务

```
crontab -e
```

```
# 脚本的绝对路径 每分钟执行一次test脚本命令
# 不输出任何内日志
*/1 * * * *   /home/test.sh >/dev/null 2>&1 
```

crontab 日志

```
tail -f /var/log/cron
```

日志输出

正确、错误日志的输出是否写入到文件方法：

1.不输出任何内容

```
*/1 * * * * /root/XXXX.sh >/dev/null 2>&1 
```

2.将正确和错误日志都输出到 /tmp/load.log

```
*/1 * * * * /root/XXXX.sh > /tmp/load.log 2>&1
```

3.只输出正确日志到 /tmp/load.log

```
*/1 * * * * /root/XXXX.sh > /tmp/load.log
```

4.只输出错误日志到 /tmp/load.log

```
*/1 * * * * /root/XXXX.sh 2> /tmp/load.log
```

参考文章

1. https://wangchujiang.com/linux-command/c/crontab.html
2. [crontab使用说明【一文搞懂Linux定时任务Crontab】](https://www.cnblogs.com/mollyviron/p/17270506.html)
3. [使用crontab管理你的Linux计划任务](https://blog.csdn.net/qq_41779565/article/details/129758718)
4. [Linux 定时执行shell脚本命令之crontab](https://www.cnblogs.com/wenzheshen/p/8432588.html)

