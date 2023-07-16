## 创建证书

> 注意：一般生成的目录,应该放在nginx/conf/ssl目录

1.创建服务器证书密钥文件 server.key：

```bash
openssl genrsa -des3 -out server.key 4096
```

输入密码，确认密码，自己随便定义，但是要记住，后面会用到。

2.创建服务器证书的申请文件 server.csr

```bash
openssl req -new -key server.key -out server.csr
```

输出内容为：
Enter pass phrase for root.key: ← 输入前面创建的密码
Country Name (2 letter code) [AU]:CN ← 国家代号，中国输入CN
State or Province Name (full name) [Some-State]:BeiJing ← 省的全名，拼音
Locality Name (eg, city) []:BeiJing ← 市的全名，拼音
Organization Name (eg, company) [Internet Widgits Pty Ltd]:MyCompany Corp. ← 公司英文名
Organizational Unit Name (eg, section) []: ← 可以不输入
Common Name (eg, YOUR name) []: ← 此时不输入
Email Address []:admin@mycompany.com ← 电子邮箱，可随意填
Please enter the following ‘extra’ attributes
to be sent with your certificate request
A challenge password []: ← 可以不输入
An optional company name []: ← 可以不输入

3.备份一份服务器密钥文件

```bash
cp server.key server.key.org
```

4.去除文件口令

```bash
openssl rsa -in server.key.org -out server.key
```

5.生成证书文件server.crt

```bash
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

## 配置证书

```
server{
    #比起默认的80 使用了443 默认 是ssl方式 多出default之后的ssl
    listen 443 default ssl;
    #default 可省略
    #开启 如果把ssl on；这行去掉，ssl写在443端口后面。这样http和https的链接都可以用
    ssl on;
    #证书(公钥.发送到客户端的)
    ssl_certificate ssl/server.crt;
    #私钥,
    ssl_certificate_key ssl/server.key;
    #下面是绑定域名
    server_name www.daj.com;
}
```

## 开启nginx的ssl模块

todo

## 参考文章

1. [centos7 生成ssl证书，搭建https地址](https://blog.csdn.net/qq_22385935/article/details/91990876)