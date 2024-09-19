#!/bin/bash

# 参数验证函数
check_params() {
  if [[ -z "$2" || -z "$3" || -z "$4" || -z "$5" || -z "$6" || -z "$7" ]]; then
    echo "Error: 容器名称、平台、类型和关键词都不能为空 $*"
    exit 1
  fi
}

# 判断容器是否存在
container_exists() {
  docker ps --filter "name=$2" | grep -q "$2"
  if [ ! $? -eq 0 ]; then
    echo "Error: 容器 $2 不存在"
    exit 1
  fi
}

# 容器是否正在运行相关任务检查
status() {
  check_params "$@"
  container_exists "$@"
  # docker exec "$2" ps -ef | grep "python main.py" | grep "platform $3" | grep "type $4" | grep -q "keywords $5"
  # 目前只支持单线程运行
  local ps_res=$(docker exec "$2" ps -ef | grep "python main.py" | grep -v grep)
  if [ -n "$ps_res" ]; then
    echo "Warning: 容器 $2 中已经有正在执行 $ps_res"
    exit 1
  fi
}

# 定义crawler函数 1.容器名称 2.媒体平台 3.爬虫类型 4.关键词
crawler() {
  # 日志目录和日志文件
  local LOG_DIR="/home/application/media-crawler-pro/media-crawler-python/logs/$(date +%Y%m%d)"
  local TIME=$(date +%Y%m%d_%H%M%S)
  # 从参数获取容器名称、平台、类型和关键词
  local DOCKER_CONTAINER_NAME="$2"
  local PLATFORM="$3"
  local TYPE="$4"
  local KEYWORDS="$5"
  local RECORD_ID="$6"
  local START_PAGE="$7"

  # 检查参数是否为空
  check_params "$@"

  # 判断是否存在运行中的容器
  container_exists "$@"

  # 判断一下是否已经有线程在处理
  status "$@"
  # 创建日志目录
  if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
  fi

  LOG_FILE_PATH="${LOG_DIR}/${TIME}_${PLATFORM}_${TYPE}_${KEYWORDS}_${RECORD_ID}.log"
  # 运行 Docker 命令并记录日志
  docker exec "$DOCKER_CONTAINER_NAME" /bin/bash -c "
  python main.py \
    --save_data_option db \
    --platform '$PLATFORM' \
    --type '$TYPE' \
    --start '$START_PAGE' \
    --keywords '$KEYWORDS'" > "$LOG_FILE_PATH" 2>&1 &

  if [ $? -eq 0 ]; then
    echo "Success: 操作成功"
  else
    echo "Error: 操作失败"
    exit 1
  fi
}


#使用说明，用来提示输入参数
usage() {
  echo "Usage: sh $0 [crawler|status]"
  exit 1
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
 "crawler")
  crawler "$@"
  ;;
 "status")
  status "$@"
  ;;
 *)
  usage
  ;;
esac