查看占用磁盘最大10个容器

```shell
docker ps --size --format "{{.Names}}: {{.Size}}" | sort -rh -k 2 | head -n 10
```

这个命令将计算指定目录下每个文件夹的大小，并按照大小进行降序排序。`-h`选项用于以人类可读的格式显示文件夹大小。`--max-depth=1`参数用于限制只显示一级子目录的大小。

```shell
du -h /path/to/directory --max-depth=1 | sort -hr | head -n 10 --max-depth=1
```

发送post请求

```shell
curl -X POST -H "Content-Type: application/json" -d '{"code": "5f36a0d6-f9df-4827-a798-8f6ce4f588d5"}' http://172.29.146.110:8000/ai-sys-plus/system/manage/v1/check/code
```

查看磁盘占用

```shell
df -h
```

查看内存占用

```shell
free -h
```

```shell
top
```

查看cpu

```shell
lscpu
```

显示系统中的CPU核心数

```shell
nproc
```

将显示指定文件夹的总大小（以人类可读的格式）

```
du -sh /path/to/directory
```

## tar打包与解压

打包

```

```

## logstash

检查配置是否有语法错误

```
./bin/logstash -f ./config/logstash.conf -t
```

