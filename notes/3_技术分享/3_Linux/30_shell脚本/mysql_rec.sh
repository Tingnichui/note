#!/bin/bash

# 设置mysql的登录用户名和密码
MYSQL_USER="test"
MYSQL_PASSWORD="123^123"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
 
# 需要恢复的数据库
DATABASE="test"

if [ -z "$DATABASE" ]; then
  echo "备份数据库名称不能为空"
  exit 1
fi
if [ -z "$1" ]; then
  echo "需要恢复文件地址不能为空"
  exit 1
fi

# 将输入的文件路径转换为绝对路径
FILE_PATH=$(realpath "$1")

if [ ! -f "$FILE_PATH" ]; then
  echo "恢复文件不存在或是目录"
  exit 1
fi

# 如果文件是 .gz 格式，先解压
if [[ "$FILE_PATH" == *.gz ]]; then
  echo "检测到 .gz 文件，正在解压..."
  gunzip -c "$FILE_PATH" > "${FILE_PATH%.gz}"
  FILE_PATH="${FILE_PATH%.gz}"
fi

/usr/local/mysql/bin/mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DATABASE" < "$FILE_PATH"

if [ $? -eq 0 ]; then
  echo "恢复成功: $FILE_PATH"
else
  echo "恢复失败"
  exit 1
fi