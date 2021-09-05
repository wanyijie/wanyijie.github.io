---
summary: "一个ingress  host可以配置多个后端服务,通过添加删除服务实现蓝绿部署，将不同版本的服务入口一起配上，通过使用权重注解可以实现流量分配，权重50的含义是将流量的百分之 50 引入到新服务的 pod 里面"
---
一个ingress  host可以配置多个后端服务,通过添加删除服务实现蓝绿部署，将不同版本的服务入口一起配上，通过使用权重注解可以实现流量分配，权重50的含义是将流量的百分之 50 引入到新服务的 pod 里面

    ingress.aliyun.weight/new-nginx: "50"  

![image.png](https://upload-images.jianshu.io/upload_images/6000429-3d45fae90fc30001.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
