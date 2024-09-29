https://docs.zfile.vip/install/os-docker

```
curl -k -o /home/application/zfile/application.properties https://c.jun6.net/ZFILE/application.properties
```

```bash
docker run -d --name=zfile --restart=always \
    -p 8080:8080 \
    -v /home/application/zfile/db:/root/.zfile-v4/db \
    -v /home/application/zfile/logs:/root/.zfile-v4/logs \
    -v /home/application/zfile/file:/data/file \
    -v /home/application/zfile/application.properties:/root/application.properties \
    zhaojun1998/zfile
```

自动更新

```bash
docker run -d \
    --name watchtower \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower \
    --cleanup \
    zfile \
    -i 3600
```