#!/bin/bash

# 订阅地址
CLASH_URL="填写自己的订阅地址"
# 检验clash是否正常的地址
CHECK_STATUS_URL="https://www.google.com"
# clash运行目录
CLASH_DIR="/home/application/clash"
# clash配置文件名称
CLASH_CONFIG_NAME="config.yaml"
CLASH_CONFIG_PATH="${CLASH_DIR}/${CLASH_CONFIG_NAME}"

restart() {
  systemctl restart clash
  if [ ! "$?" -eq 0 ]; then
    echo "Failed to restart Clash"
    exit 1
  fi
}

# 调用这个方法的方式，source clash_service.sh proxy
proxy() {
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
  echo "Proxy settings applied."
}

# 调用这个方法的方式，source clash_service.sh unset_proxy
unset_proxy() {
  unset http_proxy https_proxy all_proxy
  echo "Proxy settings unset."
}

work_status() {
  response=$(curl -L -m 10 -o /dev/null -s -w "%{http_code}" "${CHECK_STATUS_URL}")
  if [ "$response" -eq 200 ]; then
    echo "Clash work health."
  else
    echo "Clash work has something wrong: $response."
    exit 1;
  fi
}

update_config() {
  if [ ! -d "$CLASH_DIR" ]; then
    echo "clash目录不存在"
    exit 1
  fi

  # 比较远程和当前配置差异 使用临时文件
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local temp_file_path="/tmp/clash_config_${timestamp}.yaml"
  curl -L -s -o ${temp_file_path} ${CLASH_URL}
  if [ ! "$?" -eq 0 ]; then
    echo "Failed to download new configuration."
    exit 1
  fi

  diff ${CLASH_CONFIG_PATH} ${temp_file_path} > /dev/null
  if [ "$?" -eq 0 ]; then
    echo "Configuration not need to update."
  else
    # 备份
    mv ${CLASH_CONFIG_PATH} "${CLASH_CONFIG_PATH}.bak_${timestamp}" || {
      echo "Failed to backup the configuration."
      exit 1
    }

    # 更新
    cp ${temp_file_path} ${CLASH_CONFIG_PATH} || {
      echo "Failed to update the configuration."
      exit 1
    }
    
    # 删除临时文件
    rm -f "${temp_file_path}"

    # 重启
    sleep 3
    restart
    echo "Configuration is up-to-date."
  fi
}

# 使用说明
usage() {
  echo "Usage: $0 {update_config|proxy|unset_proxy|restart|work_status}"
  exit 1
}


#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
 "update_config")
  update_config
  ;;
 "proxy")
  proxy
  ;;
 "restart")
  restart
  ;;
 "unset_proxy")
  unset_proxy
  ;;
 "work_status")
  work_status
  ;;
 *)
  usage
  ;;
esac