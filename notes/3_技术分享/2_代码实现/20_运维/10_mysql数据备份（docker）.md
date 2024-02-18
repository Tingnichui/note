```shell
#!/bin/bash
#设置mysql的登录用户名和密码
mysql_user="wxrcgy"
mysql_password="wxrcgy"
mysql_host="localhost"
mysql_port="3306"
 
# 需要备份的数据库
database="wx-rcgy"
# mysql容器名称
docker_name="mysql_5.7_nm"
# 备份文件存放地址
backup_location=/storage/backup

# 是否删除过期数据 ON 打开 OFF关闭
expire_backup_delete="OFF"
expire_days=7
backup_file_name=rcgy
backup_time=`date +%Y%m%d_%H%M`
backup_dir=$backup_location
 
# 备份目录不存在则创建
if [ ! -d "$backup_location" ]; then
  mkdir -p "$backup_location"
fi

# 备份指定数据库中数据
docker exec -it ${docker_name} mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password --routines --events --flush-logs --single-transaction --quick --force -B $database > ${backup_dir}/${backup_file_name}_${backup_time}.sql

# 删除过期数据-未测试 不清楚能不能用
#if [ "$expire_backup_delete" == "ON" -a  "$backup_location" != "" ];then
#        `find $backup_location -name "*.sql" -type f -mmin +1 -exec rm -rf {} \; > /dev/null 2>&1`
#        echo "Expired backup data delete complete!"
#fi
```

