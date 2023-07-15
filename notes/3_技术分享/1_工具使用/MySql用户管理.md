创建用户

```mysql
CREATE USER zhang3 IDENTIFIED BY '123123'; # 默认host是 %
CREATE USER 'kangshifu'@'localhost' IDENTIFIED BY '123456';

CREATE USER `res`@`%` IDENTIFIED BY '123456';
CREATE USER `res`@`%` IDENTIFIED WITH mysql_native_password BY '123456';
```

修改用户

```mysql
UPDATE mysql.user SET USER='li4' WHERE USER='wang5'; 
FLUSH PRIVILEGES;
```

删除用户

```mysql
DROP USER li4 ; # 默认删除host为%的用户
DROP USER 'kangshifu'@'localhost';
```

设置当前用户密码

```mysql
# 修改当前用户的密码：（MySQL5.7测试有效） 
SET PASSWORD = PASSWORD('123456');
```

修改其他它用户密码

```mysql
ALTER USER user [IDENTIFIED BY '新密码'] 
[,user[IDENTIFIED BY '新密码']]…;
```



##### 参考文章

1. [详细介绍MySQL中的用户与权限管理](https://blog.csdn.net/qq_43459116/article/details/124232387)