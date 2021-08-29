最近我考虑轻量的CICD系统，就我了解的除了云服务就jekins集合git事件比较完善一点，其实开源的cicd系统并不多，大部分半开源的，jenkins运行几下就要五六G内存，实在不亲民。

基于knative evening 事件系统可以很容易开发一个kubernetes原生的自动部署系统，甚至可以做更多
[https://knative.dev/docs/eventing/samples/helloworld/helloworld-go/](https://knative.dev/docs/eventing/samples/helloworld/helloworld-go/)


