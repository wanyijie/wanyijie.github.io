---
summary: "从 v1.8 开始，kube-scheduler 支持定义 Pod 的优先级，从而保证高优先级的 Pod 优先调度。并从 v1.11 开始默认开启"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
从 v1.8 开始，kube-scheduler 支持定义 Pod 的优先级，从而保证高优先级的 Pod 优先调度。并从 v1.11 开始默认开启。
注：在 v1.8-v1.10 版本中的开启方法为
```
apiserver 配置: 
  --feature-gates=PodPriority=true 
  --runtime-config=scheduling.k8s.io/v1alpha1=true
kube-scheduler 配置:
  --feature-gates=PodPriority=true
```
在指定 Pod 的优先级之前需要先定义一个 PriorityClass（非 namespace 资源），如
```
apiVersion: v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000
globalDefault: false
description: "This priority class should be used for XYZ service pods only."
```
其中value 为 32 位整数的优先级，该值越大，优先级越高
globalDefault 用于未配置 PriorityClassName 的 Pod，整个集群中应该只有一个 PriorityClass 将其设置为 true
然后，在 PodSpec 中通过 PriorityClassName 设置 Pod 的优先级：
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  priorityClassName: high-priority
```
