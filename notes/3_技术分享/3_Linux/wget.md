```shell
wget [参数选项] <URL地址>
```

**wget下载单个文件**

```
wget http://www.coonote.com/testfile.zip
```

**下载并以不同的文件名保存**

```
wget -O wordpress.zip http://www.coonote.com/download.aspx?id=1080
```

**wget限速下载**

```
wget --limit-rate=300k http://www.coonote.com/testfile.zip
```

**wget后台下载**

```
wget -b http://www.coonote.com/testfile.zip
```

**测试下载链接**

```
wget --spider URL
```

**下载多个文件**

```
wget -i filelist.txt
```

## 参考文章

1. [Linux wget命令](https://www.coonote.com/linux/linux-cmd-wget.html)

