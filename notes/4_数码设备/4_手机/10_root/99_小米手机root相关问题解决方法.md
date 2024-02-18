## 手机进入fastboot后无法识别

> https://blog.csdn.net/sizaif/article/details/123285444

**解决方法**

下载驱动: [google_latest_usb_driver_windows](https://github.com/xushuan/google_latest_usb_driver_windows)

解压后目录下有个: `android_winusb.inf` 文件

1. 打开设备管理器
2. 【Android Device】里找到 `Android`类似带有 ！的不正常驱动
3. 更新驱动

## fastboot模式下左上角显示 press any key to shutdown 

> https://miuiver.com/press-any-key-to-shutdown/

**解决方法**

更换电脑 USB 2.0 端口连接便可解决。如果电脑没有 USB 2.0 端口，也可以使用 USB 集线器连接。

如果都没有，可以将下面内容用记事本另存为 `.bat` 批处理文件（[直接下载](https://miuiver.com/wp-content/uploads/2021/06/usb3-fix.zip)），然后以管理员身份运行，之后再连接便不会有问题。❗**<u>谨慎使用这个方法，我使用之后一个usb出现了无法识别设备只能充电的情况，重启几次也没用，过了几天反而好了</u>**

```bat
@echo off
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "osvc" /t REG_BINARY /d "0000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipContainerIdQuery" /t REG_BINARY /d "01000000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipBOSDescriptorQuery" /t REG_BINARY /d "01000000" /f
pause
```