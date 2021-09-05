---
summary: "install upgrade tool kubeadm"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
# install upgrade tool kubeadm
```
apt install -y kubeadm
kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.19.4
k8s.gcr.io/kube-controller-manager:v1.19.4
k8s.gcr.io/kube-scheduler:v1.19.4
k8s.gcr.io/kube-proxy:v1.19.4
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns:1.7.0
```
# transfer gcr images to docker hub
open https://katacoda.com/courses/ubuntu/playground
```
go get github.com/xilu0/transfer
for im in `kubeadm config images list`;do  transfer --user=heishui --password="$repopass" --image=$im;done
```
# upgrade kubernetes cluster
```
kubeadm upgrade plan
kubeadm upgrade apply v1.19.4
```
# upgrade components
```
apt install -y kubectl kubelet
```
