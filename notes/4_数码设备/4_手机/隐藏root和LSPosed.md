> 前提是我们得 **打开 Magisk 的 Zygisk 选项**

## 配置排除列表

Magisk 设置中，勾选「遵守排除列表」然后在「配置排除列表」里面勾选想要隐藏 ROOT 的 APP 即可，本次使用「国家反诈中心」APP 为例

## 隐藏 Magisk 应用

不排除某些 APP 检测当前手机是否安装了 Magik 应用的可能，不要慌，Magisk 也考虑到了这种情况。可以在设置里面自定义 Magisk 应用的包名，然后重启手机即可正常使用我们新建的自定义应用，和之前一样使用即可

![image-20240216021702057](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240216021702057.png)

## 开启 Shamiko 模块

首先下载最新的 Shamiko 模块：https://github.com/LSPosed/LSPosed.github.io/releases

然后打开 Magisk 在「模块」菜单中选择「从本地安装」，选择我们之前下载好的 Shamiko 模块即可，刷入完重启即可成功安装：

## 参考文章

1. [【完美隐藏root】全APP正常使用，过momo环境检测，KernelSU＋Shamiko](https://www.bilibili.com/video/BV18s4y1g71L/)
2. [隐藏 ROOT](https://mobile.sqlsec.com/4/1/)