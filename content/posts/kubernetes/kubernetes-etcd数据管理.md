---
summary: "etcd组织的数据结构清晰，查找操作简便，从数据层面去维护集群也很容易，保护好数据就有一切"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
一次使用[helm](https://docs.helm.sh)安装[spinnaker](https://www.spinnaker.io/)这个部署系统，对helm不熟悉，由于卡住超时了，随着又再次执行安装，我是在自己的电脑上弄了个10G内存的虚拟机安装的kubernetes,结果安装了两次spinnaker导致资源不足系统异常缓慢，kube-apiserver响应不过来不停的失败重启，kube-apiserver不能存活我就没办法管理pods了，所以想到去数据源etcd把spinnaker的容器信息先删掉，把集群恢复之后再重新安装，为了操作etcd我翻了些文章才找到方法，相关的资料比较少，所以自己也记录一下。
我是使用kubeadm工具安装的集群，要解除集群的资源占用要先把一些容器停掉，把kube-apiserver的编排文件从/etc/kubernetes/manifests/目录下先移出来，kubelet检查到会停止相应的pods,没有了kube-apiserver集群不会再创建新的pods,这时kubectl不可用了，使用docker命令把spinnaker项目的容器都删掉系统资源就能空闲出来。这时etcd还是正常的，用docker工具直接进入etcd。  
操作etcd有命令行工具[etcdctl](https://coreos.com/etcd/docs/latest/dev-guide/local_cluster.html)，有两个api版本互不兼容的，系统默认的v2版本，kubernetes集群使用的是v3版本，v2版本下是看不到v3版本的数据的，我也是找了些资料才了解这个情况。
**使用环境变量定义api版本**
 `export ETCDCTL_API=3`
**etcd有目录结构类似linux文件系统，获取所有key看一看：**
 `etcdctl get / --prefix --keys-only`
![获取所有key](http://upload-images.jianshu.io/upload_images/6000429-ecce0927bda31922.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
**一看就可以大概理解kubenetes的数据结构了，查询命名空间下所有部署的数据：**
`etcdctl get /registry/deployments/default  --prefix --keys-only`
![命名空间的key](http://upload-images.jianshu.io/upload_images/6000429-d6860dbba11882e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**把想删除的删掉，列如：**
`etcdctl del  /registry/deployments/default/elevated-dragonfly-spinn-front50`
删除deployments，pods这可以了，稍微减少一些资源，让kube-apiserver可以正常工作即可，其它资源还可以使用kubectl工具删除
删掉些资源后退出etcd把kube-apiserver的编排文件放回/etc/kubernetes/manifests目录，服务会再次启动，然后再清理重新部署。
##总结：
etcd组织的数据结构清晰，查找操作简便，从数据层面去维护集群也很容易，保护好数据就有一切

