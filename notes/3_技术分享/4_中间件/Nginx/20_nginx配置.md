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

