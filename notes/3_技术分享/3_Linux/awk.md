awk命令格式和选项

```shell
awk [options] 'script' var=value file(s)
awk [options] -f scriptfile var=value file(s)
```

常用命令选项

- **-F fs** fs指定输入分隔符，fs可以是字符串或正则表达式，如-F:，默认的分隔符是连续的空格或制表符
- **-v var=value** 赋值一个用户定义变量，将外部变量传递给awk
- **-f scripfile** 从脚本文件中读取awk命令
- **-m[fr] val** 对val值设置内在限制，-mf选项限制分配给val的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。

## 基本结构

```shell
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file
```





```shell
awk 'BEGIN{ i=0 } { i++ } END{ print i }' filename
```

参考文章

1. [awk](https://wangchujiang.com/linux-command/c/awk.html)