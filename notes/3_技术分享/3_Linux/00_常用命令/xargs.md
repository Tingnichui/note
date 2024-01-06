> **xargs 命令** 是给其他命令传递参数的一个过滤器，也是组合多个命令的一个工具。它擅长将标准输入数据转换成命令行参数，xargs 能够处理管道或者 stdin 并将其转换成特定命令的命令参数。xargs 也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行。xargs 的默认命令是 echo，空格是默认定界符。这意味着通过管道传递给 xargs 的输入将会包含换行和空白，不过通过 xargs 的处理，换行和空白将被空格取代。xargs 是构建单行命令的重要组件之一。

格式

```shell
xargs [ option ] ... [ command [ initial-arguments ] ... ]
```

#### 使用 -n 进行多行输出

**-n 选项** 多行输出：

```shell
cat test.txt | xargs -n3

a b c
d e f
g h i
j k l
m n o
p q r
s t u
v w x
y z
```

####  使用 -d 分割输入

**-d 选项** 可以自定义一个定界符：

```shell
echo "nameXnameXnameXname" | xargs -dX

name name name name
```

结合 **-n 选项** 使用：

```shell
echo "nameXnameXnameXname" | xargs -dX -n2

name name
name name
```

#### 使用 -I 指定一个替换字符串{}

使用 -I 指定一个替换字符串{}，这个字符串在 xargs 扩展时会被替换掉，当 -I 与 xargs 结合使用，每一个参数命令都会被执行一次：

```shell
[root@iZm5e9felqzdvjty89ba2rZ ~]# docker ps -aq | xargs -I id  echo 'id + 'test''
f7c4a83cd891 + test
de2fa7c74877 + test
ac63331b696a + test
[root@iZm5e9felqzdvjty89ba2rZ ~]# docker ps -aq | xargs -I {}  echo '{} + 'test''
f7c4a83cd891 + test
de2fa7c74877 + test
ac63331b696a + test
[root@iZm5e9felqzdvjty89ba2rZ ~]# docker ps -aq | xargs -I {}  echo {} + 'test'
f7c4a83cd891 + test
de2fa7c74877 + test
ac63331b696a + test
```

- `docker ps -aq` 结合管道符表示将文件 容器id 交给命令 `xargs` ，需要注意的是，此时 xargs 使用换行符来分隔文件中的内容，此时并不使用空格；id
- ` xargs -I id` 表示 `xargs` 得到的每一个输出都以 `id` 传递给后续的 `echo` 命令；
- `echo 'id + 'test''` 中的 `id` 都会被进行对应的替换。

#### 打印出执行的命令

结合 `-t` 选项可以打印出 `xargs` 执行的命令

```shell
ls | xargs -t -I{} echo {}
```

#### 使用 -p 选项确认执行的命令

`-p` 选项会在执行每一个命令时弹出确认，当你需要非常准确的确认每一次操作时可以使用 `-p` 参数，比如，查找当前目录下 `.log` 文件，每一次删除都需要确认：

```
find . -maxdepth 1 -name "*.log" | xargs -p -I{} rm {}
```

#### 执行多个命令

使用 `-I` 选项可以让 `xargs` 执行多个命令

```shell
cat foo.txt
one
two
three

cat foo.txt | xargs -I % sh -c 'echo %; mkdir %'
one
two
three

ls
one two three
```

主要是`sh -c` 表示创建一个子 shell ，且 `-c` 的选项表示从命令行读取命令；

#### -0 参数与 find 命令

由于`xargs`默认将空格作为分隔符，所以不太适合处理文件名，因为文件名可能包含空格。

`find`命令有一个特别的参数`-print0`，指定输出的文件列表以`null`分隔。然后，`xargs`命令的`-0`参数表示用`null`当作分隔符。

```shell
find /path -type f -print0 | xargs -0 rm
```

上面命令删除`/path`路径下的所有文件。由于分隔符是`null`，所以处理包含空格的文件名，也不会报错。

还有一个原因，使得`xargs`特别适合`find`命令。有些命令（比如`rm`）一旦参数过多会报错"参数列表过长"，而无法执行，改用`xargs`就没有这个问题，因为它对每个参数执行一次命令。

```shell
find . -name "*.txt" | xargs grep "abc"
```

上面命令找出所有 TXT 文件以后，对每个文件搜索一次是否包含字符串`abc`。

**xargs 结合 find 使用**

用 rm 删除太多的文件时候，可能得到一个错误信息：`/bin/rm Argument list too long`. 用 `xargs` 去避免这个问题：

```shell
find . -type f -name "*.log" -print0 | xargs -0 rm -f
```

xargs -0 将 `\0` 作为定界符。

统计一个源代码目录中所有 php 文件的行数：

```shell
find . -type f -name "*.php" -print0 | xargs -0 wc -l
```

查找所有的 jpg 文件，并且压缩它们：

```shell
find . -type f -name "*.jpg" -print | xargs tar -czvf images.tar.gz
```

## 参考文章：

1. https://wangchujiang.com/linux-command/c/xargs.html
2. https://zhuanlan.zhihu.com/p/556154777
3. http://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html
