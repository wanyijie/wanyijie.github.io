---
summary: "重头构建kubernetes集群v1.81 {#重头构建kubernetes集群v1.81 .title}"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
# 重头构建kubernetes集群v1.81 {#重头构建kubernetes集群v1.81 .title}

简洁点只记录步骤，关键的地方才备注说明；

设置包转发：

> net.ipv4.ip_forward = 1\

下载二进制包：

先下载最新版本的源码：

> https://github.com/kubernetes/kubernetes/releases/tag/v1.8.1\

下载后解压，运行下载脚本，本人当时国内下载速度还蛮快，庆幸！

> ./kubernetes/cluster/get-kube-binaries.sh\


![](http://upload-images.jianshu.io/upload_images/6000429-24339c50b4059d4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){data-height="407"
data-width="820" image-slug="24339c50b4059d4e"
original-src="http://upload-images.jianshu.io/upload_images/6000429-24339c50b4059d4e.png?imageMogr2/auto-orient/strip"}\


下载二进制程序

下载包存放的位置，里面包含了所有需要的软件，\


![](http://upload-images.jianshu.io/upload_images/6000429-6af8e8a8f7980226.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){data-height="33"
data-width="577" image-slug="6af8e8a8f7980226"
original-src="http://upload-images.jianshu.io/upload_images/6000429-6af8e8a8f7980226.png?imageMogr2/auto-orient/strip"}\



包下载的二进制解压，可以放一个新的目录，后面的描述主要基于二进制文件目录，./kubernetes/server/bin包含所有必需的二进制文件

安装docker

> yum install -y yum-utils\\device-mapper-persistent-data\\lvm2\

现在docker只有一个包，不在依赖自己的包，都在系统源里面有，所有下载一个aliyun的安装包就可以安装

> wget
> http://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-17.06.2.ce-1.el7.centos.x86_64.rpm\

安装前可以更新下系统

> yum install docker-ce-17.06.2.ce-1.el7.centos.x86_64.rpm\

> systemctl start docker && systemctl enable docker && systemctl status
> docker\

导入镜像

> docker load -i ./kubernetes/server/bin/kube-apiserver.tar\
>
> docker load -i ./kubernetes/server/bin/kube-controller-manager.tar
>
> docker load -i ./kubernetes/server/bin/kube-proxy.tar
>
> docker load -i ./kubernetes/server/bin/kube-scheduler.tar\

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-5b3e48670ff45630.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){data-height="182"
data-width="714" image-slug="5b3e48670ff45630"
original-src="http://upload-images.jianshu.io/upload_images/6000429-5b3e48670ff45630.png?imageMogr2/auto-orient/strip"}\


::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-80bba51cccd63e64.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){data-height="116"
data-width="832" image-slug="80bba51cccd63e64"
original-src="http://upload-images.jianshu.io/upload_images/6000429-80bba51cccd63e64.png?imageMogr2/auto-orient/strip"}\


下载etcd镜像：\

> docker pull quay.io/coreos/etcd:v2.2.1

生成证书，证书我也觉得很扎手，我是复制kubeadm的证书，自己想办法

> https://kubernetes.io/docs/admin/authentication/#creating-certificates/\

设置adminconfig,会在目录下生产一个配置文件

> kubectl config set-cluster local
> \--certificate-authority=/srv/kubernetes/ca.crt \--embed-certs=true
> \--server=https://172.19.6.28\
>
> kubectl config set-credentials admin
> \--client-certificate=/srv/kubernetes/apiserver.crt
> \--client-key=/srv/kubernetes/apiserver.key \--embed-certs=true
> \--token=RrRixoUDucnmsFMFzHRpARpsK4VcgXop
>
> kubectl config set-context kubernetes \--cluster=local \--user=admin
>
> kubectl config use-context kubernetes

具体的配置文件生成就不细说了，可以参照以前配置文件
