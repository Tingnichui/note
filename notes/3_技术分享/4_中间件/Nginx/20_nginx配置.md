

[nginx安全:配置allow/deny控制ip访问(ngx_http_access_module)](https://www.cnblogs.com/architectforest/p/12794412.html)

https://nginx.org/en/docs/http/ngx_http_access_module.html



https://nginx.org/en/docs/http/ngx_http_upstream_module.html

upstream 组名不要有下划线



https://nginx.org/en/docs/http/ngx_http_proxy_module.html



[Nginx配置文件详解](https://www.cnblogs.com/54chensongxia/p/12938929.html)



## 引入其他配置文件

http块中引入其他配置文件

```
include /usr/local/nginx/conf/conf.d/*.conf;
```



## 前端静态

server块

```
# 
location / {
    root   /home/application/jljs/dist;
    index  index.html;
}

# 
location /web {
    root   /home/application/jljs/dist;
    index  index.html;
}
```

## 设置上传文件最大

http块

```
client_max_body_size 100m;
```

```
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        
    proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

## H5不缓存

https://segmentfault.com/a/1190000037521526

https://juejin.cn/post/7140840849302093861

```
expires -1;
add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
```



```
location / {
      expires -1;
      add_header 'Cache-Control' 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
      try_files $uri $uri/ @router;
      index index.html;
    }
```

