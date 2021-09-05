---
summary: "使用工具kubeadm安装kubernetes集群是需要的镜像默认放在google容器仓库中，国内不便直接下载，这里记录通过hub.docker加git获取kubernetes镜像："
---

使用工具kubeadm安装kubernetes集群是需要的镜像默认放在google容器仓库中，国内不便直接下载，这里记录通过hub.docker加git获取kubernetes镜像：
1.登陆注册[dockerID](https://hub.docker.com/)和[github](https://github.com/)账户
2.dockerhub和github上的公开仓库创建都是没有限制的，在github创建一个仓库，里面放放入自己Dockerfile，列入：  

    from gcr.io/google_containers/kube-scheduler-amd64:v1.9.2
    label maintainer="785471184@qq.com"
这次我是使用应该仓库构建多个镜像，github上用目录分开存放，dockerhub上用tag来区分不同的仓库，如果不闲玛法可以一个镜像创建一个仓库。
![GitHub仓库](http://upload-images.jianshu.io/upload_images/6000429-fccba4557202146d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
dockerhub有普通仓库和自带构建仓库，普仓库我们可以登录后把本地镜像push上去，自动构建仓库支持对接github和bitbucket版本控制系统自动化构建，我要用github仓库自动构建，那就创建自动构建仓库，跟图：
![创建自动构建仓库](http://upload-images.jianshu.io/upload_images/6000429-8e42611befed4d94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

不要点下面那个很大的创建仓库图标，那里只是创建普通仓库的入口，从那里开始不能配置自动构建的，我也被坑一阵，留意！
![选择版本控制系统](http://upload-images.jianshu.io/upload_images/6000429-128cbef75b79e0a9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![选择仓库](http://upload-images.jianshu.io/upload_images/6000429-2631c9cddc3d1086.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这里有一点值得提醒，如果你的仓库是在组织下而不是在个人名下，那dockerhub默认是不能访问组织仓库，这时候需要去到github上删除组织仓库的第三方访问限制：
![删除访问限制](http://upload-images.jianshu.io/upload_images/6000429-75dbcac7386a81b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
选择仓库创建：
![选择仓库创建](http://upload-images.jianshu.io/upload_images/6000429-4b023c02bbd18152.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
默认是在仓库的根目录检查Dockerfile文件，我这里是要用一个仓库构建多个镜像，所有创建了子目录，把Dockerfile放在子目录里面，指定Dockerfile位置，中间有个激活自动构建的单选框，可以选择也可以不选需要的时候自己来点一下触发按钮，记得保存：
![配置构建信息](http://upload-images.jianshu.io/upload_images/6000429-fdb2474355d852ac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
触发构建之后可以去构建详细那里查看构建结果，如果失败了点击错误可以看到日志。
![构建信息](http://upload-images.jianshu.io/upload_images/6000429-d4e3f3d8cdc7a99f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
构建成功的可以就可以在tags那里看到标签，不想保留的镜像可以删除。
![镜像标签](http://upload-images.jianshu.io/upload_images/6000429-1d4228e6a9bdba4f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
最后一次构建成功的Dockerfile内容还会被提取到Dockerfile栏目。
![Dockerfile](http://upload-images.jianshu.io/upload_images/6000429-c423802b18b25e8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在仓库信息里面给些备注可以方便其他寻找镜像的人使用。
![仓库信息](http://upload-images.jianshu.io/upload_images/6000429-cd5c57dd98638f59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
ok！









