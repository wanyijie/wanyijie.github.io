---
summary: "内置的Docker overlay网络驱动程序彻底简化了多主机网络中的许多挑战。使用overlay驱动程序，多主机网络是Docker内的顶级原生类，无需外部配置或组件。overlay使用Swarm分布式控制平面在跨大规模集群中提供集中管理，稳定性和安全性"
tags:
    - wangyijie
    - container
categories:
    - Development
    - Opetration
---
::: container
::: post
# docker overlay-networks {#docker-overlay-networks .title}

::: show-content
内置的Docker overlay网络驱动程序彻底简化了多主机网络中的许多挑战。使用overlay驱动程序，多主机网络是Docker内的顶级原生类，无需外部配置或组件。overlay使用Swarm分布式控制平面在跨大规模集群中提供集中管理，稳定性和安全性。\

[VXLAN数据平面](https://github.com/docker/labs/blob/master/networking/concepts/06-overlay-networks.md#vxlan-data-plane)

该overlay驱动器利用了解耦底层物理网络（容器网络的行业标准VXLAN数据平面*底层*）。Docker覆盖网络将容器流量封装在VXLAN头中，允许流量穿过物理层2或第3层网络。无论底层物理拓扑是什么，覆盖使网络分段动态且易于控制。使用标准的IETF
VXLAN头可以提供标准的工具来检查和分析网络流量。

VXLAN自3.7版以来一直是Linux内核的一部分，Docker使用内核的本机VXLAN功能来创建覆盖网络。Docker覆盖数据路径完全在内核空间中。这导致更少的上下文切换，更少的CPU开销以及应用程序和物理NIC之间的低延迟直接流量路径。

IETF VXLAN（[RFC
7348](https://datatracker.ietf.org/doc/rfc7348/)）是一种数据层封装格式，覆盖了第3层网络上的第2层。VXLAN设计用于标准IP网络，并可在共享物理网络基础架构上支持大规模，多租户设计。现有的本地和基于云的网络可以透明地支持VXLAN。

VXLAN被定义为一个MAC-in-UDP封装，将容器二层框架放置在底层IP /
UDP头中。底层IP /
UDP头提供了底层网络上的主机之间的传输。覆盖是作为参与给定覆盖网络的每个主机之间的点对多点连接存在的无状态VXLAN隧道。由于覆盖层独立于底层拓扑，应用程序变得更加便携。因此，无论是内部部署，开发人员桌面还是在公共云中，网络策略和连接都可以与应用程序一起传输。

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-326256e845285034.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-326256e845285034.png?imageMogr2/auto-orient/strip"
image-slug="326256e845285034" data-width="720" data-height="553"}\

::: image-caption
:::
:::

在该图中，我们看到覆盖网络上的数据包流。以下是通过共享覆盖网络c1发送c2数据包时发生的步骤：\

c1做一个DNS查找c2。由于两个容器位于相同的覆盖网络上，Docker
Engine本地DNS服务器解析c2为其覆盖IP地址10.0.0.3。

覆盖网络是L2段，因此c1生成去往MAC地址的L2帧c2。

该帧由overlay网络驱动程序用VXLAN头封装。分布式覆盖控制平面管理每个VXLAN隧道端点的位置和状态，因此它知道c2驻留host-B在物理地址上192.168.0.3。该地址成为底层IP头的目标地址。

封装后封包发送。物理网络负责将VXLAN数据包路由或桥接到正确的主机。

该分组到达网络驱动程序的eth0接口host-B并被解封装overlay。从原来的L2帧c1被传递到c2的eth0接口和多达收听应用程序。

[覆盖驱动程序内部架构](https://github.com/docker/labs/blob/master/networking/concepts/06-overlay-networks.md#overlay-driver-internal-architecture)

Docker
Swarm控制平面自动化覆盖网络的所有配置。不需要VXLAN配置或Linux网络配置。当创建网络时，覆盖驱动程序也会自动配置数据平面加密（叠加层的可选功能）。用户或网络运营商只需定义网络（docker
network create -d overlay \...）并将容器附加到该网络。

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-b544aa2803e7d4fb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-b544aa2803e7d4fb.png?imageMogr2/auto-orient/strip"
image-slug="b544aa2803e7d4fb" data-width="275" data-height="442"}\

::: image-caption
:::
:::

在覆盖网络创建过程中，Docker
Engine会为每个主机创建覆盖层所需的网络基础架构。每个重叠以及相关联的VXLAN接口创建一个Linux网桥。Docker
Engine只有在连接到该网络的容器在主机上安排时才智能实例化主机上的覆盖网络。这可以防止连接的容器不存在的覆盖网络的蔓延。\

在以下示例中，我们创建一个覆盖网络并将容器附加到该网络。然后我们将看到Docker
Swarm / UCP自动创建覆盖网络。

::: image-package
![](http://upload-images.jianshu.io/upload_images/6000429-daef8fb98aaad368.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240){original-src="http://upload-images.jianshu.io/upload_images/6000429-daef8fb98aaad368.png?imageMogr2/auto-orient/strip"
image-slug="daef8fb98aaad368" data-width="884" data-height="655"}\

::: image-caption
:::
:::

在容器内已经创建了两个对应于主机上现在存在的两个桥的接口。在覆盖网络上，每个容器至少有两个接口连接到overlay它们docker_gwbridge。\

桥目的

**覆盖**入口和出口指向VXLAN封装的覆盖网络，并且（可选地）加密在相同覆盖网络上的容器之间的流量。它覆盖所有参与此特定叠加层的主机。主机上的每个重叠子网将存在一个，它将具有与特定覆盖网络相同的名称。

**docker_gwbridge**用于离开集群的流量的出口网桥。docker_gwbridge每个主机只会存在一个。容器到容器的流量在该桥上被阻塞，允许仅进入/出口流量。

Docker Overlay驱动程序自Docker Engine 1.9以来一直存在，需要外部K /
V存储来管理网络的状态。Docker 1.12将控制平面状态集成到Docker
Engine中，以便不再需要外部存储。1.12还介绍了几个新功能，包括加密和服务负载均衡。引入的网络功能需要支持它们的Docker
Engine版本，并且不支持将旧版本的Docker Engine使用这些功能。
:::
:::
:::
