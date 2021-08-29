---
summary: ""
---
服务匹配部署是在template下的labels,选择一个labels即可，一个服务可以对应多个部署，部署的副本越多分的流量比例越大哦，以此来实现金丝雀发布，同理也可以做蓝绿部署，就是在部署的template labels上交换添加移除标签的事


 apiVersion: extensions/v1beta1
 kind: Deployment
 metadata:
   labels:
     run: old-nginx
   name: old-nginx
 spec:
   replicas: 1
   selector:
     matchLabels:
       run: old-nginx
   template:
     metadata:
       labels:
         run: old-nginx
         app: nginx
     spec:
       containers:
       - image: registry.cn-hangzhou.aliyuncs.com/xianlu/old-nginx
         imagePullPolicy: Always
         name: old-nginx
         ports:
         - containerPort: 80
           protocol: TCP
       restartPolicy: Always
---
 apiVersion: extensions/v1beta1
 kind: Deployment
 metadata:
   labels:
     run: new-nginx
   name: new-nginx
 spec:
   replicas: 1
   selector:
     matchLabels:
       run: new-nginx
   template:
     metadata:
       labels:
         run: new-nginx
         app: nginx
     spec:
       containers:
       - image: registry.cn-hangzhou.aliyuncs.com/xianlu/new-nginx
         imagePullPolicy: Always
         name: new-nginx
         ports:
         - containerPort: 80
           protocol: TCP
       restartPolicy: Always
 ---
 apiVersion: v1
 kind: Service
 metadata:
   labels:
     run: nginx
   name: nginx
 spec:
   ports:
   - port: 80
     protocol: TCP
     targetPort: 80
   selector:
     app: nginx
   sessionAffinity: None
