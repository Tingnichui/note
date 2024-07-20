https://github.com/ulisesbocchio/jasypt-spring-boot

https://stackoverflow.com/questions/74761799/jasypt-failed-to-bind-properties-under-spring-datasource-password-to-java-lan

```
        <!-- 配置加密 -->
        <dependency>
            <groupId>com.github.ulisesbocchio</groupId>
            <artifactId>jasypt-spring-boot-starter</artifactId>
            <version>3.0.5</version>
        </dependency>
```

```yaml
jasypt:
  encryptor:
    password: ${JASYPT_ENCRYPTOR_PASSWORD}
```

```java
    @Resource
    private StringEncryptor encryptor;

    @Test
    void name() {
        System.err.println(encryptor.encrypt("1321321qweqwe1"));
    }
```

```yaml
spring:
  datasource:
    druid:
      username: ENC(+++i0MvBxM0aMR)
```

```
vim /etc/profile

export JASYPT_ENCRYPTOR_PASSWORD=qwxcasd

source /etc/profile

echo $JASYPT_ENCRYPTOR_PASSWORD

java -jar -Djasypt.encryptor.password=${JASYPT_ENCRYPTOR_PASSWORD} xxx.jar
```



## 参考文章

1. [SpringBoot 配置文件敏感信息加密](https://z.itpub.net/article/detail/3A3B1D11AB9B269526BA71DB21E81751)
2. [Spring Boot 配置文件密码加密两种方案](https://www.cnblogs.com/kexianting/p/11689289.html)
3. [Springboot 配置文件、隐私数据脱敏的最佳实践（原理+源码）](https://www.cnblogs.com/chengxy-nds/p/15093253.html)