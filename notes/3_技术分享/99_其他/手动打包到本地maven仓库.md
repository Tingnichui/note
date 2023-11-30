有可能需要创建一个pom.xml，内容如下

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

        <groupId>joda-time</groupId>
        <artifactId>joda-time</artifactId>
        <version>2.10.10</version>
        
</project>
```

在pom文件目录下执行，以下命令

```
.\mvn install:install-file -Dfile=D:\tempfile\joda-time-2.10.10.jar -DgroupId="com.ai.common" -DartifactId="ai-common-cms" -Dversion="1.0-SNAPSHOT" -Dpackaging=jar
```

```
.\mvn install:install-file -Dfile=D:\tempfile\joda-time-2.10.10.jar -DgroupId="org.apache.commons" -DartifactId="commons-dbcp2" -Dversion="2.2.0" -Dpackaging=jar --settings "C:\MyProgram\develop\Maven\apache-maven-3.5.4-yaxin\conf\settings-导包时使用.xml"
```



## 参考文章

1. https://juejin.cn/post/7091643749918310431