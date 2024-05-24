## nginx主动检查

https://github.com/yaoweibin/nginx_upstream_check_module

```bash
# 备份配置
mkdir -p /home/backup/nginx
cd /usr/local/nginx
tar -zcvf /home/backup/nginx/nginx_bak_20240524.tar.gz  ./conf/nginx.conf ./conf/cert/ ./conf/conf.d/
sz /home/backup/nginx/nginx_bak_20240524.tar.gz 

# 关闭nginx
nginx -s stop

mkdir -p /usr/local/nginx/modules

cd /usr/local/nginx/modules

wget https://github.com/yaoweibin/nginx_upstream_check_module/archive/refs/tags/v0.4.0.zip
unzip v0.4.0.zip
unzip nginx_upstream_check_module-0.4.0.zip

cd /usr/local/nginx-1.18.0
patch -p1 < /usr/local/nginx/modules/nginx_upstream_check_module-0.4.0/check_1.16.1+.patch

# 查看上一次编译
[root@localhost nginx-1.18.0]# nginx -V
nginx version: nginx/1.18.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module

# 重新编译
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --add-module=/usr/local/nginx/modules/nginx_upstream_check_module-0.4.0

make && make install

# 启动
nginx -c /usr/local/nginx/conf/nginx.conf

```

## 配置nginx

```conf
 
upstream test_load_balance {
        # 不要使用localhost，会多出一个
        server 10.0.0.201:80;
        server 10.0.0.202:80;
		
		# 第三方健康检查
		# interval 检测间隔时间，单位是毫秒
		# rise 表示请求2次正常，标记此后端的状态为 up
		# fall 表示请求3次失败，标记此后端的状态为 down 
		# type 类型为 tcp
		# timeout 为超时时间，单位是毫秒
        check interval=5000 rise=2 fall=3 timeout=4000 type=http;
		check_http_send "GET /lrb-agent-api/agent/health/healthCheck HTTP/1.0\r\n\r\n";
		check_http_expect_alive http_2xx http_3xx;
}
 
server {
        listen 80;
        server_name test.load.balance.com;
 
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
4. ###### [nginx 添加第三方nginx_upstream_check_module 模块实现健康状态检测](https://www.cnblogs.com/dance-walter/p/12212607.html)