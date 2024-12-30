```
rm -rf /home/application/cloudreve
```

```shell
mkdir -vp /home/application/cloudreve/{uploads,avatar} \
&& touch /home/application/cloudreve/conf.ini \
&& touch /home/application/cloudreve/cloudreve.db
```

```
docker run -d --name cloudreve \
-p 5212:5212 \
--mount type=bind,source=/home/application/cloudreve/conf.ini,target=/cloudreve/conf.ini \
--mount type=bind,source=/home/application/cloudreve/cloudreve.db,target=/cloudreve/cloudreve.db \
-v /home/application/cloudreve/uploads:/cloudreve/uploads \
-v /home/application/cloudreve/avatar:/cloudreve/avatar \
cloudreve/cloudreve:3.8.3
```

```
vi /home/application/cloudreve/conf.ini
```

```
docker logs cloudreve
docker restart cloudreve
docker rm -f cloudreve
```

## 参考文章

1. https://docs.cloudreve.org/