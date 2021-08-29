考cka需要整理kubernetes的知识，看了linux基金会的课程，感觉有点贵，赚钱不容易得到刀刃上，所以看下目录帮助熟悉学习目标即可

Kubernetes 基础课程 （LFS258)
## Chapter 1. Course Introduction
> Welcome
1.1. Before You Begin
1.2. Course Introduction
1.3. Course Objectives
1.4. Course Formatting  安排
1.5. Course Completion 
1.6. Course Timing
1.7.a. Exercises-Lab Environment
1.7.b. Exercises-Labs
1.7.c. Exercises - Knowledge Check
1.8. Course Resources
1.9. Class Forum Guidelines
1.10. Course Support
1.11. Course Audience and Requirements
1.12. Software Environment
1.13. Which Distribution to Choose?
1.14. Red Hat Family
1.15. SUSE Family
1.16. Debian Family
1.17. New Distribution Similarities
1.18. AWS Free Tier
1.19. Meet Your Instructor: Tim Serewicz ...
1.20. A Word from Tim Serewicz
1.21. The Linux Foundation
1.22. The Linux Foundation Events
1.23. Training Venues
1.24. The Linux Foundation Training Offer...
1.25. The Linux Foundation Certifications...
1.26. Training/Certification Firewall
1.27. Open Source Guides for the Enterpri...
1.28. Lab 1.1 - Configuring the System fo...
1.29. Copyright

## Chapter 2. Basics of Kubernetes
> 2.1. Basics of Kubernetes
2.2. Introduction
2.3. Learning Objectives
2.4. What Is Kubernetes?
2.5. Components of Kubernetes
2.6. Challenges
2.7. Other Solutions
2.8.a. The Borg Heritage 遗产
2.8.b. The Borg Heritage (Cont.)
2.9.a. Kubernetes Architecture
2.9.b. Kubernetes Architecture (Cont.)
2.10. Terminology 术语
2.11. Innovation 创新
2.12. User Community
2.13. Tools
2.14. The Cloud Native Computing Foundati...
2.15. Resource Recommendations
2.16. Lab 2.1 - View Online Resources
2.17.a. Knowledge Check 2.1
2.17.b. Knowledge Check 2.2
2.17.c. Knowledge Check 2.3
2.17.d. Knowledge Check 2.4

## Chapter 3. Installation and Configuration
> 3.1. Installation and Configuration
3.2. Introduction
3.3. Learning Objectives
3.4. Installation Tools
3.5. Installing kubectl
3.6. Using Google Kubernetes Engine (GKE)...
3.7. Using Minikube
> 3.8. Installing with kubeadm
3.9. Installing a Pod Network
3.10. More Installation Tools
3.11. Installation Considerations
3.12. Main Deployment Configurations
3.13.a. Systemd Unit File for Kubernetes ...
3.13.b. Systemd Unit Files for Kubernetes...
3.14. Using Hyperkube
3.15. Compiling from Source
3.16. Lab 3.1 - Install Kubernetes
3.17. Lab 3.2 - Grow the Cluster
3.18. Lab 3.3 - Finish Cluster Setup
3.19. Lab 3.4 - Deploy a Simple Applicati...
3.20. Lab 3.5 - Access from Outside the C...
3.21.a. Knowledge Check 3.1
3.21.b. Knowledge Check 3.2
3.21.c. Knowledge Check 3.3
3.21.d. Knowledge Check 3.4

## Chapter 4. Kubernetes Architecture
> 4.1. Kubernetes Architecture
4.2. Introduction
4.3. Learning Objectives
4.4.a. Main Components
4.4.b. Main Components (Cont.)
4.5. Master Node
4.6. kube-apiserver
4.7. kube-scheduler
4.8. etcd Database
4.9. Other Agents
4.10. Worker Nodes
4.11. kubelet
4.12. Services
> 4.13. Controllers
> 4.14. Pods
4.15. Containers
4.16.a. Component Review
4.16.b. Component Review
4.17. Node
4.18. Single IP per Pod
4.19. Container to Outside Path
4.20. Networking Setup
4.21.a. CNI Network Configuration File
> 4.21.b. CNI Network Configuration File (C...
4.22. Pod-to-Pod Communication
4.23. Mesos
4.24. Lab 4.1 - Working with CPU and Memo...
4.25. Lab 4.2 - Resource Limits for a Nam...
4.26. Lab 4.3 - More Complex Deployment
4.27.a. Knowledge Check 4.1
4.27.b. Knowledge Check 4.2
4.27.c. Knowledge Check 4.3
4.27.d. Knowledge Check 4.4
4.27.e. Knowledge Check 4.5

## Chapter 5. APIs and Access
> 5.1. APIs and Access
5.2. Introduction
5.3. Learning Objectives
5.4. API Access
5.5. RESTful
5.6. Checking Access
5.7. Optimistic Concurrency 乐观并发
5.8. Using Annotations
> 5.9. Simple Pod
> 5.10. Manage API Resources with kubectl
5.11. Access from Outside the Cluster
5.12.a. ~/.kube/config
5.12.b. ~/.kube/config (Cont.)
5.13. Namespaces
5.14. Working with Namespaces
5.15. API Resources with kubectl
5.16. Additional Resource Methods
5.17. Swagger
5.18. API Maturity
5.19. Lab 5.1 - Configuring TLS Access
5.20. Lab 5.2 - Explore API Calls
5.21.a. Knowledge Check 5.1
5.21.b. Knowledge Check 5.2
5.21.c. Knowledge Check 5.3
5.21.d. Knowledge Check 5.4
5.21.e. Knowledge Check 5.5

## Chapter 6. API Objects
> 6.1. API Objects
6.2. Introduction
6.3. Learning Objectives
6.4. Overview
6.5. v1 API Group
6.6. Discovering API Groups
6.7. Deploying an Application
6.8. DaemonSets
6.9. StatefulSet
6.10. Autoscaling
6.11. Jobs
6.12. RBAC
6.13. Lab 6.1 - RESTful API Access
6.14. Lab 6.2 - Using the Proxy
6.15. Lab 6.3 - Working with Jobs
6.16.a. Knowledge Check 6.1
6.16.b. Knowledge Check 6.2
6.16.c. Knowledge Check 6.3
6.16.d. Knowledge Check 6.4
6.16.e. Knowledge Check 6.5
6.16.f. Knowledge Check 6.6

## Chapter 7. Managing State with Deployments
> 7.1. Managing State with Deployments
7.2. Introduction
7.3. Learning Objectives
7.4. Overview
7.5. Deployments
7.6.a. Object Relationship
7.6.b. Object Relationship
7.7. Deployment Details
7.8.a. Deployment Configuration Metadata
7.8.b. Deployment Configuration Metadata ...
7.9.a. Deployment Configuration Spec
7.9.b. Deployment Configuration Spec (Con...
7.10.a. Deployment Configuration Pod Temp...
7.10.b. Deployment Configuration Pod Temp...
7.10.c. Deployment Configuration Pod Temp...
7.11. Deployment Configuration Status
7.12. Scaling and Rolling Updates
7.13.a. Deployment Rollbacks
7.13.b. Deployment Rollbacks (Cont.)
7.14. Using DaemonSets
7.15.a. Labels
7.15.b. Labels (Cont.)
7.16. Lab 7.1 - Working with ReplicaSets
7.17. Lab 7.2 - Working with DaemonSets
7.18. Lab 7.3 - Rolling Updates and Rollb...
7.19.a. Knowledge Check 7.1
7.19.b. Knowledge Check 7.2
7.19.c. Knowledge Check 7.3
7.19.d. Knowledge Check 7.4
7.19.e. Knowledge Check 7.5

## Chapter 8. Services
> 8.1. Services
8.2. Introduction
8.3. Learning Objectives
8.4. Services Overview
8.5. Service Update Pattern
8.6.a. Accessing an Application with a Se...
8.6.b. Accessing an Application with a Se...
8.7. Service Types
8.8. Services Diagram
8.9. Local Proxy for Development
8.10. DNS
8.11.a. Verifying DNS Registration
> 8.11.b. Verifying DNS Registration (Cont....
8.12. Lab 8.1 - Deploy a New Service
8.13. Lab 8.2 - Configure a NodePort
8.14. Lab 8.3 - Use Labels to Manage Reso...
8.15.a. Knowledge Check 8.1
8.15.b. Knowledge Check 8.2
8.15.c. Knowledge Check 8.3
8.15.d. Knowledge Check 8.4

## Chapter 9. Volumes and Data
> 9.1. Volumes and Data
9.2. Introduction
9.3. Learning Objectives
9.4. Volumes Overview
9.5.a. Introducing Volumes
9.5.b. Introducing Volumes (Cont.)
9.6. Volume Spec
9.7. Volume Types
9.8. Shared Volume Example
9.9. Persistent Volumes and Claims
9.10. Persistent Volume
9.11.a. Persistent Volume Claim
9.11.b. Persistent Volume Claim (Cont.)
9.12. Dynamic Provisioning
9.13.a. Secrets
9.13.b. Secrets (Cont.)
9.14. Using Secrets via Environment Varia...
9.15. Mounting Secrets as Volumes
9.16.a. Portable Data with ConfigMaps
9.16.b. Portable Data with ConfigMaps (Co...
9.17. Using ConfigMaps
9.18. Lab 9.1 - Create a ConfigMap
9.19. Lab 9.2 - Creating a Persistent NFS...
9.20. Lab 9.3 - Creating a Persistent Vol...
9.21. Lab 9.4 - Use a ResourceQuota to Li...
9.22.a. Knowledge Check 9.1
9.22.b. Knowledge Check 9.2
9.22.c. Knowledge Check 9.3
9.22.d. Knowledge Check 9.4
9.22.e. Knowledge Check 9.5

## Chapter 10. Ingress
> 10.1. Ingress
10.2. Introduction
10.3. Learning Objectives
10.4. Ingress Overview
10.5. Ingress Controller
10.6. nginx
10.7. Google Load Balancer Controller (GL...
10.8. Ingress API Resources
10.9. Deploying the Ingress Controller
10.10. Creating an Ingress Rule
10.11. Multiple Rules
10.12. Lab 10.1 - Advanced Service Exposu...
10.13.a. Knowledge Check 10.1
10.13.b. Knowledge Check 10.2
10.13.c. Knowledge Check 10.3

## Chapter 11. Scheduling
> 11.1. Scheduling
11.2. Introduction
11.3. Learning Objectives
11.4. kube-scheduler
11.5. Predicates
11.6. Priorities
11.7.a. Scheduling Policies
11.7.b. Scheduling Policies (Cont.)
11.8. Pod Specification
11.9. Specifying the Node Label
11.10. Pod Affinity Rules
11.11. podAffinity Example
11.12. podAntiAffinity Example
11.13. Node Affinity Rules
11.14. Node Affinity Example
11.15. Taints
11.16. Tolerations
11.17. Custom Scheduler
11.18. Lab 11.1 - Assign Pods Using Label...
11.19. Lab 11.2 - Using Taints to Control...
11.20.a. Knowledge Check 11.1
> 11.20.b. Knowledge Check 11.2
11.20.c. Knowledge Check 11.3
11.20.d. Knowledge Check 11.4

## Chapter 12. Logging and Troubleshooting
> 12.1. Logging and Troubleshooting
12.2. Introduction
12.3. Learning Objectives
12.4. Overview
12.5. Basic Troubleshooting Steps
12.6. Cluster Start Sequence
12.7. Monitoring
12.8. Logging Tools
> 12.9. More Resources
12.10. Lab 12.1 - Review Log File Locatio...
12.11. Lab 12.2 - Viewing Logs Output
12.12. Lab 12.3 - Adding Tools for Monito...
12.13.a. Knowledge Check 12.1
12.13.b. Knowledge Check 12.2

## Chapter 13. Custom Resource Definitions
> 13.1. Custom Resource Definitions
> 13.2. Introduction
13.3. Learning Objectives
13.4. Custom Resources
13.5. Custom Resource Definitions
13.6. Configuration Example
> 13.7. New Object Configuration
13.8. Optional Hooks
13.9. Understanding Aggregated APIs (AA)
13.10. Lab 13.1 - Create a Custom Resourc...
13.11.a. Knowledge Check 13.1
13.11.b. Knowledge Check 13.2
13.11.c. Knowledge Check 13.3

## Chapter 14. Kubernetes Federations
> 14.1. Kubernetes Federations
14.2. Introduction
14.3. Learning Objectives
14.4. Cluster Federation
14.5. Version 1 Federated Control Plane
14.6.a. Version 2 Federated Control Plane...
14.6.b. Version 2 Federated Control Plane...
14.7. Switching between Clusters
14.8.a. Building a Federation with kubefe...
14.8.b. Building a Federation with kubefe...
14.9. Using Federated Resources
14.10. Federation API Resources
> 14.11. Balancing ReplicaSets
> 14.12.a. Knowledge Check 14.1
14.12.b. Knowledge Check 14.2
14.12.c. Knowledge Check 14.3

## Chapter 15. Helm
> 15.1. Helm
15.2. Introduction
15.3. Learning Objectives
15.4. Deploying Complex Applications
15.5. Tiller and Helm Client
15.6. Chart Contents
15.7. Templates
15.8. Initializing Helm
15.9. Chart Repositories
15.10.a. Deploying a Chart
15.10.b. Deploying a Chart (Cont.)
15.11. Lab 15.1 - Working with Helm and C...
15.12.a. Knowledge Check 15.1
15.12.b. Knowledge Check 15.2
15.12.c. Knowledge Check 15.3
15.12.d. Knowledge Check 15.4

##Chapter 16. Security
> 16.1. Security
16.2. Introduction
16.3. Learning Objectives
16.4. Overview
16.5.a. Accessing the API
16.5.b. Accessing the API (Cont.)
16.6. Authentication
16.7. Authorization
16.8. ABAC
16.9. RBAC
16.10. RBAC Process Overview
16.11. Admission Controller
16.12. Security Contexts
16.13.a. Pod Security Policies
16.13.b. Pod Security Policies (Cont.)
16.14. Network Security Policies
16.15.a. Network Security Policy Example
16.15.b. Network Security Policy Example ...
16.16.a. Default Policy Example
16.16.b. Default Policy Example (Cont.)
16.17. Lab 16.1 - Working with TLS
16.18. Lab 16.2 - Authentication and Auth...
16.19. Lab 16.3 - Admission Controllers
16.20.a. Knowledge Check 16.1
16.20.b. Knowledge Check 16.2
16.20.c. Knowledge Check 16.3
Course Completion

