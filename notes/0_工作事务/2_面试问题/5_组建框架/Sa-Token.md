> **Sa-Token** 是一个轻量级 Java 权限认证框架，主要解决：**`登录认证`**、**`权限认证`**、**`Session会话`**、**`单点登录`**、**`OAuth2.0`**、**`微服务网关鉴权`** 等一系列权限相关问题。

## 实现原理

### 登录

> 通过id生成token，并将其放入request对象中，再生成cookie放入response

查看`StpUtil.login(id)`方法中的`setTokenValue`，这个方法根据用户id生成token并将其放入cookie中

```java
public void setTokenValue(String tokenValue, SaLoginModel loginModel) {
    if (!SaFoxUtil.isEmpty(tokenValue)) {
        this.setTokenValueToStorage(tokenValue);
        if (this.getConfig().getIsReadCookie()) {
            this.setTokenValueToCookie(tokenValue, loginModel.getCookieTimeout());
        }

        if (loginModel.getIsWriteHeaderOrGlobalConfig()) {
            this.setTokenValueToResponseHeader(tokenValue);
        }

    }
}
```

`SaHolder.getResponse()`方法是怎么获取到`response`的?查看`SaTokenContext`的实现类`SaTokenContextForSpring`中的`getResponse()`发现是通过`SpringMVCUtil.getResponse()`获取`response`

```java
    public static HttpServletResponse getResponse() {
        // 这里就是通过spring获取的，spring将response放入ThreadLocal，达到线程隔离
        ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
        if (servletRequestAttributes == null) {
            throw (new NotWebContextException("非Web上下文无法获取Response")).setCode(20101);
        } else {
            return servletRequestAttributes.getResponse();
        }
    }
```

### 鉴权

> 实现StpInterface接口，sa-token在鉴权时会调用该实现类，通过id获取该用户的所有权限信息，而用户id是通过token获取

## 参考文章

[Sa-Token官方文档](https://sa-token.cc/doc.html) 

[Sa-token简单介绍和基本使用](https://blog.csdn.net/weixin_43967582/article/details/122075950) 

[sa-token使用（源码解析 + 万字）](https://blog.csdn.net/weixin_39570751/article/details/121291274) 