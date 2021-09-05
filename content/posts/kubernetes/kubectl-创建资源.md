---
summary: "最近去参加了CKA考试，在速度上吃亏，以往喜欢复制粘贴修改摸板，在时间紧张的情况下这种方式的效率问题暴露了，导致考试时间紧张，没用时间解决难题，考试会要求创建各种类型的资源，所以这准备练习命令创建资源，提高操作效率"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
最近去参加了CKA考试，在速度上吃亏，以往喜欢复制粘贴修改摸板，在时间紧张的情况下这种方式的效率问题暴露了，导致考试时间紧张，没用时间解决难题，考试会要求创建各种类型的资源，所以这准备练习命令创建资源，提高操作效率：
如果能从命令行直接创建符合目的的资源就直接使用，如果命令参数不满足需求，可以通过**--dry-run -o yaml** 参数输出摸板不实际创建资源，下面是各种资源的创建示列，多数可以合并使用：
1. 创建pod
加**--restart=Never**参数创建出来的资源就是pod
```yaml
kubectl run busybox  --image=busybox --dry-run  -o yaml  --restart=Never
```
2. 创建cronjob
加**--schedule=<cron>**参数创建出来的资源就是cronjob
```yaml
kubectl run busybox  --image=busybox --dry-run  -o yaml  --schedule="* * * * *"
```
3. 创建job
加**--restart=OnFailure**参数创建出来的资源就是jod
```yaml
kubectl run busybox  --image=busybox --dry-run  -o yaml  --restart=OnFailure
```
4. 创建deployment
加**--restart=Aalways**参数创建出来的资源就是pod,这是默认参数可以不指明
```yaml
kubectl run busybox  --image=busybox --dry-run  -o yaml  --restart=Aalways
```
5. 创建使用ENV:
使用 --env, 多个环境变量重复参数指定
```yaml
kubectl run nginx --image=nginx --dry-run -o yaml  --env="dir=/mnt" --env="port=80"
```
6. 创建资源限制及请求
```yaml
kubectl run nginx --image=nginx --dry-run -o yaml --limits="cpu=100m,memory=256m" --requests="cpu=100m,memory=100M"  
```
7. 创建指定label
留意对象资源和列表资源在命令行参数中的表示规律，重复使用参数，用逗号分隔
```yaml
kubectl run nginx --image=nginx --dry-run -o yaml --labels="app=nginx,owner=wangyijie,form=cmft"
```
8. 指定多个启动参数
在最后以 **--** 开头可以以空格分隔指定多个命令参数
```yaml
kubectl run nginx --image=nginx --dry-run -o yaml --schedule="* * * * *" --restart=OnFailure --labels="job=who" -- bash echo 123
```
9.创建服务
使用--expose参数会创建一个同名的服务, 更多服务选项可以是kubectl expose deployment
```yaml
kubectl run nginx --image=ngin --expose  --port=80
```
10.  遗憾是没用创建DeamonSet和StatefulSet的参数，建议用快速github搜索摸板或者在系统中获取，kube-system下有daemonset的部署
![search from githu](https://upload-images.jianshu.io/upload_images/6000429-55a2f0301649e32d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

还有更关键的是在pod摸板中默写各种资源的属性配置
