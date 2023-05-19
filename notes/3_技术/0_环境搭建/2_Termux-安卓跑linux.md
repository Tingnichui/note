## Termux-安卓跑linux

> ###### 无法安装docker等 亲测可以跑mysql，属于废旧手机废物利用，但是又不怎么用得着

### 初始化

***不要安装什么配色方案 没有意义，而且可能导致错误***

1. 更换源（换了会快一点）

   ```bash
   sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
   
   sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
    
   sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
    
   pkg update
   ```

2. 安装ssh 通过电脑连接termux

   ```bash
   # 安装ssh并启用服务 通过 passwd输入密码 端口为8022
   pkg install openssh
   sshd
   passwd
   # 将 sshd 服务在开启termux时就启动
   echo "sshd" >> ~/.bashrc
   # 安装nmap并启用
   pkg install nmap
   nmap
   # 查看termux地址 并在电脑上通过xshell连接
   ifconfig
   ```

3. 备份与恢复

   ```bash
   # 创建一个备份文件夹
   mkdir /sdcard/termuxBak
   # 备份
   cd /data/data/com.termux/files
   tar -zcf /sdcard/termuxBak/termux-backup.tar.gz home usr #备份配置文件为 termux-backup.tar.gz
   # 恢复
   cd /data/data/com.termux/files
   tar -zxf /sdcard/termuxBak/termux-backup.tar.gz --recursive-unlink --preserve-permissions #操作完成重启 Termux 即可恢复数据。
   ```

4. 安装基础工具

   ```bash
   pkg install vim curl wget git tree -y
   ```

### 构建环境

- root

  ```bash
  # 未root命令
  pkg install proot -y
  termux-chroot # 即可模拟 root 环境，该环境模仿 Termux 中的常规 Linux 文件系统，但是不是真正的 root。
  # 已root
  pkg install tsu -y
  tsu # 即可切换 root 用户，这个时候会弹出 root 授权提示，给予其 root 权限，效果图如下:
  ```
  
- mysql

  ```bash
  pkg install mariadb
  mysql --version
  mysql_install_db #初始化数据库
  nohup mysqld > mysql.log & #启动 MySQL 服务
  ps aux|grep mysql # 查看mysql进程PID
  kill -9 PID # 停止 MySQL 服务
  
  # 修改 root 密码
  mysql -u $(whoami) # 登录 Termux 用户
  # 修改 root 密码的 SQL语句
  use mysql
  set password for 'root'@'localhost' = password('chunhui');
  # 远程登录 MySQL
  grant all on *.* to root@'%' identified by 'chunhui' with grant option;
  # 刷新权限 并退出
  flush privileges;
  quit;
  # 设置自启
  vim ~/.bashrc
  nohup mysqld > mysql.log & #写入文件
  ```

- ngrok内网穿透-未成功

  [termux内网穿透-ngrok](https://blog.csdn.net/xnllc/article/details/123085807?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167220877316782427445335%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167220877316782427445335&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-123085807-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=termux%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F&spm=1018.2226.3001.4187) 

  [termux ngrok 内网穿透](https://blog.csdn.net/qq_23357159/article/details/115256330?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167220877316782427445335%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167220877316782427445335&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-115256330-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=termux%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F&spm=1018.2226.3001.4187) 

  ```bash
  https://ngrok.com/
  
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
  
  tar zxvf ngrok-v3-stable-linux-arm64.tgz
  chmod 777 ngrok
  mv ngrok $PREFIX/bin/
  ngrok -v
  
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
  cat $HOME/.ssh/id_rsa.pub
  
  ngrok authtoken [Your Authoken]
  ngrok config add-authtoken [Your Authoken]
  ngrok authtoken [Your Authoken]
  
  termux-chroot
  
  ngrok http 3306
  ```

- centos

  [Android Termux 安装 Linux 就是这么简单](https://www.sqlsec.com/2020/04/termuxlinux.html) 

  ```bash
  pkg install proot git python -y
  
  git clone https://github.com/sqlsec/termux-install-linux
  cd termux-install-linux
  python termux-linux-install.py
  
  cd ~/Termux-Linux/CentOS
  ./start-centos.sh
  ```


### 参考文章

1. [Termux 高级终端安装使用配置教程](https://blog.csdn.net/qq_39312146/article/details/127913614) 
2. [Termux 高级终端安装使用配置教程](https://www.sqlsec.com/2018/05/termux.html) 
3. [Termux学习资源及电脑端xshell连接手机端termux步骤](https://blog.csdn.net/weixin_49663860/article/details/123450506?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167219289016782425183130%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167219289016782425183130&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-123450506-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=%E7%94%B5%E8%84%91%E8%BF%9E%E6%8E%A5termux&spm=1018.2226.3001.4187)  
4. [安卓与docker----在旧手机上部署服务](https://post.smzdm.com/p/a5d4qzkk/) 
5. [Termux安装数据库](https://blog.csdn.net/weixin_45853881/article/details/126940611?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167220515916800182728510%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167220515916800182728510&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-126940611-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=termux%E5%AE%89%E8%A3%85mysql&spm=1018.2226.3001.4187) 

