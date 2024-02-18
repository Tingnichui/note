# Jetty

[如何在Jetty中禁用Trace方法](https://blog.csdn.net/qq_33479841/article/details/109769790)

```shell
curl  -v -X TRACE  localhost:port
```

```java
package com.ai.res.data.sync.config;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Slf4j
@WebFilter(urlPatterns = "/*")
public class JettyFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        log.info("拦截器执行-----");
        if (StringUtils.equalsAnyIgnoreCase(httpRequest.getMethod(), "TRACE", "TRACK")) {
            httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            log.info("trace 拦截执行");
            return;
        }
        log.info("拦截器结束-----");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
```

启动类增加注解 @ServletComponentScan

```java
@ServletComponentScan 增加这个注解
public class AiResDataSyncApplication {

    public static void main(String[] args) {
        SpringApplication springApplication = new SpringApplication(AiResDataSyncApplication.class);
        springApplication.run(args);
    }

}
```

