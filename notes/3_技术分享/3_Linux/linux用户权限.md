## 权限

![文件的正常权限](https://img-blog.csdnimg.cn/20201108195112214.png#pic_center)

```
- ：普通文件
d：目录文件
l：链接文件
s：表示socket文件          
c：字符设备文件 character
b：块设备文件 block 磁盘设备
p：pipe管道文件
```

## 用户与组

id(查看用户信息)、useradd(新建新用户)、groupadd(新建组)、userdel(删除用户)、usermod(更改用户信息)、su(切换登录用户)、passwd(创建用户密码)

```shell
[root@localhost secrets]# useradd tingnichui
[root@localhost secrets]# passwd tingnichui
更改用户 tingnichui 的密码 。
新的 密码：
重新输入新的 密码：
passwd：所有的身份验证令牌已经成功更新。
[root@localhost secrets]# groupadd developer
[root@localhost secrets]# usermod tingnichui -g developer
[root@localhost secrets]# id tingnichui
uid=1000(tingnichui) gid=1002(developer) 组=1002(developer)
```

##### 添加用户`useradd [选项]… 用户名`

```shell
·-u：指定 UID 标记号
·-d：指定宿主目录，缺省为 /home/用户名
·-e：指定帐号失效时间
·-g：指定用户的基本组名（或GID号）
·-G：指定用户的附加组名（或GID号）
·-M：不为用户建立并初始化宿主目录
·-s：指定用户的登录Shell
·-c：用户注释描述信息
·-r: 新建系统用户，不会有新建家目录
```

##### 更改用户`usermod` 

```shell
格式：usermod [选项]… 用户名
常用命令选项
·-l：更改用户帐号的登录名称
·-L：锁定用户账户  ---（锁定账户的实质就是更改用户的密码，在密码前面加上了一个！）
·-U：解锁用户账户
·以下选项与useradd命令中的含义相同
-u、-d、-e、-g、-G、-s

·-u：指定 UID 标记号
·-d：指定宿主目录，缺省为 /home/用户名
·-e：指定帐号失效时间
·-g：指定用户的基本组名（或GID号）
·-G：指定用户的附加组名（或GID号）
·-s：指定用户的登录Shell
```

##### 删除用户`userdel -r`

```shell
·格式：userdel [-r] 用户名
·添加 -r 选项时，表示连用户的宿主目录一并删除 # 注：建议接上
```

##### 修改密码`passwd`

```
·格式：passwd [选项]… 用户名
常用命令选项
·-d：清空用户的密码，使之无需密码即可登录
·-l：锁定用户帐号---（锁定账户的实质就是更改用户的密码，在密码前面加上两个！）
·-S：查看用户帐号的状态（是否被锁定）
·-u：解锁用户帐号
·–stdin：接收别的命令stdout做为stdin标准输入设置密码
```

##### 组操作命令

```
groupadd 命令   #新建组
groupdel 命令   #删除组
groupmod命令   #修改组
-g  修改组id
-n   修改组名
newgrp        # 修改有效组
gpasswd        # 管理组
groups        # 查询用户所在的组
```

## 修改权限

##### 修改文件或文件夹权限chmod

```
格式1：chmod [ugoa] [±=] [rwx] 文件或目录…
·u、g、o、a 分别表示
u属主、g属组、o其他用户、a所有用户
·+、-、= 分别表示
+增加、-去除、=设置权限
·rwx
·-R：递归修改指定目录下所有文件、子目录的权限
```

```
格式2：chmod nnn 文件或目录… # 注：nnn表示3位八进制数
权限项 读 写 执行 读 写 执行 读 写 执行
字符表示 r w x r w x r w x
数字表示 4 2 1 4 2 1 4 2 1
权限分配 文件所有者 文件所属组 其他用户
·-R：递归修改指定目录下所有文件、子目录的权限
```

##### 修改文件的属主和属组chown

```
chown 属主 文件
chown :属组 文件
chown 属主:属组 文件
常用选项：-R：递归修改指定目录下所有文件、子目录的归属（chmod跟chown都是一样的）
```

##### 修改属组chgrp 

```
·格式： chgrp 属组 文件
·必须是root或者是文件的所有者
·必须是新组的成员
常用命令选项
·-R：递归修改指定目录下所有文件、子目录的归属
```

## 参考文章

1. [Linux用户权限](https://blog.csdn.net/weixin_43880061/article/details/123432772)

