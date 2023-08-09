查找某一服务进程

```shell
ps -ef | grep <service_name> | grep -v grep
```

通过端口查看对应服务进程pid

```shell
lsof -i:7089
```

```shell
netstat -tuln | grep LISTEN | grep 7089
```

通过服务进程pid查看端口

```shell
netstat -antup | grep PID
```

根据服务进程pid查找服务所在目录

```shell
readlink -e /proc/<pid>/exe
```