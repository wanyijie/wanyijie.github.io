---
summary: "对于那些想上网的人来说这很方便 - 你可以在一个命令中将任何Linux计算机变成SOCKS5（和SOCKS4）代理"
tags:
    - wangyijie
    - network
categories:
    - Opetration
---
对于那些想上网的人来说这很方便 - 你可以在一个命令中将任何Linux计算机变成SOCKS5（和SOCKS4）代理：  
```
ssh -N -D 0.0.0.0:1080 user@ip
```
并且它不需要root权限。该ssh命令启动-D端口上的动态端口转发，1080并通过SOCSK5或SOCKS4协议与客户端通信，就像常规的SOCKS5代理一样！该-N选项确保ssh保持空闲状态，并且不在主机上执行任何命令。0.0.0.0允许任意地址连接，设置为127.0.0.1可以限制本机之外的主机使用代理，ip可以是远程代理主机，也可以是本机相当于把本机做为代理服务器

如果您还希望命令作为守护进程进入后台，则添加-f选项：
```
ssh -f -N -D 0.0.0.0:1080 user@ip
```
要使用它，只需让您的软件在您的Linux计算机的IP，端口1080上使用SOCKS5代理，并且您已完成，您的所有请求现在都会被代理.

访问控制可以通过实现iptables。例如，要仅允许来自ip的1.2.3.4人员使用SOCKS5代理，请添加以下iptables规则：
```
iptables -A INPUT --src 1.2.3.4 -p tcp --dport 1080 -j ACCEPT
iptables -A INPUT -p tcp --dport 1080 -j REJECT
```
第一条规则说，允许任何人1.2.3.4连接到端口1080，另一条规则说，拒绝其他所有人连接到端口1080。
