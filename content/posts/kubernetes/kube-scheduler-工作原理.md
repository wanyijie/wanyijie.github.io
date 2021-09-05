---
summary: "kube-scheduler 调度分为两个阶段，predicate 和 priority"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
kube-scheduler 调度分为两个阶段，predicate 和 priority:
> predicate：过滤不符合条件的节点
> priority：优先级排序，选择优先级最高的节点

predicates 策略:
> PodFitsPorts：同 PodFitsHostPorts
PodFitsHostPorts：检查是否有 Host Ports 冲突
PodFitsResources：检查 Node 的资源是否充足，包括允许的 Pod 数量、CPU、内存、GPU 个数以及其他的 OpaqueIntResources
HostName：检查 pod.Spec.NodeName 是否与候选节点一致
MatchNodeSelector：检查候选节点的 pod.Spec.NodeSelector 是否匹配
NoVolumeZoneConflict：检查 volume zone 是否冲突
MaxEBSVolumeCount：检查 AWS EBS Volume 数量是否过多（默认不超过 39）
MaxGCEPDVolumeCount：检查 GCE PD Volume 数量是否过多（默认不超过 16）
MaxAzureDiskVolumeCount：检查 Azure Disk Volume 数量是否过多（默认不超过 16）
MatchInterPodAffinity：检查是否匹配 Pod 的亲和性要求
NoDiskConflict：检查是否存在 Volume 冲突，仅限于 GCE PD、AWS EBS、Ceph RBD 以及 ISCSI
GeneralPredicates：分为 noncriticalPredicates 和 EssentialPredicates。noncriticalPredicates 中包含 PodFitsResources，EssentialPredicates 中包含 PodFitsHost，PodFitsHostPorts 和 PodSelectorMatches。
PodToleratesNodeTaints：检查 Pod 是否容忍 Node Taints
CheckNodeMemoryPressure：检查 Pod 是否可以调度到 MemoryPressure 的节点上
CheckNodeDiskPressure：检查 Pod 是否可以调度到 DiskPressure 的节点上
NoVolumeNodeConflict：检查节点是否满足 Pod 所引用的 Volume 的条件

priorities 策略:
> SelectorSpreadPriority：优先减少节点上属于同一个 Service 或 Replication Controller 的 Pod 数量
InterPodAffinityPriority：优先将 Pod 调度到相同的拓扑上（如同一个节点、Rack、Zone 等）
LeastRequestedPriority：优先调度到请求资源少的节点上
BalancedResourceAllocation：优先平衡各节点的资源使用
NodePreferAvoidPodsPriority：alpha.kubernetes.io/preferAvoidPods 字段判断, 权重为 10000，避免其他优先级策略的影响
NodeAffinityPriority：优先调度到匹配 NodeAffinity 的节点上
TaintTolerationPriority：优先调度到匹配 TaintToleration 的节点上
ServiceSpreadingPriority：尽量将同一个 service 的 Pod 分布到不同节点上，已经被 SelectorSpreadPriority 替代 [默认未使用]
EqualPriority：将所有节点的优先级设置为 1[默认未使用]
ImageLocalityPriority：尽量将使用大镜像的容器调度到已经下拉了该镜像的节点上 [默认未使用]
MostRequestedPriority：尽量调度到已经使用过的 Node 上，特别适用于 cluster-autoscaler[默认未使用]
