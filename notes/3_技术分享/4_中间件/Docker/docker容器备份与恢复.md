# docker容器备份与恢复

[Docker中容器的备份、恢复和迁移](https://www.linuxidc.com/Linux/2015-08/121184.htm) 

```bash
#查看 容器id
docker ps
#形成快照
docker commit -p 30b8f18f20b4 container-backup
#保存本地
docker save -o ~/container-backup.tar container-backup
#恢复镜像
docker load -i ~/container-backup.tar
```