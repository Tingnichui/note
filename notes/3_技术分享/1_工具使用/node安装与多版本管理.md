## 多版本管理

> 使用nvm管理不同版本的node

##### 安装

https://github.com/coreybutler/nvm-windows/releases

![image-20230706133919399](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706133919399.png)

![image-20230706134353701](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706134353701.png)

cmd 查看安装版本

![image-20230706134700427](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706134700427.png)

##### 添加镜像源

在nvm安装目录的setting.txt设置镜像

![image-20230706141424073](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706141424073.png)

![image-20230706141500408](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706141500408.png)

```
node_mirror: https://npm.taobao.org/mirrors/node/
npm_mirror: https://npm.taobao.org/mirrors/npm/
```

##### nvm使用

```bash
nvm off                     // 禁用node.js版本管理(不卸载任何东西)
nvm on                      // 启用node.js版本管理
nvm install <version>       // 安装node.js的命名 version是版本号 例如：nvm install 8.12.0
nvm uninstall <version>     // 卸载node.js是的命令，卸载指定版本的nodejs，当安装失败时卸载使用
nvm ls                      // 显示所有安装的node.js版本
nvm list available          // 显示可以安装的所有node.js的版本
nvm use <version>           // 切换到使用指定的nodejs版本
nvm v                       // 显示nvm版本
nvm install stable          // 安装最新稳定版
```

##### 参考文章

1. [nvm介绍、nvm下载安装及使用](https://blog.csdn.net/qq_30376375/article/details/115877446)


## Node.js安装

##### 下载node二进制

下载最新的node版本https://nodejs.org/zh-cn/download

![image-20230706111641718](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706111641718.png)

下载历史版本https://nodejs.org/zh-cn/download/releases

![image-20230706112051698](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706112051698.png)


##### 环境变量修改

![image-20230706105837879](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230706105837879.png)

环境变量配置之后可以通过cmd，查看当前版本

```bash
node -v
```

```bash
npm -v
```



##### npm下载路径修改

注意到C:\Users\wangyc\AppData\Roaming路径下有npm和npm-cache两个文件，其作用分别是

- npm：下载的具体模块文件

- npm-cache：npm的缓存文件

```shell
# 查看下载目录 全局下载目录
npm root -g
npm config get cache

# 修改全局下载目录 全局下载目录
npm config set prefix "你想设置的下载模块目录"
npm config set cache "你想设置的缓存目录"

# 修改项目下载目录 项目缓存目录
npm config set prefix <new-directory-path> -g
npm config set cache <new-directory-path> -g

# 重置全局下载目录和缓存目录
npm config delete prefix
npm config delete cache

# 重置项目下载目录和缓存目录
npm config delete prefix -g
npm config delete cache -g
```




##### 参考文章

1. [npm学习：安装、更新以及管理npm版本](https://blog.csdn.net/qq_44885775/article/details/126524404)
2. [windows node.js二进制文件的下载与配置](https://blog.csdn.net/lyqlcx/article/details/124033729)
