## objection

https://mabin004.github.io/2020/08/13/objection%E6%93%8D%E4%BD%9C/

https://book.hacktricks.xyz/cn/mobile-pentesting/android-app-pentesting/frida-tutorial/objection-tutorial

```bash
 # 连接手机，打开frida
 adb shell
 su
 cd /data/local/tmp/
 ./frida-server
```

```bash
正常启动：
objection -g com.taobao.idlefish explore
搜索包含关键字的类
android hooking search classes InnerSignImpl
列出类的所有方法
android hooking list class_methods mtopsdk.security.InnerSignImpl

/*
  hook指定方法, 如果有重载会hook所有重载,如果有疑问可以看
  --dump-args : 打印参数
  --dump-backtrace : 打印调用栈
  --dump-return : 打印返回值
*/
android hooking watch class_method mtopsdk.security.InnerSignImpl.getUnifiedSign --dump-args --dump-backtrace --dump-return

# hook类的所有方法(–dump-args –dump-backtrace –dump-return 显示参数、返回值、调用栈)
android hooking watch class mtopsdk.security.InnerSignImpl --dump-args --dump-backtrace --dump-return

# 让某个方法始终返回true 设置返回值(只支持bool类型)
android hooking set return_value mtopsdk.mtop.global.SwitchConfig.isGlobalSpdySwitchOpen true

# 查看 hook 任务列表
jobs list
# 杀死任务
jobs kill [job ID]

# Spawn方式Hook
objection -g com.taobao.idlefish explore --startup-command 'android hooking set return_value mtopsdk.mtop.global.SwitchConfig.isGlobalSpdySwitchOpen true'
```

```
Java.perform(function(){
    var hook = Java.use("com.xxx.xxx");
    console.log("aa: ", hook)
    //获取成员变量
    //getFields()：获得某个类的所有的公共（public）的字段，包括父类中的字段。 
    //getDeclaredFields()：获得某个类的所有声明的字段，即包括public、private和proteced，但是不包括父类的申明字段。
    //同样类似的还有getConstructors()和getDeclaredConstructors()、getMethods()和getDeclaredMethods()，这两者分别表示获取某个类的方法、构造函数
    var members = hook.class.getDeclaredFields();
    members.forEach(function(member) {
        // 
        console.log("member: ", member);
    });  
})
```

```
# pc端
frida-ps -Ua
# 手机端的端口转发到PC端进行通信
adb forward tcp:27042 tcp:27042
adb forward tcp:27043 tcp:27043

frida -U -f com.taobao.idlefish -l "D:\project\reverse\xianyu_7.17.50\hook\xianyu_hook.js"
```

# ZenTracer

Dwarf



## 查询动态链接库

```
frida -U -f com.taobao.idlefish -l "D:\project\reverse\xianyu_7.17.50\hook\hook_RegisterNatives.js"
```

```
Java.perform(function () {
    console.log(" ========== 关闭spdy ==========");
    var SwitchConfig = Java.use('mtopsdk.mtop.global.SwitchConfig');
    SwitchConfig.isGlobalSpdySwitchOpen.overload().implementation = function () {
        return false;
    }

    // console.log(" ========== 打印InnerSignImpl成员变量1 ==========");
    // var hook = Java.use("mtopsdk.security.InnerSignImpl");
    // console.log("aa: ", hook)
    // var members = hook.class.getDeclaredFields();
    // members.forEach(function(member) {
    //     // 
    //     console.log("member: ", member);
    // }); 

    // console.log(" ========== 打印InnerSignImpl成员变量2 ==========");
    // var InnerSignImpl = Java.use('mtopsdk.security.InnerSignImpl');
    // var fields = Java.cast(InnerSignImpl.class, Java.use('java.lang.Class')).getDeclaredFields();
    // for (var i = 0; i < fields.length; i++) {
    //     var field = fields[i];
    //     field.setAccessible(true);
    //     var name = field.getName();
    //     var value = field.get(this);
    //     console.log("name:"+name+"\tvalue:"+value);
    // }

    // 替换为包含 getUnifiedSign 方法的类名
    var TargetClass = Java.use('mtopsdk.security.InnerSignImpl'); // 替换为实际类名
    // 钩住 getUnifiedSign 方法
    TargetClass.getUnifiedSign.implementation = function (hashMap1, hashMap2, str1, str2, z, str3) {
        // 打印输入参数
        // console.log("getUnifiedSign called:");
        // console.log("hashMap1: ", hashMap1.toString());
        // console.log("hashMap2: ", hashMap2.toString());
        // console.log("str1: ", str1);
        // console.log("str2: ", str2);
        // console.log("z: ", z);
        // console.log("str3: ", str3);
        // 调用原始方法
        var result = this.getUnifiedSign(hashMap1, hashMap2, str1, str2, z, str3);
        // 打印返回值
        // console.log("Return value: ", result.toString());

        // 获取 this.mUnifiedSign 的引用地址
        // console.log("mUnifiedSign reference (address): ", this.mUnifiedSign);
        var mUnifiedSignKlass = Java.cast(this.mUnifiedSign, Java.use('java.lang.Object')).$class.getField('shadow$_klass_').get(mUnifiedSign);
        
        console.log("mUnifiedSign shadow$_klass_: ", mUnifiedSignKlass);
    //     console.log(" ========== ");
    //     // var fields = Java.cast(this.getClass(),Java.use('java.lang.Class')).getDeclaredFields();
    //     //console.log(fields);
    //     for (var i = 0; i < fields.length; i++) {
    //         var field = fields[i];
    //         field.setAccessible(true);
    //         var name = field.getName();
    //         var value =field.get(this)
    //         console.log("name:"+name+"\tvalue:"+value);
    //     }
    //     console.log(" ========== ");

    //     // 返回原始方法的结果
        return result;
    };



    // 获取 SecurityGuardManager 类
    // var SecurityGuardManager = Java.use('com.alibaba.wireless.security.open.SecurityGuardManager');

    // 钩取 getInstance 方法
    // SecurityGuardManager.getInstance.implementation = function (context) {
    //     // 调用原始方法
    //     var instance = this.getInstance(context);
    //     console.log("SecurityGuardManager instance: ", instance);
    //     return instance;
    // };

    // 钩取 getInterface 方法
    // SecurityGuardManager.getInterface.implementation = function (interfaceClass) {
    //     // 调用原始方法
    //     var result = this.getInterface(interfaceClass);
        
    //     // 打印返回的对象
    //         console.log("IUnifiedSecurityComponent instance: " + result);
    //         // 获取具体的类类型
    //         var resultClass = result.getClass();
    //         // console.log("IUnifiedSecurityComponent class: ", resultClass);
        

        
    //     return result;
    // };
});

// console.log(" ========== 打印InnerSignImpl成员变量3 ==========");
// Java.choose("mtopsdk.security.InnerSignImpl", {
//     onMatch: function (instance) {
//         var classType  = instance.getClass()
//         var fields = classType.getDeclaredFields();
//         //console.log(fields);
//         for (var i = 0; i < fields.length; i++) {
//             var field = fields[i];
//             field.setAccessible(true);
//             var name = field.getName();
//             var value =field.get(instance)
//             console.log("name:"+name+"\tvalue:"+value);
//         }
//     },
//     onComplete: function () { }
// });

// console.log(" ========== 找下引用类 ==========");
// var targetClass = "com.alibaba.wireless.security.middletierplugin.d.a.a";
// var targetClass = "com.alibaba.wireless.security.securitybody.open.b";

// Java.enumerateClassLoaders({
//     onMatch: function (loader) {
//         try {
//             var iUseCls = loader.findClass(targetClass);
//             if(iUseCls){
//                 console.log("loader find: " + loader);
//             }

//         } catch (error) {
//             // console.log("Class not found in loader: " + loader + ", error: " + error);
//         }
//     }, onComplete: function () {
//     }
// });
```

```
function find_RegisterNatives(params) {
    let symbols = Module.enumerateSymbolsSync("libart.so");
    let addrRegisterNatives = null;
    for (let i = 0; i < symbols.length; i++) {
        let symbol = symbols[i];
        
        //_ZN3art3JNI15RegisterNativesEP7_JNIEnvP7_jclassPK15JNINativeMethodi
        if (symbol.name.indexOf("art") >= 0 &&
                symbol.name.indexOf("JNI") >= 0 && 
                symbol.name.indexOf("RegisterNatives") >= 0 && 
                symbol.name.indexOf("CheckJNI") < 0) {
            addrRegisterNatives = symbol.address;
            // console.log("RegisterNatives is at ", symbol.address, symbol.name);
            hook_RegisterNatives(addrRegisterNatives)
        }
    }

}

function hook_RegisterNatives(addrRegisterNatives) {

    if (addrRegisterNatives != null) {
        Interceptor.attach(addrRegisterNatives, {
            onEnter: function (args) {
                // console.log("[RegisterNatives] method_count:", args[3]);
                let java_class = args[1];
                let class_name = Java.vm.tryGetEnv().getClassName(java_class);
                //console.log(class_name);
                // 只有类名为com.alibaba.wireless.security.SecExceptionCode，才打印输出
                var taget_class = "wireless";
                if(class_name.indexOf(taget_class) > 0){
                    let methods_ptr = ptr(args[2]);

                    let method_count = parseInt(args[3]);
                    for (let i = 0; i < method_count; i++) {
                        let name_ptr = Memory.readPointer(methods_ptr.add(i * Process.pointerSize * 3));
                        let sig_ptr = Memory.readPointer(methods_ptr.add(i * Process.pointerSize * 3 + Process.pointerSize));
                        let fnPtr_ptr = Memory.readPointer(methods_ptr.add(i * Process.pointerSize * 3 + Process.pointerSize * 2));
    
                        let name = Memory.readCString(name_ptr);
                        let sig = Memory.readCString(sig_ptr);
                        let symbol = DebugSymbol.fromAddress(fnPtr_ptr)
                        console.log("[RegisterNatives] java_class:", class_name, "name:", name, "sig:", sig, "fnPtr:", fnPtr_ptr,  " fnOffset:", symbol, " callee:", DebugSymbol.fromAddress(this.returnAddress));
                    }
                }
            }
        });
    }
}

setImmediate(find_RegisterNatives);
```

放弃

## 参考文章

1. [《安卓逆向这档事》五、1000-7=？&动态调试&Log插桩](https://www.52pojie.cn/forum.php?mod=viewthread&tid=1714727&highlight=%B6%AF%CC%AC%B5%F7%CA%D4)
2. [闲鱼App逆向2：接口参数分析](https://www.faithlv.top/archives/1698470682334)
3. [某鱼App加密参数x-sign生成教程](https://www.cnblogs.com/Summi/p/14491818.html)
4. [探寻闲鱼SellerId加解密算法(2) ——还原C代码](https://blog.csdn.net/John_Lenon/article/details/135648873)

