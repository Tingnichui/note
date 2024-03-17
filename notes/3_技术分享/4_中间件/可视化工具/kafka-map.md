## docker

```bash
docker pull dushixiang/kafka-map:v1.3.3
```

```bash
docker run -d --name kafka-map \
    --restart unless-stopped \
    -p 8080:8080 \
    -e DEFAULT_USERNAME=admin \
    -e DEFAULT_PASSWORD=admin \
    dushixiang/kafka-map:v1.3.3 | xargs docker logs -f 
```



