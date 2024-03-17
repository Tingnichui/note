> 官方文档：https://www.xuxueli.com/xxl-job/

## 初始化数据库

下载源码：https://github.com/xuxueli/xxl-job/releases

执行 `/xxl-job/doc/db/tables_xxl_job.sql`

### 配置部署“调度中心”

### 源码编译

1. 修改调度中心配置：`/xxl-job/xxl-job-admin/src/main/resources/application.properties`

2. 执行编译

   ```bash
   mvn clean package
   ```

3. 部署，启动日志位于 `/data/applogs/xxl-job/xxl-job-admin.log`

   ```bash
   nohup java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/xxl-job-admin-heapdump.hprof -jar xxl-job-admin-2.4.0.jar > nohup.out 2>&1 &
   ```

   ```bash
   java -jar xxl-job-admin-2.4.0.jar
   ```

### docker部署

```bash
docker pull xuxueli/xxl-job-admin:2.4.0
```

```bash
docker run -d --name xxl-job-admin \
	-p 8080:8080 \
	-v /home/application/xxl-job:/data/applogs \
	xuxueli/xxl-job-admin:2.4.0 | xargs docker logs -f
```

* 如需自定义 mysql 等配置，可通过 "-e PARAMS" 指定，参数格式 PARAMS="--key=value  --key2=value2" ；
* 配置项参考文件：/xxl-job/xxl-job-admin/src/main/resources/application.properties
* 如需自定义 JVM内存参数 等配置，可通过 "-e JAVA_OPTS" 指定，参数格式 JAVA_OPTS="-Xmx512m" ；

```bash
# docker rm -f xxl-job-admin
```

```bash
docker run -d --name xxl-job-admin \
	-p 8080:8080 \
	-v /home/application/xxl-job:/data/applogs \
	-e PARAMS="--spring.datasource.url=jdbc:mysql://127.0.0.1:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai --spring.datasource.password=root --spring.datasource.username=root" \
    xuxueli/xxl-job-admin:2.4.0 | xargs docker logs -f
```

### 访问

调度中心访问地址：http://localhost:8080/xxl-job-admin (该地址执行器将会使用到，作为回调地址)

默认登录账号 “admin/123456”,

## 配置部署“执行器项目”

1. 引入依赖`xxl-job-core`
2. 执行器配置，配置内容说明（看文档）：`/xxl-job/xxl-job-executor-samples/xxl-job-executor-sample-springboot/src/main/java/com/xxl/job/executor/core/config/XxlJobConfig.java`