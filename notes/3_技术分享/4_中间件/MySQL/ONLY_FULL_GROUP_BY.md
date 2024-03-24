```
-- 查看mysql默认的模式方式一：
SELECT @@GLOBAL.sql_mode; (修改于当前服务，重新MySQL服务失效)
 
-- 查看mysql默认的模式方式二: (修改于当前会话，关闭当前会话会失效)
SELECT @@SESSION.sql_mode;

-- 去除 ONLY_FULL_GROUP_BY模式，重新设置值。
set @@global.sql_mode 
='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

永久生效的方法

修改my.cnf配置[mysqld]增加

```
sql_mode = STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
```

重启mysql

```bash
service mysql stop
service mysql start
```





## 参考文章

1.  [mysql中sql_mode的修改](https://blog.csdn.net/qq_15957557/article/details/110281847)
