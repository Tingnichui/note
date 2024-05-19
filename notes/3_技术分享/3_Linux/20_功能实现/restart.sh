#!/bin/bash
  
# 定义启动jar包
JAR_NAME="lrb-agent.jar"
# 定义脚本所在决定路径
BASE_PATH=$(cd `dirname $0`; pwd)
ENV="test"

# 设置java配置参数
JAR_CONFS="--spring.profiles.active=${ENV}"
JAR_CONFS="$JAR_CONFS --logback.logpath=${BASE_PATH}/logs"

# 设置jvm参数
JAVA_OPTS="-Xms2048m -Xmx2048m"
JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${BASE_PATH}/gc/`date +'%Y-%m-%d_%H-%M-%S'`_heapdump.hprof"


# 检查启动 JAR 是否存在
check_jar() {
    if [ ! -f "${BASE_PATH}/${JAR_NAME}" ]; then
        echo "${JAR_NAME} 启动包不存在"
        exit 1
    fi
}

# 停止服务
stop() {
    status
    if [ -n "$pid" ]; then
        echo "Stopping existing process with PID $pid"
        mkdir -p "${BASE_PATH}/stack"
        mkdir -p "${BASE_PATH}/gc"
        jstack -l ${pid} > ${BASE_PATH}/stack/`date +'%Y-%m-%d_%H-%M-%S'`_${pid}.stack
        kill -9 "$pid"
        sleep 5
        echo "$JAR_NAME stoped successfully."
    else
        echo "$JAR_NAME has stoped."
    fi
}

# 启动服务
start() {
    check_jar
    #nohup java -jar "$JAR_NAME" > /dev/null 2>&1 &
    #nohup java $JAVA_OPTS -jar "${BASE_PATH}/$JAR_NAME" $JAR_CONFS > ${BASE_PATH}/nohup.out 2>&1 &
    nohup java $JAVA_OPTS -jar "${BASE_PATH}/$JAR_NAME" $JAR_CONFS > ${BASE_PATH}/nohup.out 2>> ${BASE_PATH}/error.out &
    # 启动成功
    status
    if [ -n "$pid" ]; then
        echo "$JAR_NAME start successfully."
    else
        echo -e "\033[1;31m $JAR_NAME is not running! \033[0m"
    fi
}

# 重新启动
restart() {
    stop
    start
}

status() {
    # 使用绝对路劲寻找pid，防止出错
    pid=$(ps -ef | grep "${BASE_PATH}/$JAR_NAME" | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$JAR_NAME running PID is $pid."
    fi
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
 "start")
  start
  ;;
 "stop")
  stop
  ;;
 "restart")
  restart
  ;;
 "status")
  status
  ;;
 *)
  restart
  ;;
esac