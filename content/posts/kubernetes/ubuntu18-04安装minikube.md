---
summary: "设置minikube使用的虚拟化环境， 启动miniKube环境"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
1. 使用kvm2 ,检查命令看到关键字即可：
```egrep --color 'vmx|svm' /proc/cpuinfo```
2. 安装kvm依赖：
```
apt install libvirt-clients libvirt-daemon-system qemu-kvm
systemctl enable libvirtd.service
systemctl start libvirtd.service
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2  
install docker-machine-driver-kvm2 /usr/local/bin/
```
3. 下载minikube, google的存储，下载失败多尝试几下成功后速度很快：
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64   && chmod +x minikube
cp minikube /usr/local/bin && rm minikub
```
4. 设置minikube使用的虚拟化环境， 启动miniKube环境：
```minikube config set vm-driver kvm2
minikube start --vm-driver kvm2
```
