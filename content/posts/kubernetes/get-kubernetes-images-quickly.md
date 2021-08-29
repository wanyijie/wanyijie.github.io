## open:
https://katacoda.com/courses/kubernetes/playground
## check images
kubeadm config images list
W0601 03:36:09.535740   16500 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
k8s.gcr.io/kube-apiserver:v1.18.3
k8s.gcr.io/kube-controller-manager:v1.18.3
k8s.gcr.io/kube-scheduler:v1.18.3
k8s.gcr.io/kube-proxy:v1.18.3
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.3-0
k8s.gcr.io/coredns:1.6.7

## exceute script
```
docker login --username=hi30567721@aliyun.com --password=youpass registry.cn-shenzhen.aliyuncs.com
for i in `kubeadm config images list | grep k8s.gcr.io`
do  echo $i; docker pull $i
    docker tag $i  registry.cn-shenzhen.aliyuncs.com/wangyijie/${i##*/}
    docker push registry.cn-shenzhen.aliyuncs.com/wangyijie/${i##*/}
done
```
