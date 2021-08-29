---
summary: "docker image move tools skopeo command example"
---

```
docker run --rm -it registry.cn-shenzhen.aliyuncs.com/windonet/skopeo:1.4 bash
# example
skopeo --override-os windows --insecure-policy \
   copy --dest-creds Username:Password \
    docker://mcr.microsoft.com/dotnet/framework/runtime:4.8 \
    docker://registry.cn-shenzhen.aliyuncs.com/windonet/donet-framework-runtime:4.8
```
github: [https://github.com/containers/skopeo](https://github.com/containers/skopeo)

notice: 
     --override-os windows #跨平台时使用，指定镜像所在的平台
     --insecure-policy # 不做策略检查
     # 更多使用-h看帮助，麻烦的事有cgo不支持静态编译，对操作系统有要求
