# 文档即命令行 
```
OVPN_DATA="vpn-data"
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm 
# udp://112.60.90.13:1194 指定服务器地址协议端口, 默认1194
dockerhub.azk8s.cn/kylemanna/openvpn ovpn_genconfig -u udp://112.60.90.13
docker run -v $OVPN_DATA:/etc/openvpn -it  --log-driver=none --rm dockerhub.azk8s.cn/kylemanna/openvpn ovpn_initpki
 docker run -v $OVPN_DATA:/etc/openvpn -d  -p 1194:1194/udp --cap-add=NET_ADMIN dockerhub.azk8s.cn/kylemanna/openvpn
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it dockerhub.azk8s.cn/kylemanna/openvpn easyrsa build-client-full wangyijie nopass
 docker volume ls
 docker volume inspect vpn-data 
 cd /var/lib/docker/volumes/vpn-data/_data
 ls pki/private/wangyijie.key 
 docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm dockerhub.azk8s.cn/kylemanna/openvpn ovpn_getclient wangyijie >  /data/wangyijie.ovpn
 cat /data/wangyijie.ovpn
```
## 注意事项：
1. 默认是全局流量走vpn, 如果不想全部走vpn, 需要在客户端配置里面注释 #redirect-gateway def1， 在服务器配置注释掉dns代理，添加希望走vpn的配置，比如我的服务器在172.31.250.0/25，我就只路由这个网段
![openvpn.png](https://upload-images.jianshu.io/upload_images/6000429-c45446acc6ac818e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
2. 客户指定路由我配置没有生效，如果你知道是什么原因，请给我留言
