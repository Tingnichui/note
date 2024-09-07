#!/bin/bash

# 设置mysql的登录用户名和密码
MYSQL_USER="root"
MYSQL_PASSWORD="12312123"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"

CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

SYNC_STATUS="$(/usr/local/mysql/bin/mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e'show slave status\G;' | grep 'Running:')"
echo "$SYNC_STATUS"

Slave_IO_Running=`echo $SYNC_STATUS | awk '{print $2}'`
Slave_SQL_Running=`echo $SYNC_STATUS | awk '{print $4}'`
echo  ${Slave_IO_Running}
echo  ${Slave_SQL_Running}

if [ "${Slave_IO_Running}" = "Yes" ] && [ "${Slave_SQL_Running}" = "Yes" ];then
  echo "$CURRENT_TIME  mysql slave is ok." >> /home/backup/mysql/mysql_slave_status.log
else
  echo "$CURRENT_TIME  mysql slave hava some problem." >> /home/backup/mysql/mysql_slave_status.log
  exit 1
fi