---
summary: "默认情况下，Compose为您的应用程序设置单个网络。服务的每个容器都加入默认网络，并且可以由该网络上的其他容器访问，并且可由他们发现与容器名称相同的主机名。"
tags:
    - wangyijie
    - container
categories:
    - Development
    - Opetration
---
# 单个网络
注意：本文档仅适用于版本2或更高版本的compose文件格式。compose version1不支持网络功能。

默认情况下，Compose为您的应用程序设置单个网络。服务的每个容器都加入默认网络，并且可以由该网络上的其他容器访问，并且可由他们发现与容器名称相同的主机名。

注意：您的应用程序的网络名称基于“项目名称”，就是基于它所在的目录的名称。您可以使用--project-name标签或COMPOSE_PROJECT_NAME 环境变量覆盖项目名称。

例如，假设您的应用程序位于名为myapp的目录中，并且您的docker-compose.yml如下所示：
```
version: "3"
services:
       web:
            build: .
            ports:
            - "8000:8000"
      db:
            image: postgres
            ports:
            - "8001:5432"
```

当您运行docker-compose时，会发生以下情况：

1.创建一个名为myapp_default的网络。

2.使用“web”服务的配置创建一个容器。它加入一个叫myapp_default网络，在里面的名称是web。

3.使用”db“服务的配置创建一个容器。它加入一个叫myapp_default网络，在里面的名称是db。

每个容器现在可以查找主机名"web"或"db"并获取相应容器的IP地址。例如，Web的应用程序可以连接到URL postgres：// db：5432并开始使用Postgres数据库。

请注意主机端口和容器端口之间的区别。在上述示例中，对于db，主机端口为8001，容器端口为5432（默认为postgres端口）。服务到服务的网络通信使用容器端口。当定义主机端口时，服务也可以在群外访问。

在Web容器中，您的db的连接字符串看起来像postgres：// db：5432，从主机，连接字符串看起来像postgres：// {DOCKER_IP}：8001。

# 多主机网络
将Compose应用程序部署到Swarm群集时，可以使用内置的overlay驱动来启用多主机之间的容器通信，而不会对Compose文件或应用程序代码进行任何更改。

默认情况下，群集将使用Overlay驱动，但如果您愿意，可以明确指定它。您可以使用顶级网络键（key）指定自己的网络，而不是使用默认的应用网络。这样可以创建更复杂的拓扑结构，并指定自定义网络驱动程序和选项。您还可以使用它将服务连接到由Compose管理的外部创建的网络。

每个服务都可以指定使用服务级网络key连接的网络，这是一个名称引用顶级networks键下的条目的列表。

这是一个定义两个自定义网络的“compose”文件示例。代理服务与数据库服务隔离，因为它们不共享一个共同的网络 - 只有app可以与两者通信。
```
version: "3"
services:
   proxy:
   build: ./proxy
   networks:
     - frontend
  app:
      build: ./app
    networks:
   - frontend
   - backend
  db:
    image: postgres
    networks:
    - backend
 networks:
   frontend:
     driver: custom-driver-1
   backend:
     driver: custom-driver-2
     driver_opts:
       foo: "1"
       bar: "2"
```