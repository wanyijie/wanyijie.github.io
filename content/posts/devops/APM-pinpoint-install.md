通过docker安装APM系统pinpoint
<!--more-->
# install docker 
需要 docker-ce-18.03.+ docker-compose 1.23.+
```
yum install -y http://mirror.azure.cn/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.8-3.el7.x86_64.rpm
systemctl start docker 
systemctl enable docker
curl -o /usr/local/bin/docker-compose  http://mirror.azure.cn/docker-toolbox/linux/compose/1.25.5/docker-compose-Linux-x86_64 
chmod +x /usr/local/bin/docker-compose 
```
# install pinpoint
cd /opt
git clone https://github.com/naver/pinpoint-docker
cd pinpoint-docker
docker-compose pull
docker-compose up -d

#访问
demo:  打开页面之后点各个连接产生访问数据
http://${your host}:8000

web: http://${your host}:8079

# example

![Application list](https://upload-images.jianshu.io/upload_images/6000429-096d7b00c8c8a0ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![real time](https://upload-images.jianshu.io/upload_images/6000429-095d5e83f0f83299.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![inspector](https://upload-images.jianshu.io/upload_images/6000429-f14d2d9240e99a79.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![APM](https://upload-images.jianshu.io/upload_images/6000429-c653ba8bdbdc69fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 最后这一张图片是显示APM信息的,打开的方式是框住主页的访问数据点图,选择之后就会打开新页面

![open APM](https://upload-images.jianshu.io/upload_images/6000429-546fb97d1afa5f2a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)










