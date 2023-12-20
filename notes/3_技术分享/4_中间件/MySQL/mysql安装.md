## docker

```shell
docker run --name mysql \
    --restart=always \
    -p 3306:3306 \
    -v /home/application/mysql/log:/var/log/mysql  \
    -v /home/application/mysql/data:/var/lib/mysql  \
    -v /home/application/mysql/conf:/etc/mysql/conf.d \
    -e TZ=Asia/Shanghai  \
    -e MYSQL_ROOT_PASSWORD=admin!@#  \
    -d mysql:5.7.42
```