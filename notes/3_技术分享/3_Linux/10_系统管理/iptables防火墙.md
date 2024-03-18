## IPTABLES 结构

iptables -> Tables -> Chains -> Rules

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/1583990-20221104162420859-2031091297.png)

---

## IPTABLES 表与链

> Filter, NAT, Mangle, Raw四种内建表
>
> 五种规则链名：
>
> - **INPUT链**：处理输入数据包。
> - **OUTPUT链**：处理输出数据包。
> - **PORWARD链**：处理转发数据包。
> - **PREROUTING链**：用于目标地址转换（DNAT）。
> - **POSTOUTING链**：用于源地址转换（SNAT）。

1. **Filter表**：iptables的默认表，控制数据包是否允许进出及转发，包过滤，用于防火墙规则。
   - **INPUT** – 处理来自外部的数据。
   - **OUTPUT** – 处理向外发送的数据。
   - **FORWARD** – 将数据转发到本机的其他网卡设备上。
2. **NAT表**：控制数据包中地址转换，用于网关路由器。
   - **PREROUTING** – 处理刚到达本机并在路由转发前的数据包。它会转换数据包中的目标IP地址（destination ip address），通常用于DNAT(destination NAT)。
   - **POSTROUTING** – 处理即将离开本机的数据包。它会转换数据包中的源IP地址（source ip address），通常用于SNAT（source NAT）。
   - **OUTPUT** – 处理本机产生的数据包。
3. **Mangle表**：修改数据包中的原数据，数据包修改（QOS），用于实现服务质量。
   - PREROUTING - 路由前
   - OUTPUT - 数据包出口
   - FORWARD - 转发管卡
   - INPUT - 数据包流入口
   - POSTROUTING - 路由后
4. **Raw表**：用于处理异常，控制nat表中连接追踪机制的启用状况，高级功能，如：网址过滤。
   - PREROUTING chain
   - OUTPUT chain

---

## IPTABLES 规则(Rules)

> - Rules包括一个条件和一个目标(target)
> - 如果满足条件，就执行目标(target)中的规则或者特定值
> - 如果不满足条件，就判断下一条Rules

![image-20230809193152964](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230809193152964.png)

```shell
# 不指定 -t 选项，就只会显示默认的 filter
iptables -t filter --list --line-numbers
iptables –list
# 查看mangle表
iptables -t mangle --list --line-numbers
# 查看NAT表
iptables -t nat --list --line-numbers
# 查看RAW表
iptables -t raw --list --line-numbers
```

- num – 指定链中的规则编号
- target – 前面提到的target的特殊值
  - **ACCEPT** – 允许防火墙接收数据包
  - **DROP** – 防火墙丢弃包
  - **QUEUE** – 防火墙将数据包移交到用户空间
  - **RETURN** – 防火墙停止执行当前链中的后续Rules，并返回到调用链(the calling chain)中。
- prot – 协议：tcp, udp, icmp等
- source – 数据包的源IP地址
- destination – 数据包的目标IP地址

---

## 添加iptables规则

> iptables程序建立的规则只会保存在内存中，需要根据服务器系统保存

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/1583990-20221104162440107-421329904.png)

```
iptables [-t 表] [操作命令] [链] [规则匹配器] [-j 目标动作]
```

| 表            | 说明                                               | 支持的链                        |
| :------------ | :------------------------------------------------- | :------------------------------ |
| raw           | 一般是为了不再让iptables对数据包进行跟踪，提高性能 | PREROUTING、OUTPUT              |
| mangle        | 对数据包进行修改                                   | 五个链都可以                    |
| nat           | 进行地址转换                                       | PREROUTING、OUTPUT、POSTROUTING |
| filter(默认） | 对包进行过滤                                       | INPUT、FORWARD、OUTPUT          |

| 常用操作命令 | 说明                                                         |
| :----------- | :----------------------------------------------------------- |
| -A           | 在指定链尾部添加规则                                         |
| -D           | 删除匹配的规则                                               |
| -R           | 替换匹配的规则                                               |
| -I           | 在指定位置插入规则(例：iptables -I INPUT 1 --dport 80 -j ACCEPT（将规则插入到filter表INPUT链中的第一位上）默认第一位 |
| -L/S         | 列出指定链或所有链的规则                                     |
| -F           | 删除指定链或所有链的规则                                     |
| -N           | 创建用户自定义链[例：iptables -N allowed]                    |
| -X           | 删除指定的用户自定义链                                       |
| -P           | 为指定链设置默认规则策略，对自定义链不起作用                 |
| -Z           | 将指定链或所有链的计数器清零                                 |
| -E           | 更改自定义链的名称[例：iptables -E allowed disallowed]       |
| -n           | ip地址和端口号以数字方式显示[例：iptables -nL]               |

| 常用规则匹配器        | 说明                                                         |
| :-------------------- | :----------------------------------------------------------- |
| -p tcp/udp/icmp/all   | 匹配协议，all会匹配所有协议                                  |
| -s addr[/mask]        | 匹配源地址                                                   |
| -d addr[/mask]        | 匹配目标地址                                                 |
| --sport port1[:port2] | 匹配源端口(可指定连续的端口）                                |
| --dport port1[:port2] | 匹配目的端口(可指定连续的端口）                              |
| -o interface          | 匹配出口网卡，只适用FORWARD、POSTROUTING、OUTPUT(例：iptables -A FORWARD -o eth0) |
| -i interface          | 匹配入口网卡，只使用PREROUTING、INPUT、FORWARD。             |
| --icmp-type           | 匹配icmp类型（使用iptables -p icmp -h可查看可用的ICMP类型）  |
| --tcp-flags mask comp | 匹配TCP标记，mask表示检查范围，comp表示匹配mask中的哪些标记。（例：iptables -A FORWARD -p tcp --tcp-flags ALL SYN，ACK -j ACCEPT 表示匹配SYN和ACK标记的数据包） |

| 目标动作   | 说明                                                         |
| :--------- | :----------------------------------------------------------- |
| ACCEPT     | 允许数据包通过                                               |
| DROP       | 丢弃数据包                                                   |
| REJECT     | 丢弃数据包，并且将拒绝信息发送给发送方                       |
| LOG        | 在/var/log/messages文件中记录日志信息，然后将数据包传递给下一条规则 |
| MASQUERADE | IP伪装（NAT），用于ADSL                                      |
| SNAT       | 源地址转换（在nat表上）例：iptables -t nat -A POSTROUTING -d 192.168.0.102 -j SNAT --to 192.168.0.1 |
| DNAT       | 目标地址转换（在nat表上）例：iptables -t nat -A PREROUTING -d 202.202.202.2 -j DNAT --to-destination 192.168.0.102 |
| REDIRECT   | 目标端口转换（在nat表上）例：iptables -t nat -D PREROUTING -p tcp --dport 8080 -i eth2.2 -j REDIRECT --to 80 |
| MARK       | 将数据包打上标记;例：iptables -t mangle -A PREROUTING -s 192.168.1.3 -j MARK --set-mark 60 |

除去最后一个LOG，前3条规则匹配数据包后，该数据包不会再往下继续匹配了，所以编写的规则顺序极其关键。

## 其他

**iptables -p tcp** : 表示使用 TCP协议

**iptables -m tcp**：表示使用TCP模块的扩展功能（tcp扩展模块提供了 --dport, --tcp-flags, --sync等功能）

```shell
iptables -I INPUT -p tcp -m tcp --dport 5140 -m state --state ESTABLISHED  -j LOG --log-level 1 --log-prefix "mysql connect "

iptables -I INPUT -p tcp -m tcp --dport 5140 -m state --state ESTABLISHED -j LOG --log-level 1 --log-prefix "logstash tcp connect "

iptables -I INPUT -p udp -m udp --dport 5140 -j LOG --log-level 1 --log-prefix "logstash udp connect "

iptables -L --line-numbers | grep logstash
```

## 参考命令

```bash
# 将3306端口的数据转发到120.77.182.143  不生效
iptables -t nat -A PREROUTING -p tcp --dport  3306 -j DNAT --to-destination 120.77.182.143

iptables -t nat -A PREROUTING -p tcp --dport 3306 -j DNAT --to-destination 18.222.236.211:3306
iptables -t nat -A POSTROUTING -p tcp -d 18.222.236.211 --dport 8017 -j SNAT --to-source 120.79.131.118
```



## 参考文章

1. [iptables基础知识详解](https://blog.csdn.net/u011537073/article/details/82685586)
2. [IPTABLES 详解](https://www.cnblogs.com/my-show-time/p/16858254.html)
3. [iptables命令使用详解](https://blog.csdn.net/Hell_potato777/article/details/126771293)
4. [iptables -m, -p 参数说明 ](https://www.cnblogs.com/miracle-luna/p/13718436.html)
5. https://blog.csdn.net/qq_40265822/article/details/124998123
6. [iptables做TCP/UDP端口转发【转】](https://www.cnblogs.com/paul8339/p/14688156.html)

