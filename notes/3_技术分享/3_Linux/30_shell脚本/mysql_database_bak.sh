#!/bin/bash

# 设置mysql的登录用户名和密码
MYSQL_USER="root"
MYSQL_PASSWORD="123123"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
 
# 保存主目录
BACKUP_DIR="/home/backup/mysql"
# 保存子目录
BACKUP_SUB_DIR="$(date +%Y%m%d)"
# 保存路径
BACKUP_LOCATION="${BACKUP_DIR}/${BACKUP_SUB_DIR}"
# 备份时间
BACKUP_TIME=$(date +%Y%m%d_%H%M%S)

if [ -z "$BACKUP_LOCATION" ]; then
  echo "备份文件保存目录不能为空"
  exit 1
fi
# 备份目录不存在则创建
if [ ! -d "$BACKUP_LOCATION" ]; then
  mkdir -p "$BACKUP_LOCATION"
fi
if [ -z "$1" ]; then
  echo "备份数据库名称不能为空"
  exit 1
fi

BACKUP_FILE_NAME="${BACKUP_LOCATION}/$1_${BACKUP_TIME}.sql.gz"

/usr/local/mysql/bin/mysqldump -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --routines --single-transaction --quick --databases "$1" |gzip > "$BACKUP_FILE_NAME"

# 检查备份是否成功
if [ $? -eq 0 ] && [ -f "$BACKUP_FILE_NAME" ] && [ $(stat -c%s "$BACKUP_FILE_NAME") -gt 20 ]; then
  echo "备份成功: $BACKUP_FILE_NAME"
  ls -lh "${BACKUP_FILE_NAME}"
else
  echo "备份失败"
  exit 1
fi