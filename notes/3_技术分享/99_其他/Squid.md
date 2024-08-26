```bash
yum install squid
systemctl start squid
systemctl enable squid
systemctl status squid
```

```bash
vi /etc/squid/squid.conf
```

```bash
tail -fn 10 /var/log/squid/access.log
```

## 参考文章

1. https://cloud.tencent.com/developer/article/1626753
2. https://www.cnblogs.com/ssgeek/p/12302135.html
3. https://telanx.github.io/2017/09/27/Squid%E5%88%87%E6%8D%A2%E5%88%B0https%E4%BB%A3%E7%90%86/