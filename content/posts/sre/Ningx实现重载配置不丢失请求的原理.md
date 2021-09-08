---
summary: "nginx启动时，会启动两个进程： 一个是Master进程和worker进程。改变了nginx配置之后，HUP signal的信号需要发送给主进程"
tags:
    - wangyijie
    - develop
categories:
    - SRE
---
## 前言
nginx启动时，会启动两个进程： 一个是Master进程和worker进程。
## 改变配置后nginx做的事
1）改变了nginx配置之后，HUP signal的信号需要发送给主进程。
2）主进程首先会检测新配置的语法有效性。
3）尝试应用新的配置
1.打开日志文件，并且新分配一个socket来监听。
2.如果1失败，则回滚改变，还是会使用原有的配置。
3.如果1成功，则使用新的配置，新建一个线程。新建成功后发送一个关闭消息给旧的进程。要求旧线程优雅的关闭。
4.旧的线程 受到信号后会继续服务，当所有请求的客户端被服务后，旧线程关闭。
————————————————
修改配置后使用如下命令生效配置
nginx -s reload
![nginx.png](https://upload-images.jianshu.io/upload_images/6000429-ad20d846fea745b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
