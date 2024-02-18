1，解bl
2，提取boot
3，修补boot
4，刷入boot
5，开机成功获取root

## 解锁BL

1. 进入开发者模式

   设置 - 我的设备 - 全部参数 - MIUI版本（多次连点，系统会提示开发者模式）

   打开OEM解锁

2. 绑定小米账号

   设置 - 更多设置 - 开发者选项 - 设备解锁状态

3. 小米解锁工具

   https://www.miui.com/unlock/index.html下载并解压，启动后登录小米账号

   连接手机后，点击右上角设置 - 驱动检测，安装驱动

4. 手机进入FASTBOOT模式

   手机关机后，同时按住开机键和音量下键

5. USB连接手机，打开小米解锁工具，点击 “解锁”按钮

## 刷三方rev

1. 安卓工具包下载

   https://developer.android.com/tools/releases/platform-tools?hl=zh-cn

2. 下载对应的TWRP

   https://twrp.me/

3. 装Magisk安装包下载并上传

   官方版本：https://github.com/topjohnwu/Magisk/releases

   **alpha（推荐）**： 

   1. 网页下载 https://install.appcenter.ms/users/vvb2060/apps/magisk/distribution_groups/public 
   2. tg中下载 https://t.me/magiskalpha

   下载后修改文件后缀为zip上传到手机存储，我的电脑上传或者使用adb命令上传

   ```shell
   # adb push 本地上传文件绝对路径 手机目录
   adb push C:\MyProgram\develop\burpsuite\9a5ba575.0 /system/etc/security/cacerts/
   ```

   **注意：Magisk的apk安装包经过特殊处理，扩展名改为zip即为recovery下使用的刷机包，，重命名为 uninstall.zip 即是卸载包，，apk即为安卓使用的magisk管理app。**

4. 手机进入fastboot模式，手机usb连接电脑

   ```shell
   # 重启手机到fastboot模式
   adb reboot bootloader
   ```

5. 刷入三方recovery并进入Recovery模式

   ```shell
   # 查看是否连接到设备
   fastboot devices
   # 刷入分区  将三方recovery刷入recovery分区
   fastboot flash recovery TWRP等三方包的绝对路径
   fastboot flash recovery D:\tempfile\xiaomi8root\twrp-3.7.0_9-0-dipper.img
   ```
   
   ❗**此时twrp已被刷入，但别急着重启，直接重启系统会导致系统将recovery还原，我们需要直接进入到twrp中。**
   先按下音量加和电源键，在手机屏幕熄灭时松开电源键，手机显示小米logo并震动时松开音量键，等待片刻即可进入recovery。
   
7. 刷入Magisk

   首次进入TWRP管理界面时系统会提示是否修改系统分区，**先去点击Change Language**，将语言改成中文。然后将**蓝色的条滑动到右侧**，表示允许修改。

   ![image-20240215224935511](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240215224935511.png)

8. 完成

   刷入面具就自动获取root了, 如果进去显示Magisk让你安装完整版本的Magisk的话，我们把我们上面下载的apk, 修改为zip的在修改成apk进行安装

   如果magisk ramdisk显示false, 那在点击安装，选择直接安装，安装后重启，zygisk可以点击设置，在设置中打开，重启生效。

   当此处能够正常显示版本号时，Magisk则安装成功了，当然你也可以去下载几个需要root权限的软件试试，比如MT文件管理器、RE文件浏览器之类的，去看看比如/data之类没有root访问不了的路径。

## 模块安装

首先安装**救砖模块**，其余的按需安装

## 参考文章

1. [小米8root](https://www.cnblogs.com/xuzhen97/p/16341352.html)
2. [玩机必看！带你入坑安卓刷机，小白也能看懂的ROOT基础指南来啦！](https://www.bilibili.com/video/BV1BY4y1H7Mc)
3. [2022 年小米手机 8 获取 root 权限刷机教程](https://www.sxy91.com/posts/xiaomi8-root/)
4. [目前有效的面具Magisk版本大合集](https://www.bilibili.com/read/cv20082595/)
5. https://xiaomirom.com/