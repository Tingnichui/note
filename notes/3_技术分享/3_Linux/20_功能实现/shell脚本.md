## shell 编程有哪些注意事项

1. shell 命名：Shell脚本名称命名一般为英文、大写、小写，后缀以.sh 结尾
2. 不能使用特殊符号、空格
3. 见闻之意，名称要写的一眼可以看出功能
4. shell 编程 首行需要 #!/bin/bash 开头
5. shell 脚本 变量 不能以 数字、特殊符号开头，可以使用下划线—,但不能 用破折号 -

## shell语法初识

- 定义以开头 #!/bin/bash

  #!用来声明脚本由什么shell解释，否则使用默认shell

- 单个"#"号代表注释当前行

- 运行

  - 加上可执行权限 `chmod +x xxxx.sh`
  - 三种执行方式 （./xxx.sh bash xxx.sh . xxx.sh）
    - ./xxx.sh :先按照 文件中#!指定的解析器解析，如果#！指定指定的解析器不存在 才会使用系统默认的解析器
    - bash xxx.sh:指明先用bash解析器解析，如果bash不存在 才会使用默认解析器
    - . xxx.sh 直接使用默认解析器解析（不会执行第一行的#！指定的解析器）但是第一行还是要写的

## 变量

> 1. 变量名只能包含英文字母下划线，不能以数字开头，首个字符必须为字母（a-z，A-Z），不能以数字开头，中间不能有空格，可以使用下划线（_），不能使用（-），也不能使用标点符号等
>    - 1_num=10 错误
>    - num_1=20 正确
> 2. 等号两边不能直接接空格符，若变量中本身就包含了空格，则整个字符串都要用双引号、或单引号括起来
> 3. 双引号 单引号的区别
>    - 双引号：可以解析变量的值
>    - 单引号：不能解析变量的值

```shell
# 定义变量
num=100
# 引用变量
echo $num
# 清除变量值
unset num
```

## read

https://wangchujiang.com/linux-command/c/read.html

从键盘获取值read

```shell
#!/bin/bash
num=
echo "start num is $num"
read -p '输入数字：' num
echo "read num is $num"
```

## source

https://wangchujiang.com/linux-command/c/source.html

在当前Shell环境中从指定文件读取和执行命令。

用途：执行文件并从文件中加载变量及函数到执行环境

## 预设变量

![在这里插入图片描述](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/20200420213544763.png)

### 脚本标量的特殊用法

![在这里插入图片描述](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/2020042021540169.png)

## 变量的扩展

### 判断变量是否存在

```
#!/bin/bash
# ${num：—val} 如果num存在，整个表达式的值为num，否则为val
echo ${num:-100} #100
echo "num=$num" #
num=200
echo ${num:-100} #200 
```

```
#!/bin/bash
# ${num:=val} 如果num存在，整个表达式的值为num，否则为val，同时将num的值赋值为val
echo ${num:=100} #100
echo "num=$num" #100
```

\- 与 = 的区别在于num不存在时，会不会给变量赋值

### 字符串的操作

```
1 #!/bin/bash
str="hehe:haha:xixi:lala" # 测量字符串的长度${#str} 
echo "str的长度为：${#str}" #19 
# 从下标3为位置提取${str：3}
echo ${str:3} # "e:haha:xixi:lala"
# 从下标为3的位置提取长度为6字节
echo ${str:3:6} # "e:haha"
# ${str/old/new} 用new替换str中出现的第一个old
echo ${str/:/#} # "hehe#haha:xixi:lala
# ${str//old/new} 用new替换str中所有的old
echo ${str//:/#} #"hehe#haha#xixi#lala"
```

## 条件测试

> test命令，执行条件表达式。
>
> test命令有两种格式：test condition 或 [ condition ]，使用方括号时，要注意在条件两边加上空格。
>
> 如果表达式执行结果为成功时返回0，当表达式执行结果为失败或给出非法参数时返回1。

https://wangchujiang.com/linux-command/c/test.html

## 符合语句测试

## 控制语句

> if case for while until break

### if

```shell
格式一：
if [条件1]; then
    执行第一段程序
else
    执行第二段程序
fi
格式二：
if [条件1]; then
    执行第一段程序
elif [条件2]；then
	执行第二段程序
else
    执行第三段程序
fi
```

### case

```
#Case选择语句，主要用于对多个选择条件进行匹配输出，与if elif语句结构类似，通常用于脚本传递输入参数，打印出输出结果及内容，其语法格式以Case…in开头，esac结尾。语法格式如下：
case $模式名  in
  模式 1)
    命令
    ;;
  模式 2)
    命令
    ;;
*)
不符合以上模式执行的命令
esac
# 每个模式必须以右括号结束，命令结尾以双分号结束。
```

### for

```shell
#格式：for name [ [ in [ word ... ] ] ; ] do list ; done
for 变量名 in 取值列表; do
  语句 1
done
```



---

## 环境变量

> 常见的3种变量 Shell编程中变量分为三种，分别是系统变量、环境变量和用户变量，Shell变量名在定义时，。

- 系统变量

  ```
  # Shell常见的变量之一系统变量，主要是用于对参数判断和命令返回值判断时使用，系统变量详解如下：
  
  $0 		当前脚本的名称；
  $n 		当前脚本的第n个参数,n=1,2,…9；
  $* 		当前脚本的所有参数(不包括程序本身)；
  $# 		当前脚本的参数个数(不包括程序本身)；
  $? 		令或程序执行完后的状态，返回0表示执行成功；
  $$ 		程序本身的PID号。
  ```

- 环境变量

  ```
  #Shell常见的变量之二环境变量，主要是在程序运行时需要设置，环境变量详解如下：
  
  PATH  		命令所示路径，以冒号为分割；
  HOME  		打印用户家目录；
  SHELL 		显示当前Shell类型；
  USER  		打印当前用户名；
  ID    		打印当前用户id信息；
  PWD   		显示当前所在路径；
  TERM  		打印当前终端类型；
  HOSTNAME    显示当前主机名；
  PS1         定义主机命令提示符的；
  HISTSIZE    历史命令大小，可通过 HISTTIMEFORMAT 变量设置命令执行时间;
  RANDOM      随机生成一个 0 至 32767 的整数;
  HOSTNAME    主机名
  ```

- 用户环境变量

  ```
  # 常见的变量之三用户变量，用户变量又称为局部变量，主要用在Shell脚本内部或者临时局部使用，系统变量详解如下：
  a=rivers 				       自定义变量A；
  Httpd_sort=httpd-2.4.6-97.tar  自定义变量N_SOFT；
  BACK_DIR=/data/backup/         自定义变量BACK_DIR；
  IPaddress=10.0.0.1			   自定义变量IP1；
  ```

## shell语句

### if

常见逻辑判断运算符

```
-f	 	判断文件是否存在 eg: if [ -f filename ]；
-d	 	判断目录是否存在 eg: if [ -d dir     ]；
-eq		等于，应用于整型比较 equal；
-ne		不等于，应用于整型比较 not equal；
-lt		小于，应用于整型比较 letter；
-gt		大于，应用于整型比较 greater；
-le		小于或等于，应用于整型比较；
-ge 	大于或等于，应用于整型比较；
-a		双方都成立（and） 逻辑表达式 –a 逻辑表达式；
-o		单方成立（or） 逻辑表达式 –o 逻辑表达式；
-z		空字符串；
-x      是否具有可执行权限
||      单方成立；
&&      双方都成立表达式。
```

## for

**语句**

```

```

## while

**语句**

```
# While循环语句与for循环功能类似，主要用于对某个数据域进行循环读取、对文件进行遍历，通常用于需要循环某个文件或者列表，满足循环条件会一直循环，不满足则退出循环，其语法格式以while…do开头，done结尾与 
#while 关联的还有一个 until 语句，它与 while 不同之处在于，是当条件表达式为 false 时才循环，实际使用中比较少，这里不再讲解。

while  (表达式)
do
  语句1
done
```

```
# break 和 continue 语句
  break 是终止循环。
  continue 是跳出当前循环。
#示例 1：在死循环中，满足条件终止循环
while true; do
  let N++
  if [ $N -eq 5 ]; then
    break
fi
  echo $N
done
输出： 1 2 3 4

#示例 2：举例子说明 continue 用法
N=0
while [ $N -lt 5 ]; do
  let N++
if [ $N -eq 3 ]; then
  continue
fi
  echo $N
done

输出： 1 2 4

# 打印 1-100 数字
i=0
while ((i<=100))
do
        echo  $i
        i=`expr $i + 1`
done
```

## select

```
#select 是一个类似于 for 循环的语句
#Select语句一般用于选择，常用于选择菜单的创建，可以配合PS3来做打印菜单的输出信息，其语法格式以select…in do开头，done结尾：

select i in （表达式） 
do
语句
done

# 选择mysql 版本
#!/bin/bash
# by author rivers on 2021-9-27
PS3="Select a number: "
while true; do
select mysql_version in 5.1 5.6 quit;
 do
  case $mysql_version in
  5.1)
    echo "mysql 5.1"
      break
      ;;
  5.6)
    echo "mysql 5.6"
       break
       ;;
  quit)
    exit
    ;;
  *)
    echo "Input error, Please enter again!"
      break
esac
 done
done
```



## 参考文章

1. [linux shell 脚本 入门到实战详解[⭐建议收藏！！⭐]](https://blog.csdn.net/weixin_42313749/article/details/120524768)
2. [shell脚本语言(超全超详细)](https://blog.csdn.net/weixin_43288201/article/details/105643692)
3. [掌握Shell编程，一篇就够了](https://www.zhihu.com/tardis/zm/art/102176365)