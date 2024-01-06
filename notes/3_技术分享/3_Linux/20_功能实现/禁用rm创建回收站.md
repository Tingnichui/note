```
vim ~/.bashrc
```

在文件尾部，我们添加以下几句代码：

```bash
mkdir -p ~/.trash
alias rm=trash
alias r=trash
alias rl='ls ~/.trash/'
alias ur=undelfile

undelfile()
{
    mv -i ~/.trash/$@ ./
}

trash()
{
    mv -i $@ ~/.trash/
}

cleartrash()
{
    read -p "clear sure?[n]" confirm
    [ $confirm == 'y' ] || [ $confirm == 'Y' ] && /bin/rm -rf ~/.trash/*
}
```

生效

```shell
source ~/.bashrc 
```

https://www.linuxprobe.com/rm-chance-back.html