连接服务

```
./zkCli.sh -server 127.0.0.1:2181
./zkCli.sh
```

删除节点

```shell
# 删除单个节点前要求节点目录为空，不存在子节点
delete /test
# 删除整个节点及子节点可以使用deleteall
deleteall /test
```

路径子节点

命令语法：ls [-s] [-w] [-R] path
-s 同时显示stat信息
-w 只显示子节点信息，默认选项
-R 递归显示

```shell
ls -R /
```

获取指定路径下的数据

```shell
get /zookeeper/config
```

设置或者更新路径数据

```
set /config/topics/test “this is a test”
get /config/topics/test
```

## 权限控制

| ACL权限 | ACL 简写 | 允许的操作                  |
| ------- | -------- | --------------------------- |
| CREATE  | c        | 创建子节点                  |
| READ    | r        | 获取节点的数据和它的子节点  |
| WRITE   | w        | 设置节点的数据              |
| DELETE  | d        | 删除子节点 （仅下一级节点） |
| ADMIN   | a        | 设置 ACL 权限               |

| world  | 只有一个用户：anyone，代表所有人（默认） |
| ------ | ---------------------------------------- |
| ip     | 使用IP地址认证                           |
| auth   | 使用已添加认证的用户认证                 |
| digest | 使用“用户名:密码”方式认证                |

查看权限

```
getAcl /config
```

设置权限

```
create /mynode1 hello
setAcl /mynode1 auth:admin:cdrwa
```

登录权限

```
addauth digest admin:admin
```

查看用户

```
getAcl /
```



## 参考文章

1. [常用命令之zookeeper命令](https://blog.csdn.net/carefree2005/article/details/123249339)
2. [zookeeper常用命令](https://blog.csdn.net/jiangtianjiao/article/details/89239354)