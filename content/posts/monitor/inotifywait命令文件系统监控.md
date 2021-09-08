---
summary: "inotify可以对linux 文件系统进行高效性、细粒度、异步的监控，用于通知用户控件程序的文件系统变化。inotify可以监控文件，也可以监控目录，配合rsync实现文件的实时同步功能"
tags:
    - wangyijie
    - monitor
categories:
    - Opetration
---
　inotify可以对linux 文件系统进行高效性、细粒度、异步的监控，用于通知用户控件程序的文件系统变化。inotify可以监控文件，也可以监控目录，配合rsync实现文件的实时同步功能。

　　首先安装inotify软件，先检查自己的系统版本（uname -r），我的是centos 7的系统，我的步骤是

　　　　1、首先检查自己的电脑是否已经安装了这个软件。  rpm -qa inotify-tools

　　　　2、检查仓库中是否有这个软件。  yum search inotify-tools

　　　　3、发现这个软件不在yum仓库中，安装对应的epel源。

　　　　　　　　wget -O /etc/yum.repos.d/epel-7.repo  http://mirrors.aliyun.com/repo/epel-7.repo

　　　　　　　　yum clean all

　　　　　　　　yum makecache

　　　　4、安装inotify-tools软件

　　　　　　　　yum install inotify-tools -y

　　　　5、查看inotifywait的简单用法

[root@nfs01 data]# inotifywait -mrq -e 'create,delete,close_write,attrib,moved_to' --timefmt '%Y-%m-%d %H:%M' --format '%T %w%f %e' /backup/
2019-06-04 10:46 /backup/test.txt CREATE
2019-06-04 10:46 /backup/test.txt ATTRIB
2019-06-04 10:46 /backup/test.txt CLOSE_WRITE,CLOSE
2019-06-04 10:47 /backup/test.txt CLOSE_WRITE,CLOSE
2019-06-04 10:47 /backup/isr DELETE
2019-06-04 10:47 /backup/me MOVED_TO
