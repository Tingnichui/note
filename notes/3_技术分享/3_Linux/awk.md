awk命令格式和选项

```shell
awk [options] 'script' var=value file(s)
awk [options] -f scriptfile var=value file(s)
```

常用命令选项

- **-F fs** fs指定输入分隔符，fs可以是字符串或正则表达式，如-F:，默认的分隔符是连续的空格或制表符

  默认的字段定界符是空格，可以使用`-F "定界符"` 明确指定一个定界符：

  ```shell
  awk -F: '{ print $NF }' /etc/passwd
  # 或
  awk 'BEGIN{ FS=":" } { print $NF }' /etc/passwd
  ```

  在`BEGIN语句块`中则可以用`OFS=“定界符”`设置输出字段的定界符。

- **-v var=value** 赋值一个用户定义变量，将外部变量传递给awk

- **-f scripfile** 从脚本文件中读取awk命令

- **-m[fr] val** 对val值设置内在限制，-mf选项限制分配给val的最大块数目；-mr选项限制记录的最大数目。这两个功能是Bell实验室版awk的扩展功能，在标准awk中不适用。

## 常用



![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/031917_1155_4.png)

$0 表示显示整行 ，$NF表示当前行分割后的最后一列（$0和$NF均为内置变量）

注意，$NF 和 NF 要表达的意思是不一样的，对于awk来说，$NF表示最后一个字段，NF表示当前行被分隔符切开以后，一共有几个字段。

也就是说，假如一行文本被空格分成了7段，那么NF的值就是7，$NF的值就是$7,  而$7表示当前行的第7个字段，也就是最后一列，那么每行的倒数第二列可以写为$(NF-1)。

```
awk '{print $1,$2,$NF,$(NF-1),"test",666}'
```



## 基本结构

```shell
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file
```

一个awk脚本通常由：BEGIN语句块、能够使用模式匹配的通用语句块、END语句块3部分组成，这三个部分是可选的。任意一个部分都可以不出现在脚本中，脚本通常是被 **单引号** 中，例如：

```shell
awk 'BEGIN{ i=0 } { i++ } END{ print i }' filename
```

## 工作原理

```shell
awk 'BEGIN{ commands } pattern{ commands } END{ commands }'
```

- 第一步：执行`BEGIN{ commands }`语句块中的语句；
- 第二步：从文件或标准输入(stdin)读取一行，然后执行`pattern{ commands }`语句块，它逐行扫描文件，从第一行到最后一行重复这个过程，直到文件全部被读取完毕。
- 第三步：当读至输入流末尾时，执行`END{ commands }`语句块。

**BEGIN语句块** 在awk开始从输入流中读取行 **之前** 被执行，这是一个可选的语句块，比如变量初始化、打印输出表格的表头等语句通常可以写在BEGIN语句块中。

**END语句块** 在awk从输入流中读取完所有的行 **之后** 即被执行，比如打印所有行的分析结果这类信息汇总都是在END语句块中完成，它也是一个可选语句块。

**pattern语句块** 中的通用命令是最重要的部分，它也是可选的。如果没有提供pattern语句块，则默认执行`{ print }`，即打印每一个读取到的行，awk读取的每一行都会执行该语句块。

**示例**

```shell
echo -e "A line 1\nA line 2" | awk 'BEGIN{ print "Start" } { print } END{ print "End" }'
Start
A line 1
A line 2
End
```

当使用不带参数的`print`时，它就打印当前行，当`print`的参数是以逗号进行分隔时，打印时则以空格作为定界符。在awk的print语句块中双引号是被当作拼接符使用，例如：

```shell
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3; }' 
v1 v2 v3
```

双引号拼接使用：

```shell
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1"="var2"="var3; }'
v1=v2=v3
```

{ }类似一个循环体，会对文件中的每一行进行迭代，通常变量初始化语句（如：i=0）以及打印文件头部的语句放入BEGIN语句块中，将打印的结果等语句放在END语句块中。

## awk内置变量（预定义变量）

说明：\[A\]\[N\]\[P\]\[G\]表示第一个支持变量的工具，[A]=awk、[N]=nawk、[P]=POSIXawk、[G]=gawk

```shell
 **$n**  当前记录的第n个字段，比如n为1表示第一个字段，n为2表示第二个字段。 
 **$0**  这个变量包含执行过程中当前行的文本内容。
[N]  **ARGC**  命令行参数的数目。
[G]  **ARGIND**  命令行中当前文件的位置（从0开始算）。
[N]  **ARGV**  包含命令行参数的数组。
[G]  **CONVFMT**  数字转换格式（默认值为%.6g）。
[P]  **ENVIRON**  环境变量关联数组。
[N]  **ERRNO**  最后一个系统错误的描述。
[G]  **FIELDWIDTHS**  字段宽度列表（用空格键分隔）。
[A]  **FILENAME**  当前输入文件的名。
[P]  **FNR**  同NR，但相对于当前文件。
[A]  **FS**  字段分隔符（默认是任何空格）。
[G]  **IGNORECASE**  如果为真，则进行忽略大小写的匹配。
[A]  **NF**  表示字段数，在执行过程中对应于当前的字段数。
[A]  **NR**  表示记录数，在执行过程中对应于当前的行号。
[A]  **OFMT**  数字的输出格式（默认值是%.6g）。
[A]  **OFS**  输出字段分隔符（默认值是一个空格）。
[A]  **ORS**  输出记录分隔符（默认值是一个换行符）。
[A]  **RS**  记录分隔符（默认是一个换行符）。
[N]  **RSTART**  由match函数所匹配的字符串的第一个位置。
[N]  **RLENGTH**  由match函数所匹配的字符串的长度。
[N]  **SUBSEP**  数组下标分隔符（默认值是34）。
```

转义序列

```
\\ \自身
\$ 转义$
\t 制表符
\b 退格符
\r 回车符
\n 换行符
\c 取消换行
```

**示例**

```shell
echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{print "Line No:"NR", No of fields:"NF, "$0="$0, "$1="$1, "$2="$2, "$3="$3}' 
Line No:1, No of fields:3 $0=line1 f2 f3 $1=line1 $2=f2 $3=f3
Line No:2, No of fields:3 $0=line2 f4 f5 $1=line2 $2=f4 $3=f5
Line No:3, No of fields:3 $0=line3 f6 f7 $1=line3 $2=f6 $3=f7
```

使用`print $NF`可以打印出一行中的最后一个字段，使用`$(NF-1)`则是打印倒数第二个字段，其他以此类推：

```shell
echo -e "line1 f2 f3\n line2 f4 f5" | awk '{print $NF}'
f3
f5
echo -e "line1 f2 f3\n line2 f4 f5" | awk '{print $(NF-1)}'
f2
f4
```

打印每一行的第二和第三个字段：

```shell
awk '{ print $2,$3 }' filename
```

统计文件中的行数：

```shell
awk 'END{ print NR }' filename
```

以上命令只使用了END语句块，在读入每一行的时，awk会将NR更新为对应的行号，当到达最后一行NR的值就是最后一行的行号，所以END语句块中的NR就是文件的行数。

一个每一行中第一个字段值累加的例子：

```shell
# seq 5 这个命令会生成从1到5的序列。输出结果为 1\n 2\n 3\n 4\n 5\n
seq 5 | awk 'BEGIN{ sum=0; print "总和：" } { print $1"+"; sum+=$1 } END{ print "等于"; print sum }' 
总和：
1+
2+
3+
4+
5+
等于
15
```

##  将外部变量值传递给awk

借助 **`-v`选项** ，可以将外部值（并非来自stdin）传递给awk：

```shell
VAR=10000
echo | awk -v VARIABLE=$VAR '{ print VARIABLE }'
```

另一种传递外部变量方法：

```shell
var1="aaa"
var2="bbb"
echo | awk '{ print v1,v2 }' v1=$var1 v2=$var2
```

当输入来自于文件时使用：

```shell
awk '{ print v1,v2 }' v1=$var1 v2=$var2 filename
```

以上方法中，变量之间用空格分隔作为awk的命令行参数跟随在BEGIN、{}和END语句块之后。

## 查找进程pid

```shell
netstat -antup | grep 7770 | awk '{ print $NF NR}' | awk '{ print $1}'
```

## awk高级输入输出

### 读取下一条记录

awk中`next`语句使用：在循环逐行匹配，如果遇到next，就会跳过当前行，直接忽略下面语句。而进行下一行匹配。next语句一般用于多行合并：

```shell
cat text.txt
a
b
c
d
e

awk 'NR%2==1{next}{print NR,$0;}' text.txt
2 b
4 d
```

当记录行号除以2余1，就跳过当前行。下面的`print NR,$0`也不会执行。下一行开始，程序有开始判断`NR%2`值。这个时候记录行号是`：2` ，就会执行下面语句块：`'print NR,$0'`

分析发现需要将包含有“web”行进行跳过，然后需要将内容与下面行合并为一行：

```shell
cat text.txt
web01[192.168.2.100]
httpd            ok
tomcat               ok
sendmail               ok
web02[192.168.2.101]
httpd            ok
postfix               ok
web03[192.168.2.102]
mysqld            ok
httpd               ok
0
awk '/^web/{T=$0;next;}{print T":"t,$0;}' text.txt
web01[192.168.2.100]:   httpd            ok
web01[192.168.2.100]:   tomcat               ok
web01[192.168.2.100]:   sendmail               ok
web02[192.168.2.101]:   httpd            ok
web02[192.168.2.101]:   postfix               ok
web03[192.168.2.102]:   mysqld            ok
web03[192.168.2.102]:   httpd               ok
```

## 参考文章

1. [awk](https://wangchujiang.com/linux-command/c/awk.html)
1. [awk从放弃到入门（1）：awk基础 （通俗易懂，快进来看）](https://www.zsythink.net/archives/1336)