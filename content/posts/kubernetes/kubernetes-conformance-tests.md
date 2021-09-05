---
summary: "./sonobuoy images pull --e2e-repo-config custom-repos.yaml -dry-run"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
## 大概步骤
1. 获取镜像
./sonobuoy images pull --e2e-repo-config custom-repos.yaml -dry-run
2. 参考下面的脚本通过gcr.azk8s.cn代理地址下载gcr镜像上传到私有仓库
3. 执行任务会在kubenetes里面创建pod启动任务
./sonobuoy run --sonobuoy-image 172.20.8.7/library/sonobuoy:v0.17.2\
 --kube-conformance-image 172.20.8.7/library/conformance:v1.15.10
4. 等运行剩一个pod，大概几个小时的时间，检查结果
  ./sonobuoy status
5. 通过之后收集数据
results=$(./sonobuoy retrieve)
./sonobuoy results $results
```
#get command sonobuoy
docker run -d --rm  --name=sonobuoy  sonobuoy/sonobuoy:v0.16 sleep 120
docker cp sonobuoy:/sonobuoy ./
# 私有仓库
registry=172.20.8.7
getImage(){
image=$1
docker pull $image
docker $image tag ${registry}/library/${image##*/}
docker push ${registry}/library/${image##*/}
}
kubeVersion=v1.15.10
getImage gcr.azk8s.cn/heptio-images/sonobuoy-plugin-systemd-logs:latest
getImage gcr.azk8s.cn/google-containers/conformance:$kubeVersion

./sonobuoy run --sonobuoy-image 172.20.8.7/library/sonobuoy:v0.16\
 --kube-conformance-image 172.20.8.7/library/conformance:v1.15.10\
 #--systemd-logs-image 172.20.8.7/library/sonobuoy-plugin-systemd-logs:latest
# --systemd-logs-image was noticed unknown flag
ds=$(kubectl get ds -n sonobuoy | grep sonobuoy-systemd-logs | awk '{print $1}')
kubectl set image daemonset $ds systemd-logs=172.20.8.7/library/sonobuoy-plugin-systemd-logs:latest
```
## 观察
kubectl get po -n sonobuoy

# 参考镜像列表
```
gcr.azk8s.cn/google-containers/conformance:v1.15.10
gcr.azk8s.cn/kubernetes-e2e-test-images/nonroot:1.0
gcr.azk8s.cn/heptio-images/sonobuoy-plugin-systemd-logs:latest
gcr.azk8s.cn/kubernetes-e2e-test-images/no-snat-test:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/inclusterclient:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/agnhost:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/resource-consumer-controller:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/cuda-vector-add:2.0
gcr.azk8s.cn/kubernetes-e2e-test-images/volume/iscsi:2.0
gcr.azk8s.cn/kubernetes-e2e-test-images/webhook:1.15v1
gcr.azk8s.cn/kubernetes-e2e-test-images/liveness:1.1
gcr.azk8s.cn/kubernetes-e2e-test-images/audit-proxy:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/resource-consumer:1.5
gcr.azk8s.cn/kubernetes-e2e-test-images/metadata-concealment:1.2
gcr.azk8s.cn/kubernetes-e2e-test-images/crd-conversion-webhook:1.13rev2
gcr.azk8s.cn/kubernetes-e2e-test-images/netexec:1.1
gcr.azk8s.cn/kubernetes-e2e-test-images/sample-apiserver:1.10
gcr.azk8s.cn/kubernetes-e2e-test-images/echoserver:2.2
gcr.azk8s.cn/kubernetes-e2e-test-images/volume/rbd:1.0.1
gcr.azk8s.cn/kubernetes-e2e-test-images/apparmor-loader:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/volume/nfs:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/volume/gluster:1.0
gcr.azk8s.cn/google-samples/gb-frontend:v6
gcr.azk8s.cn/google-samples/gb-redisslave:v3
gcr.azk8s.cn/kubernetes-e2e-test-images/dnsutils:1.1
gcr.azk8s.cn/kubernetes-e2e-test-images/jessie-dnsutils:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/kitten:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/fakegitserver:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/hostexec:1.1
gcr.azk8s.cn/kubernetes-e2e-test-images/nettest:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/porter:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/iperf:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/nonewprivs:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/entrypoint-tester:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/logs-generator:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/cuda-vector-add:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/serve-hostname:1.1
gcr.azk8s.cn/kubernetes-e2e-test-images/nautilus:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/mounttest:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/no-snat-test-proxy:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/mounttest-user:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/redis:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/test-webserver:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/net:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/ipc-utils:1.0
gcr.azk8s.cn/kubernetes-e2e-test-images/port-forward-tester:1.0
```


## detail [https://sonobuoy.io/docs/v0.17.2/airgap/](https://sonobuoy.io/docs/v0.17.2/airgap/)
