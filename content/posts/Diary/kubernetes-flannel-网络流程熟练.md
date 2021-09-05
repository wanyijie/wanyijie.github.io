---
summary: "ip netns, docker 把容器网络命名空间隐藏起来了，查看容器网络需要把对应的网络命名空间显示出来"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
1. pod IP 
docker 把容器网络命名空间隐藏起来了，查看容器网络需要把对应的网络命名空间显示出来：
容器Id:10316  
把容器网络命名空间链接到主机,这样主机就可以管理容器网络
 ```ln -s /proc/10316/ns/net  /var/run/netns/10316```
查看网络命名空间
``` ip netns```
在网络命名空间内执行命令
```
[root@k8s01 ~]# ip netns exec 10316 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: eth0@if40: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP 
    link/ether 0a:58:0a:f4:02:f6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.2.246/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::885b:baff:fed8:f556/64 scope link tentative dadfailed 
       valid_lft forever preferred_lft forever
[root@k8s01 ~]# ip netns exec 10316 ip route
default via 10.244.2.1 dev eth0 
10.244.0.0/16 via 10.244.2.1 dev eth0 
10.244.2.0/24 dev eth0 proto kernel scope link src 10.244.2.246
```
看到与容器网卡对接的主机网卡
```
[root@k8s01 ~]# ip netns exec 10316 ethtool -S eth0
NIC statistics:
     peer_ifindex: 40
[root@k8s01 ~]# ip link show | grep   ^40:
40: vethfac0226a@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP mode DEFAULT
```
flannel网络和网络插件；
```
10: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN 
    link/ether de:a4:50:24:9d:11 brd ff:ff:ff:ff:ff:ff
    inet 10.244.2.0/32 scope global flannel.1
       valid_lft forever preferred_lft forever
    inet6 fe80::dca4:50ff:fe24:9d11/64 scope link 
       valid_lft forever preferred_lft forever
11: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP qlen 1000
    link/ether 0a:58:0a:f4:02:01 brd ff:ff:ff:ff:ff:ff
    inet 10.244.2.1/24 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::4c4c:4bff:fe34:c300/64 scope link 
       valid_lft forever preferred_lft forever

```
主机路由：
```
[root@k8s01 ~]# ip route show
default via 172.20.10.254 dev ens32 proto static metric 100 
10.244.0.0/24 via 10.244.0.0 dev flannel.1 onlink 
10.244.1.0/24 via 10.244.1.0 dev flannel.1 onlink 
10.244.2.0/24 dev cni0 proto kernel scope link src 10.244.2.1 
10.244.3.0/24 via 10.244.3.0 dev flannel.1 onlink 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 
172.20.0.0/16 dev ens32 proto kernel scope link src 172.20.8.1 metric 100
```
