## docker安装

```bash
docker pull elkozmon/zoonavigator:1.1.2
```

```bash
docker run -d --name zoonavigator \
    -p 9000:9000 \
    -e HTTP_PORT=9000 \
    --restart unless-stopped \
    elkozmon/zoonavigator:1.1.2 | xargs docker logs -f
```

