---
summary: "RDS 默认管理员也没有super权限，数据库在执行DDL语句时没有super权限是不能结束进程会报异常"
tags:
    - wangyijie
    - database
categories:
    - Development
    - Opetration
    - database
---
RDS 默认管理员也没有super权限，数据库在执行DDL语句时没有super权限是不能结束进程会报异常：
```   
 you are not owner for thread *******
```
![image.png](https://upload-images.jianshu.io/upload_images/6000429-46c0d1ff550e8f71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
show 不是sql语句也不能处理输出，很多连接的时候我想到想到是使用excel来生成结束进程的kill命令，关键在于一个函数：在一单元格前后加上字符：
```
="kill "&B2&";"
```
![image.png](https://upload-images.jianshu.io/upload_images/6000429-655be58e328d14ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
