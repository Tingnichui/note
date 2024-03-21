```
ps -ef | grep lrb-agent
ps p 59278 -L -o pcpu,pid,tid,time,tname,cmd
ps p 59278 -L -o pcpu,pid,tid,time,tname
```

![image-20240321222039743](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222039743.png)

```
printf "%x\n" 59715
jstack -l 59278 | grep e943

```

![image-20240321222300112](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222300112.png)



```
printf "%x\n" 59718
jstack -l 59278 | grep e946
```

![image-20240321222314531](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222314531.png)





![image-20240321222641827](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321222641827.png)







![image-20240321224246926](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20240321224246926.png)