iptables中的“四表五链”及“堵通策略”

A.“四表”是指，iptables的功能——filter, nat, mangle, raw.

filter, 控制数据包是否允许进出及转发（INPUT、OUTPUT、FORWARD）,可以控制的链路有input, forward, output

nat, 控制数据包中[地址转换](https://so.csdn.net/so/search?q=地址转换&spm=1001.2101.3001.7020)，可以控制的链路有prerouting, input, output, postrouting

mangle,修改数据包中的原数据，可以控制的链路有prerouting, input, forward, output, postrouting

raw,控制nat表中连接追踪机制的启用状况，可以控制的链路有prerouting, output

注：在centos7中，还有security表，不过这里不作介绍

B.“五链”是指内核中控制网络的[NetFilter](https://so.csdn.net/so/search?q=NetFilter&spm=1001.2101.3001.7020)定义的五个规则链，分别为

PREROUTING, 路由前

INPUT, 数据包流入口

FORWARD, 转发管卡

OUTPUT, 数据包出口

POSTROUTING, 路由后

C.堵通策略是指对数据包所做的操作，一般有两种操作——“通（ACCEPT）”、“堵（DROP）”，还有一种操作很常见REJECT.

谈谈REJECT和DROP之间的区别，Ming写了一封信，向Rose示爱。Rose如果不愿意接受，她可以不回应Ming,这个时候Ming不确定Rose是否接到了信；Rose也可以同样写一封信，在信中明确地拒绝Ming。前一种操作就如同执行了DROP操作，而后一种操作就如同REJECT操作。





语法

```shell
iptables [-t table] COMMAND [chain] CRETIRIA -j ACTION
```

-t table，是指操作的表，filter、nat、mangle或raw, 默认使用filter

COMMAND，子命令，定义对规则的管理

chain, 指明链路

CRETIRIA, 匹配的条件或标准

ACTION,操作动作

链管理

-N, --new-chain chain：新建一个自定义的规则链；

-X, --delete-chain [chain]：删除用户自定义的引用计数为0的空链；

-F, --flush [chain]：清空指定的规则链上的规则；

-E, --rename-chain old-chain new-chain：重命名链；

-Z, --zero [chain [rulenum]]：置零计数器；

-P, --policy chain target， 设置链路的默认策略

规则管理

-A, --append chain rule-specification：追加新规则于指定链的尾部；

-I, --insert chain [rulenum] rule-specification：插入新规则于指定链的指定位置，默认为首部；

-R, --replace chain rulenum rule-specification：替换指定的规则为新的规则；

-D, --delete chain rulenum：根据规则编号删除规则；

查看规则

-L, --list [chain]：列出规则；

-v, --verbose：详细信息；

-vv， -vvv 更加详细的信息
　　-n, --numeric：数字格式显示主机地址和端口号；

-x, --exact：显示计数器的精确值；

–line-numbers：列出规则时，显示其在链上的相应的编号；

-S, --list-rules [chain]：显示指定链的所有规则



匹配条件

通用匹配条件

[!] -s, --source address[/mask][,…]：检查报文的源IP地址是否符合此处指定的范围，或是否等于此处给定的地址；

[!] -d, --destination address[/mask][,…]：检查报文的目标IP地址是否符合此处指定的范围，或是否等于此处给定的地址；

[!] -p, --protocol protocol：匹配报文中的协议，可用值tcp, udp, udplite, icmp, icmpv6,esp, ah, sctp, mh 或者 “all”, 亦可以数字格式指明协议；
[!] -i, --in-interface name：限定报文仅能够从指定的接口流入；only for packets entering the INPUT, FORWARD and PREROUTING chains.

[!] -o, --out-interface name：限定报文仅能够从指定的接口流出；for packets entering the FORWARD, OUTPUT and POSTROUTING chains.





```shell
iptables -I INPUT -p tcp -m tcp --dport 5140 -m state --state ESTABLISHED  -j LOG --log-level 1 --log-prefix "mysql connect "

iptables -I INPUT -p tcp -m tcp --dport 5140 -m state --state ESTABLISHED -j LOG --log-level 1 --log-prefix "logstash tcp connect "

iptables -I INPUT -p udp -m udp --dport 5140 -j LOG --log-level 1 --log-prefix "logstash udp connect "

iptables -L --line-numbers | grep logstash
```

参考文章

1. [iptables命令使用详解](https://blog.csdn.net/Hell_potato777/article/details/126771293)
2. https://blog.csdn.net/qq_40265822/article/details/124998123

