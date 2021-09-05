---
summary: "heapster已经不在维护，转由metrics-server 替代，没安装metrics-server pod命令和自动调度不能正常工作"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
heapster已经不在维护，转由metrics-server 替代，没安装metrics-server pod命令和自动调度不能正常工作
项目地址：[https://github.com/kubernetes-incubator/metrics-server](https://github.com/kubernetes-incubator/metrics-server)
部署后可能不能正常收集数据，尝试添加下面的启动参数，kubelet-insecure-tls用于kubelet使用证书不满足认证添加，kubelet-preferred-address-types指名访问kubelet的地址类型，分别有：InternalIP,ExternalIP,Hostname
 ```
 - /metrics-server
      - --v=2
      - --kubelet-insecure-tls
      - --kubelet-preferred-address-types=InternalIP
```
