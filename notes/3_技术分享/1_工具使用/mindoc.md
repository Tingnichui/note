安装golang

```

```

https://juejin.cn/post/7094655700927774727



```
wget https://github.com/mindoc-org/mindoc/releases/download/v2.1/mindoc_linux_musl_amd64.zip


unzip mindoc_linux_musl_amd64.zip

CREATE DATABASE mindoc_db  DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;


cp conf/app.conf.example conf/app.conf

vi conf/app.conf


#数据库配置
db_adapter=mysql
#mysql数据库的IP
db_host=127.0.0.1

#mysql数据库的端口号一般为3306
db_port=3306

#刚才创建的数据库的名称
db_database=mindoc_db

#访问数据库的账号和密码
db_username=root
db_password=123456


./mindoc_linux_musl_amd64 install

nohup ./mindoc_linux_musl_amd64 >nohup.out 2>&1 &
```

https://www.kancloud.cn/tengqf/ziliao/2555431

[MinDoc 接口文档在线管理系统 - 官方网站](https://www.iminho.me/)