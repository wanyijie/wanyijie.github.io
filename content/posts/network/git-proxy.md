---
title: "Git Proxy"
date: 2021-09-05T11:58:13+08:00
draft: true
summary: "git 仓库配置使用 shadowsocks 代理, git config https.proxy 'socks5://127.0.0.1:1080'"
tags:
    - wangyijie
    - knowledge
    - network
categories:
    - Development
    - Opetration
---
# git 仓库配置使用 shadowsocks 代理
编辑项目中的 .git文件夹下config的 文件,加上
```
[http]
    proxy = socks5://127.0.0.1:1080
[https]
    proxy = socks5://127.0.0.1:1080
```
或使用下面命令：
```
git config http.proxy 'socks5://127.0.0.1:1080'
git config https.proxy 'socks5://127.0.0.1:1080'
```
shadowsocks 默认是 1080端口
如果是要求认证的其它代理系统：
```
git config --global http.proxy http://proxyUsername:proxyPassword@proxy.server.com:port
```
# 注意
使用 Git Push 提交代码到远程服务器时提示了一个错误
```
fatal: NotSupportedException encountered.
   ServicePointManager 不支持具有 socks5 方案的代理。
``
实际上问题是配置了本地的 socks5 的代理（Shadowsocks 之类的代理软件）
配置了远程服务器 Git 服务端的 SSH
本地提交代码到远程服务器时使用的是 http/https 协议
这三者只要有一个不满足就不会出现这个错误了,可以忽略，谁找到好的说法或解决办法请留意

[git官方配置参考](https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)