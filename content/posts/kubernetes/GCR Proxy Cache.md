---
summary: "GCR Proxy Cache服务器相当于一台GCR镜像服务器，国内用户可以经由该服务器从[gcr.io](http://gcr.io/)下载镜像"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
# GCR Proxy Cache 帮助

GCR Proxy Cache服务器相当于一台GCR镜像服务器，国内用户可以经由该服务器从[gcr.io](http://gcr.io/)下载镜像。

</header>

# 使用GCR Proxy Cache从gcr.io下载镜像

```
docker pull gcr.azk8s.cn/google_containers/<imagename>:<version>
```

## 例子

```
docker pull gcr.azk8s.cn/google_containers/pause-amd64:3.0
```

```
docker pull gcr.azk8s.cn/google_containers/kubedns-amd64:1.7
```
