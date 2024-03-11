https://help.aliyun.com/zh/ssl-certificate/user-guide/install-ssl-certificates-on-nginx-servers-or-tengine-servers

设置http请求跳转https

```conf
server {
    listen 80;
    #填写证书绑定的域名
    server_name <yourdomain>;
    #将所有HTTP请求通过rewrite指令重定向到HTTPS。
    rewrite ^(.*)$ https://$host$1;
    location / {
        index index.html index.htm;
    }
}
```

8080端口原来不是ssl 现在增加了ssl，在server块中增加

```
error_page 497 https://$host:8800$uri;
```

