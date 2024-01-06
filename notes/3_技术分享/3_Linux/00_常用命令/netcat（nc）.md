## 安装

```shell
yum install nc -y
```

window下载地址：https://eternallybored.org/misc/netcat/

## 命令

##### 常用参数

-l	用于指定nc将处于侦听模式。指定该参数，则意味着nc被当作server，侦听并接受连接，而非向其它地址发起连接。

-s 	指定发送数据的源IP地址，适用于多网卡机 

-u	指定nc使用UDP协议，默认为TCP

-v	输出交互或出错信息，新手调试时尤为有用

-w	超时秒数，后面跟数字 

-z	表示zero，表示扫描时不发送任何数据

##### 网络连通性测试

tcp

```shell
# 开启一个tcp监听9999端口
nc -l 9999
# 向地址发送tcp请求
nc -v -w 2 192.168.139.101 9999
```

udp

```shell
# 开启一个udp监听9999端口
nc -ul 9999
# 向地址发送udp包
nc -vu 192.168.139.101 9999
```

##### 扫描端口

```shell
# 扫描udp端口
nc -vuz 192.168.139.101 3306
# 扫描tcp端口
nc -vz 192.168.139.101 3306
```

## 参考文章

1. [nc命令用法举例](https://blog.csdn.net/GNNUXXL/article/details/122299540)