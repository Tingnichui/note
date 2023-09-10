## vim

0.更新yum

```bash
yum update
```

1.查看是否已经安装了vim

```bash
rpm -qa|grep vim
```

```bash
# 如果有以下结果输出，则已经安装了vim
vim-filesystem-7.4.160-4.el7.x86_64
vim-minimal-7.4.160-4.el7.x86_64
vim-enhanced-7.4.160-4.el7.x86_64
vim-common-7.4.160-4.el7.x86_64
```

2.安装vim

```
yum -y install vim*
```

3.配置vim

编辑配置文件

```bash
vim /etc/vimrc
```

写如以下配置

```bash
set nu          " 设置显示行号
set showmode    " 设置在命令行界面最下面显示当前模式等
set ruler       " 在右下角显示光标所在的行数等信息
set autoindent  " 设置每次单击Enter键后，光标移动到下一行时与上一行的起始字符对齐
syntax on       " 即设置语法检测，当编辑C或者Shell脚本时，关键字会用特殊颜色显示
```

参考文章

1. [Centos7安装vim](https://blog.csdn.net/qq_39329994/article/details/121487148) 