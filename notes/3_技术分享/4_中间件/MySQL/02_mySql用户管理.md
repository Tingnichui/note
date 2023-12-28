## 用户管理

登录mysql

```mysql
mysql -uroot -p
```

##### 查看所有用户

```
SELECT User, Host FROM mysql.user;
```

##### 创建用户

```mysql
CREATE USER zhang3 IDENTIFIED BY '123123'; # 默认host是 %
CREATE USER 'kangshifu'@'localhost' IDENTIFIED BY '123456';

CREATE USER `res`@`%` IDENTIFIED BY '123456';
CREATE USER `res`@`%` IDENTIFIED WITH mysql_native_password BY '123456';
```

##### 修改用户名

```mysql
UPDATE mysql.user SET USER='li4' WHERE USER='wang5'; 
FLUSH PRIVILEGES;
```

##### 删除用户

```mysql
DROP USER li4; # 默认删除host为%的用户
DROP USER 'kangshifu'@'localhost';
```

##### 设置当前用户密码

```mysql
# 修改当前用户的密码：（MySQL5.7测试有效）select version(); 
SET PASSWORD = PASSWORD('123456');
FLUSH PRIVILEGES;
```

##### 修改其他它用户密码

```mysql
ALTER USER user [IDENTIFIED BY '新密码'] 
[,user[IDENTIFIED BY '新密码']]…;

ALTER USER '<username>' IDENTIFIED BY '<new_password>'; # 默认设置host为%的用户
ALTER USER '<username>'@'localhost' IDENTIFIED BY '<new_password>';
```

## 密码管理

##### 设置过期策略

```mysql
ALTER USER '<username>'@'localhost' PASSWORD EXPIRE INTERVAL <days> DAY;
ALTER USER '<username>'@'localhost' PASSWORD EXPIRE NEVER;
```

##### 密码重用策略

```
# sql方式
SET PERSIST password_history = 6; #设置不能选择最近使用过的6个密码
SET PERSIST password_reuse_interval = 365; #设置不能选择最近一年内的密码
```

```
# my.cnf配置文件
[mysqld] 
password_history=6 
password_reuse_interval=365
```

##### 手动设置密码重用方式2：单独设置

```mysql
#不能使用最近5个密码： 
CREATE USER 'kangshifu'@'localhost' PASSWORD HISTORY 5; 
ALTER USER 'kangshifu'@'localhost' PASSWORD HISTORY 5; 
#不能使用最近365天内的密码： 
CREATE USER 'kangshifu'@'localhost' PASSWORD REUSE INTERVAL 365 DAY; 
ALTER USER 'kangshifu'@'localhost' PASSWORD REUSE INTERVAL 365 DAY; 
#既不能使用最近5个密码，也不能使用365天内的密码 
CREATE USER 'kangshifu'@'localhost' 
PASSWORD HISTORY 5 
PASSWORD REUSE INTERVAL 365 DAY; 
ALTER USER 'kangshifu'@'localhost
PASSWORD HISTORY 5 
PASSWORD REUSE INTERVAL 365 DAY;
```

## 权限管理

##### 有哪些权限`show privileges;`

1. CREATE和DROP权限 ，可以创建新的数据库和表，或删除（移掉）已有的数据库和表。如果将MySQL数据库中的DROP权限授予某用户，用户就可以删除MySQL访问权限保存的数据库。
2. SELECT、INSERT、UPDATE和DELETE权限 允许在一个数据库现有的表上实施操作。
3. SELECT权限只有在它们真正从一个表中检索行时才被用到。
4. INDEX权限 允许创建或删除索引，INDEX适用于已有的表。如果具有某个表的CREATE权限就可以在CREATE TABLE语句中包括索引定义。
5. ALTER权 限 可以使用ALTER TABLE来更改表的结构和重新命名表。
6. CREATE ROUTINE权限 用来创建保存的程序（函数和程序），ALTER ROUTINE权限用来更改和删除保存的程序， EXECUTE权限 用来执行保存的程序。
7. GRANT权限 允许授权给其他用户，可用于数据库、表和保存的程序。
8. FILE权限 使用户可以使用LOAD DATA INFILE和SELECT … INTO OUTFILE语句读或写服务器上的文件，任何被授予FILE权限的用户都能读或写MySQL服务器上的任何文件（说明用户可以读任何数据库目录下的文件，因为服务器可以访问这些文件）。

![image-20220417141037475](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/4985722b040ff9068b6dcd32cd64b145.png)



##### 授予权限

该权限如果发现没有该用户，则会直接新建一个用户

```sql
GRANT 权限1,权限2,…权限n ON 数据库名称.表名称 TO 用户名@用户地址 [IDENTIFIED BY ‘密码口令’];
```

给li4用户用本地命令行方式，授予test1db这个库下的所有表的插删改查的权限。

```mysql
GRANT SELECT,INSERT,DELETE,UPDATE ON testdb.* TO li4@localhost ;
```

授予通过网络方式登录的joe用户 ，对所有库所有表的全部权限，密码设为123。注意这里唯独不包括grant的权限

```mysql
GRANT ALL PRIVILEGES ON *.* TO joe@'%' IDENTIFIED BY '123';
```

- ALL PRIVILEGES是表示所有权限，你也可以使用SELECT、UPDATE等权限。
- ON用来指定权限针对哪些库和表，
- 中前面的 * 号用来指定数据库名，后面的 * 号用来指定表名。这里的 * 表示所有的。
- T0表示将权限赋予某个用户。
- 4@'localhost’表示i4用户，@后面接跟制的主机，可以是P、P段、域名以及%，%表示任何地方。注意：这里%有的版本不包括本地，以前碰到过给某个用户设置了%允许任何地方登录，但是在本地登录不了，这个和版本有关系，遇到这个问题再加一个localhost的用户就可以了。
- IDENTIFIED BY指定用户的登录密码。
- 如果需要斌予包括GRANTE的权限，添加参数“WITH GRANT OPTION"这个选项即可，表示该用户可以将自己拥有的权限授权给别人。经常有人在创建操作用户的时候不指定WITH GRANT OPTION选项导致后来该用户不能使用GRANT命令创建用户或者给其它用户授权.
- 可以使用GRANT重复给用户添加权限，**权限叠加**，比如你先给用户添加一个SELECT权限，然后又给用户添加一个INSERT权限，那么该用户就同时拥有了SELECT和INSERT权限。

##### 查看权限

查看当前用户权限

```sql
SHOW GRANTS; # 或 
SHOW GRANTS FOR CURRENT_USER; # 或 
SHOW GRANTS FOR CURRENT_USER();
```

查看某用户的全局权限

```mysql
SHOW GRANTS FOR 'user'@'主机地址' ;
```

##### 回收权限

```mysql
REVOKE 权限1,权限2,…权限n ON 数据库名称.表名称 FROM 用户名@用户地址;

#收回全库全表的所有权限 
REVOKE ALL PRIVILEGES ON *.* FROM joe@'%'; 
#收回mysql库下的所有表的插删改查权限 
REVOKE SELECT,INSERT,UPDATE,DELETE ON mysql.* FROM joe@localhost;
```

## 角色管理

> MySQL 8.0 版本引入了角色功能，但其角色功能较为有限，不同于其他数据库管理系统中的完整角色管理系统。角色在 MySQL 中的使用相对较少，并且角色功能的使用和管理较为有限。一般而言，MySQL 更常用的是基于用户的权限管理系统，通过为用户授予特定的权限来管理访问和操作数据库的权限

##### 创建角色

```mysql
CREATE ROLE 'role_name'[@'host_name'] [,'role_name'[@'host_name']]...

CREATE ROLE 'manager'@'localhost';
```

##### 给角色赋予权限

```mysql
GRANT privileges ON table_name TO 'role_name'[@'host_name'];

GRANT SELECT ON demo.settlement TO 'manager'; 
GRANT SELECT ON demo.goodsmaster TO 'manager'; 
GRANT SELECT ON demo.invcount TO 'manager';
```

##### 查看角色的权限

```mysql
SHOW GRANTS FOR 'developer'
```

##### 回收角色的权限

```mysql
REVOKE privileges ON tablename FROM 'rolename';

REVOKE INSERT, UPDATE, DELETE ON school.* FROM 'school_write';
```

##### 删除角色

```mysql
DROP ROLE role [,role2]

DROP ROLE 'rolename'
```

##### 给用户赋予角色

```mysql
GRANT role [,role2,...] TO user [,user2,...];

GRANT 'school_read' TO 'kangshifu'@'localhost';
SHOW GRANTS FOR 'kangshifu'@'localhost';
SELECT CURRENT_ROLE();
```

##### 激活角色

```mysql
# 方式1：使用set default role 命令激活角色
SET DEFAULT ROLE ALL TO 'kangshifu'@'localhost';

# 方式2：将activate_all_roles_on_login设置为ON 对 所有角色永久激活 
SET GLOBAL activate_all_roles_on_login=ON;
```

##### 撤销用户的角色

```mysql
REVOKE role FROM user;

REVOKE 'school_read' FROM 'kangshifu'@'localhost';
SHOW GRANTS FOR 'kangshifu'@'localhost';
```

##### 设置强制角色

```mysql
# 方式1：服务启动前设置
[mysqld] 
mandatory_roles='role1,role2@localhost,r3@%.testdb.com'

# 方式2：运行时设置
SET PERSIST mandatory_roles = 'role1,role2@localhost,r3@%.example.com'; 
#系统重启后仍然 有效
SET GLOBAL mandatory_roles = 'role1,role2@localhost,r3@%.example.com'; 
#系统重启后失效
```



## 参考文章

1. [详细介绍MySQL中的用户与权限管理](https://blog.csdn.net/qq_43459116/article/details/124232387)