#### 一、安卓基本分区

##### 1、bootloader（fastboot）

Android 系统虽然也是基于 Linux 系统的，但是由于 Android 属于嵌入式设备，并没有像 PC 那样的 BIOS 程序。 取而代之的是 Bootloader —— 系统启动加载器。
一旦bootloader分区出了问题，手机变砖就很难救回了。除非借由高通9008或者MTK-Flashtool之类更加底层的模式来救砖。
一般刷机不动这个分区。

##### 2、recovery

用于存放recovery恢复模式的分区，刷机、root必须要动的分区。里面有一套linux内核，但并不是安卓系统里的那个，相当于一个小pe的存在。现阶段的刷机、root基本都要用第三方rec来覆盖官方rec。

##### 3、boot

引导分区，虽然说是引导，但实际是在bootloader之后，与recovery同级的启动顺序。里面装了安卓的linux内核相关的东西，magisk就是修改了这部分程序，实现的root权限的获取。

##### 5、userdata（data）

用户数据分区，被挂载到/data路径下。内置存储器（内置存储卡）实际也存在这个分区里，用户安装的apk、app的数据都在这个分区。目前主流安卓版本中data分区通过fuse进行了强制加密，密码一般都是屏锁密码，且加密的data分区未必能在recovery下成功解密，所以有时刷机需要清除整个data分区。

##### 6、cache

缓存分区，一般用于OTA升级进入recovery前，临时放置OTA升级包以及保存OTA升级的一些临时输出文件。

#### 二、安卓系统的启动流程

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/attach-f23a29252f5e2b9ac32946994dd532c22b37d813.png)
一般来说，安卓系统的刷机都是在fastboot和recovery进行的，因为此时安卓系统本身还没有启动，直接无视各种权限进行操作。
fastboot通常又被叫做线刷模式，PC端通过fastboot程序直接向手机刷写分区镜像文件，fastboot无法进行更加细致的操作，一刷就是整个分区，而不能对某个、某些文件进行特定的修改。
recovery模式下可以刷入带有脚本的zip包，可以实现对系统的增量修补，修改特定文件等更细致、强大的功能，但问题在于官方的recovery拥有签名校验，非官方的zip包无法通过官方的recovery刷入，于是我们需要刷入第三方的recovery来运行非官方签名的刷机包的刷入。于是我们就需要在fastboot下刷入第三方的recovery。
但是，fastboot的刷入也有限制，未解锁的fastboot（也就是bootloader锁、bl锁）不允许刷入非官方签名过的img镜像，所以我们需要对bootloader进行解锁，国内允许解锁bl锁的厂商就只有小米了，所以像搞机得用小米的机子。
通过解锁bootloader来刷入第三方的recovery，再通过第三方的recovery来刷入第三方的刷机包（如magisk或是其它的系统)达到直接或间接修改boot、system等分区的文件，这就是刷机的真谛。

其中Magisk作用于boot.img的阶段。Magisk的安装实际是将boot分区导出然后进行patche后再重新刷入。magisk通过直接修改boot.img中的linux内核相关文件实现了root权限的获取，也是由于其在很靠前的位置，可以通过在system分区挂载时，额外挂载分区、文件、目录来实现对系统文件的替换、修改而不修改原始文件。

Riru的Lsposed框架作用Zygote阶段，通过注入Zygote来实现对其创建进程的修改。

## 参考文章

1. [玩机必看！带你入坑安卓刷机，小白也能看懂的ROOT基础指南来啦！](https://www.bilibili.com/video/BV1BY4y1H7Mc)
2. [安卓机root抓包及绕过检测教程（上）](https://forum.butian.net/share/1068)
3. [安卓机root抓包及绕过检测教程（下）](https://forum.butian.net/share/1069)

