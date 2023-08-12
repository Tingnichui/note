## 权限模式(Scheme)

通俗的来说，就是采用哪种方式进行权限认证，一共由6中方式。

| **权限模式** | **说明**                                                     |
| ------------ | ------------------------------------------------------------ |
| world        | 表示任何人都能访问操作节点                                   |
| auth         | 只有认证的用户可以访问，也就是不管什么哪个用，只要认证通过就能查看(cli中可以通过addauth digest user:pwd 来添加当前上下文中的授权用户) |
| digest       | 采用用户名密码的认证方式                                     |
| ip           | 使用客户端ip的认证方式                                       |

## 授权对象（ID）

授权对象意味着哪些对象有权限，给谁授予权限，不同权限模式下的授权对象都是不一致的。

| **权限模式** | **授权对象**                                                 | **例子**                     |
| ------------ | ------------------------------------------------------------ | ---------------------------- |
| world        | 永远只有一个授权对象，anyone                                 | anyone                       |
| auth         | 授权的用户名，cli中可以通过addauth digest user:pwd 来添加当前上下文中的授权用户,如addauth digest alvin:pwd | alvin                        |
| digest       | password需要加密处理，格式如username:base64(sha-1(username:password)) | alvin:SDFSDFcfasdfaU=        |
| ip           | 是一个ip地址或者ip地址段                                     | 10.100.1.10010.100.1.100/170 |

## 权限信息（Permission）

授予每个节点什么权限，控制权限授予的粒度。

| **类型** | **ACL简写** | **描述**                         |
| -------- | ----------- | -------------------------------- |
| read     | r           | 获取节点数据并列出其子节点权限   |
| write    | w           | 设置节点数据权限                 |
| create   | c           | 创建子节点权限                   |
| delete   | d           | 删除子节点权限（不包含当前节点） |
| admin    | a           | 设置该节点ACL权限的权限          |

## world

```
setAcl /path word:anyone:cdrwa
```

## Auth明文授权

![image-20230812230959694](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230812230959694.png)

```
addauth digest admin:password
```

```
setAcl / auth:admin:cdrwa
```

## digest授权模式

> auth模式的区别在于：
>
> 1、digest设置Acl的时候，可以不用先添加用户，而auth设置Acl的时候，是需要提前设置用户的，否则报错。
>
> 2、digest设置的密码要用密文，auth设置的密码是明文。
>
> 3、auth设置的，只需设置一个用户，就可以把所有用户设置进去，而digest不行，只能对本次设置的用户有效。也就是auth模式忽略id，setAcl命令中的id域是被忽略的，可以填任意值，或者空串，例如：setAcl <path> auth::crdwa。因为这个域是忽略的，会把所有已经添加的认证用户都加进来。

digest模式需要加密处理，通过下面的命令获取加密的字符串。

```shell
echo -n <user>:<password> | openssl dgst -binary -sha1 | openssl base64
```

示例

```
echo -n admin:password | openssl dgst -binary -sha1 | openssl base64
```

**注意授权时需要使用加密字符串的授权**

添加认证用户

```
addauth digest admin:bjkZ9W+M82HUZ9xb8/Oy4cmJGfg=
```

设置权限

```
设置单个
setAcl / digest:admin:bjkZ9W+M82HUZ9xb8/Oy4cmJGfg=:cdrwa
设置多个用 , 隔开
setAcl / digest:admin:bjkZ9W+M82HUZ9xb8/Oy4cmJGfg=:cdrwa,digest:admin:bjkZ9W+M82HUZ9xb8/Oy4cmJGfg=:cdrwa
```

查看acl

```
getAcl /
```

## 参考文章

1. [Zookeeper系列（三）——Zookeeper的ACL权限控制](https://developer.aliyun.com/article/1114685)
2. [ZooKeeper的acl权限控制「第二章 ZooKeeper使用」「架构之路ZooKeeper理论和实战」](https://blog.51cto.com/u_11142439/6555088)
3. [zookeeper的几种授权方式](https://www.jianshu.com/p/936daa0a82d5)