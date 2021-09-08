---
title: "Wal日志文件名命规则"
date: 2021-09-08T15:52:01+08:00
summary: "我们看到的wal日志是这样的：000000010000000200000092
，其中前8位:00000001表示timeline，中间8位：00000002表示logid，最后8位：00000092表示logseg"
tags:
    - wangyijie
    - database
    - postgresql
categories:
    - Development
    - Opetration
---

## wal日志文件命名规则：
    我们看到的wal日志是这样的：000000010000000200000092
        • 其中前8位:00000001表示timeline；
        • 中间8位：00000002表示logid；
    最后8位：00000092表示logseg