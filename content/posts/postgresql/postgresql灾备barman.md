---
title: "Postgresql 灾备 barman"
date: 2021-09-08T17:22:27+08:00
summary: "如果pam服务故障不能再启动，应用最后一次备份恢复包含故障前最新的数据，最后一个不完整日志仍然在streaming目录下，要应用最后这一段日志的数据，需要在执行恢复后启动pg前，把最后一段日志复制到恢复pg实列的pg_wals下，并且去掉.partial后缀"
tags:
    - wangyijie
    - postgresql
    - database
categories:
    - Development
    - Opetration
---

# 项目地址
[https://github.com/EnterpriseDB/barman](https://github.com/EnterpriseDB/barman)

# barman备份相关目录介绍
    默认备份地址： /var/lib/barman
    服务器名称： 列如streaming
    基础备份目录： /var/lib/barman/streaming/base
    wal日志目录：/var/lib/barman/streaming/wals
    实时接收wal目录：/var/lib/barman/streaming/streaming
    
# 关键总结
    1、确认Barman 退出的时候是否可以自动归档。
    退出时不能自动归档，重启备份服务器可以继续备份，单机不影响归档。开启ha时由于主备切换会改变时间线，使用切换前的备份做恢复时默认只会应用当前时间线的日志，只把数据恢复到切换前，并且最后一个日志文件由于记录不完整带有.partial后缀，这个文件是可用的，如果要应用里面的日志需要把.partial后缀去掉。 如果需要恢复到切换后的数据，需要在恢复命令中指定新的时间线，如下面命令的target-tli参数
    2、如果pam服务故障不能再启动，应用最后一次备份恢复包含故障前最新的数据，最后一个不完整日志仍然在streaming目录下，要应用最后这一段日志的数据，需要在执行恢复后启动pg前，把最后一段日志复制到恢复pg实列的pg_wals下，并且去掉.partial后缀