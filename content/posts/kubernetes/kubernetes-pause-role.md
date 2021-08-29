相信熟悉kubernetes的朋友都知道，kubernetes启动 Pod 里定义的容器之前，kubelet 会先启动一个 infra 容器，并执行 /pause 让 infra 容器的主进程永远挂起。
这个容器存在的目的其实是维持住整个 Pod 的各种 namespace，真正的业务容器只要加入 infra 容器的 network 等 namespace 就能实现对应 namespace 的共享。而 infra 容器创造的这个共享环境则被抽象为 PodSandbox。每次 kubelet 在创建 Pod 时，就会先调用 CRI 的 RunPodSandbox 接口启动一个沙箱环境，再调用 CreateContainer 在沙箱中创建容器。
pause很小，这有时可以加快pod的启动速度
