## nginx主动检查

https://github.com/yaoweibin/nginx_upstream_check_module

```bash
mkdir -p /usr/local/nginx_model

cd /usr/local/nginx_model

wget https://github.com/yaoweibin/nginx_upstream_check_module/archive/refs/tags/v0.4.0.zip
unzip v0.4.0.zip

cd /usr/local/nginx-1.18.0
patch -p1 < ../nginx_model/nginx_upstream_check_module-0.4.0/check_1.16.1+.patch

# 查看上一次编译
nginx -V

# 重新编译
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --add-module=/usr/local/nginx_model/nginx_upstream_check_module-0.4.0
make && make install
```

## 配置nginx

```conf
 
upstream test_load_balance {
        server 10.0.0.201:80;
        server 10.0.0.202:80;
		
		# 第三方健康检查
		# interval 检测间隔时间，单位是毫秒
		# rise 表示请求2次正常，标记此后端的状态为 up
		# fall 表示请求3次失败，标记此后端的状态为 down 
		# type 类型为 tcp
		# timeout 为超时时间，单位是毫秒
		check interval=5000 rise=2 fall=3 timeout=4000 type=tcp;
}
 
server {
        listen 80;
        server_name test.load.balance.com;
 
        location / {
			proxy_pass http://test_load_balance;
			proxy_set_header Host $http_host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;	
			proxy_connect_timeout 60s;
			proxy_read_timeout 60s;
			proxy_send_timeout 60s;
			proxy_buffering on;
			proxy_buffer_size 8k;
			proxy_buffers 8 128k;
			proxy_http_version 1.1;
			proxy_next_upstream error timeout http_500 http_502 http_503 http_504;
        }
		
        # 重要 - 访问该地址用来查看 Nginx 负载均衡的健康状态
		location /upstream_check_status {
			check_status;
			access_log   off;
			#allow SOME.IP.ADD.RESS;
			#deny all;
		}
}
```



## 参考文章

1. [Nginx负载均衡健康检查第三方模块 nginx_upstream_check_module 功能的实现](https://blog.csdn.net/qq_40880022/article/details/121882051)
2. [nginx入门学习—— 在已安装好的nginx上添加nginx_upstream_check_module模块（三）](https://blog.csdn.net/Cherry8811cy/article/details/40711965)
3. [nginx动态添加nginx_upstream_check_module健康检查模块](https://www.cnblogs.com/LiuChang-blog/p/12501226.html)