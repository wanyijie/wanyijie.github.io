---
summary: "为了快速见证新功能，我们选择kubeadmin这个工具来创建集群，官方的工具虽然还在内测阶段，但各种服务的配置方式，可以做为自定义部署的参考，kubeadmin是多基于容器的，只要把每个容器的配置都熟悉了，自定义部署也是非常容易的，所以说这个kubeadmin可供细研究也可快速完成集群环境的搭建，里面有些需要注意的地方，参照这篇文章可以直接解决一些问题，省去一些搜索工作"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
# kubernetes 1.8安装记录 {#kubernetes-1.8安装记录 .title}

::: show-content
# v1.8.0简介：

关于Kubernetes
1.8版包括新功能和增强功能，以及修复的问题，请慢慢看下面的链接

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md#external-dependencies\

# 安装kubeadmin：

为了快速见证新功能，我们选择kubeadmin这个工具来创建集群，官方的工具虽然还在内测阶段，但各种服务的配置方式，可以做为自定义部署的参考，kubeadmin是多基于容器的，只要把每个容器的配置都熟悉了，自定义部署也是非常容易的，所以说这个kubeadmin可供细研究也可快速完成集群环境的搭建，里面有些需要注意的地方，参照这篇文章可以直接解决一些问题，省去一些搜索工作。

## 先决条件：

1.关闭系统的交换分区，2.sysctl
net.bridge.bridge-nf-call-iptables=1（打开iptables管理网桥的功能），等等就是还有不关键的

# 通讯端口： 

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-9aadd6be32115660.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-9aadd6be32115660.png?imageMogr2/auto-orient/strip"
image-slug="9aadd6be32115660" data-width="519" data-height="283"}\

::: image-caption
:::
:::

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-d963111e64f71cbb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-d963111e64f71cbb.png?imageMogr2/auto-orient/strip"
image-slug="d963111e64f71cbb" data-width="323" data-height="223"}\

::: image-caption
:::
:::

## 安装ebtables ethtool 

> yum install ebtables ethtool\

# 安装docker

官方建议的1.12刚好是centos源带的，所以不必去找新版的源\

> yum install -y docker  && systemctl enable docker && systemctl start
> docker

## 安装kubeadm, kubelet and kubectl

阿里源地址：http://mirrors.aliyun.com/kubernetes/yum/

我编译的包上传网盘了，链接：http://pan.baidu.com/s/1bp51D7p 密码：jtie\

要自己编译rpm包可以看这个项目：https://github.com/kubernetes/release.git

> cd rpm 
> #进入rpm目录执行脚本会创建docker完成编译，包输出到当前目录的output里面，要有docker环境\
>
> ./docker-build.sh

\

> cat \< /etc/yum.repos.d/kubernetes.repo\
>
> \[kubernetes\]
>
> name=Kubernetes
>
> baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
>
> enabled=1
>
> gpgcheck=1
>
> repo_gpgcheck=1
>
> gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
>
> https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
>
> EOF
>
> setenforce 0
>
> yum install -y kubelet kubeadm kubectl
>
> systemctl enable kubelet && systemctl start kubelet

## 关闭selinux

> setenforce 0\

## 把iptables管理网桥流量的配置写入配置文件，随kubelet启动

> cat \<  /etc/sysctl.d/k8s.conf\
>
> net.bridge.bridge-nf-call-ip6tables = 1
>
> net.bridge.bridge-nf-call-iptables = 1
>
> EOF
>
> sysctl \--system

# 创建集群：

执行命令初始化，有多个IP的主机最好指定宣告地址，支持后续的网络方案一般都要指定容器网段，还可以指定域名\

> kubeadm init \--apiserver-advertise-address=172.19.7.112
> \--pod-network-cidr=10.244.0.0/16 \--service-dns-domain=\"heishui.io\"

# 安装网络：

网络有很多方案，各有特色，有些方案还很复杂，官方最新引入的Cilium很完美，但条件太苛刻不成熟；思科支持的Contiv；詹博背书的Contrail；coros
主导开发的Flannel；Kube-router项目似乎开发很活跃，以后关注一下，很针对kubenetes;Calico综合很好；OpenVSwitch在云计算项目中很流行，这里我选择flannel,简单功能性能也不错，coros对kubernetes支持很给力，和Google很铁有前途的。

> kubectl apply -f
> https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml

# 让主节点可以运行业务：

> kubectl taint nodes \--all node-role.kubernetes.io/master-\

## 加入节点：

> kubeadm join \--token 146d14.c80b331449030770 172.19.7.112:6443
> \--discovery-token-ca-cert-hash
> sha256:f3b608648306dcd4eb0a854ea36dcdffb08f717e09ac176562a3d520256e8c5f\

## 将API服务器代理到本地主机:

> kubectl \--kubeconfig ./admin.conf proxy\

## 故障排除：

请求不到版本文件，隐晦的问题，看下下面怎么搭梯子\

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-e94dca0a593cb740.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-e94dca0a593cb740.png?imageMogr2/auto-orient/strip"
image-slug="e94dca0a593cb740" data-width="1540" data-height="53"}\

::: image-caption
:::
:::

## 登云梯：

vpn就不说了，怕麻烦就买vpn,这里说的方法是通过ssh代理socks隧道，socks协议长城都拦不住，国外备个云主机执行下面的命令即可实现代理上网,由于墙内dns都配合政府搞污染，可能你需要配置国外的dns, 
8.8.8.8没有争议

> ssh -f -N -D 127.0.0.1:1080 root\@your_host_ip\

执行这条命令之后你的网络就已经出国了

## 找不到网络插件：

这里有一个bug，需要取消一些kubelet的环境变量，不然初始化会提示找不到网络插件

编辑文件/etc/systemd/system/kubelet.service.d/10-kubeadm.conf,去掉KUBELET_NETWORK_ARGS，让其使用默认值\

## 有镜像不能下载： 

一个办法是在dockerhub包括国内镜像源上找同样版本的镜像，下载之后改下名字即可，名字在你发现错误的地方已经有了\

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-a5529893c8b0eaaa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-a5529893c8b0eaaa.png?imageMogr2/auto-orient/strip"
image-slug="a5529893c8b0eaaa" data-width="1583" data-height="173"}\

::: image-caption
:::
:::

# 镜像：

下面这些都是创建集群必须，我把镜像打包放百度云盘，链接：http://pan.baidu.com/s/1jH8uYqU
密码：tosd

漏了一个pase,链接：http://pan.baidu.com/s/1cErk9C 密码：auo6\

可以下载tag，或许就不用外网：

> docker tag 790ec863918a docker.io/cloudnativelabs/kube-router:latest\

> docker tag ed645752b229
> gcr.io/google_containers/kube-controller-manager-amd64:v1.8.0
>
> docker tag 0e8dfbdff483
> gcr.io/google_containers/kube-apiserver-amd64:v1.8.0
>
> docker tag 758acd37d575
> gcr.io/google_containers/kube-scheduler-amd64:v1.8.0
>
> docker tag fd5fddfa4be3
> gcr.io/google_containers/kube-proxy-amd64:v1.8.0
>
> docker tag fed89e8b4248
> gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.5
>
> docker tag 512cd7425a73
> gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.5
>
> docker tag 459944ce8cc4
> gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
>
> docker tag 4c600a64a18a quay.io/coreos/flannel:v0.9.0-amd64
>
> docker tag 54511612f1c4 docker.io/busybox:latest
>
> docker tag 243830dae7dd gcr.io/google_containers/etcd-amd64:3.0.17
>
> docker tag 99e59f495ffa gcr.io/google_containers/pause-amd64:3.0

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-15e6541b015b8ad6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-15e6541b015b8ad6.png?imageMogr2/auto-orient/strip"
image-slug="15e6541b015b8ad6" data-width="896" data-height="228"}\

::: image-caption
:::
:::

有问题可以到qq群（666455513）里面留言，仅限于容器交流\
:::
:::
:::
