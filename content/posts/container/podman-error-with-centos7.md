---
summary: "Error: error creating libpod runtime: failed to mount overlay for metacopy check: invalid argument"
tags:
    - wangyijie
    - container
categories:
    - Development
    - Opetration
---
## system info:
```
# podman  info
host:
  BuildahVersion: 1.14.2
  CgroupVersion: v1
  Conmon:
    package: conmon-2.0.13-1.1.el7.x86_64
    path: /usr/bin/conmon
    version: 'conmon version 2.0.13, commit: eab756c90e2bdfa6fecf6616845ddcd9d3e339cb'
  Distribution:
    distribution: '"centos"'
    version: "7"
  MemFree: 408485888
  MemTotal: 952160256
  OCIRuntime:
    name: runc
    package: runc-1.0.0-15.1.el7.x86_64
    path: /usr/bin/runc
    version: |-
      runc version 1.0.0-rc10
      commit: 67b92f062188d9cb6472b428855432c9f35efcf5
      spec: 1.0.1-dev
  SwapFree: 0
  SwapTotal: 0
  arch: amd64
  cpus: 1
  eventlogger: journald
  hostname: test-server
  kernel: 3.10.0-1062.12.1.el7.x86_64
  os: linux
  rootless: false
  uptime: 51m 16.22s
registries:
  search:
  - registry.fedoraproject.org
  - registry.access.redhat.com
  - registry.centos.org
  - docker.io
store:
  ConfigFile: /etc/containers/storage.conf
  ContainerStore:
    number: 0
  GraphDriverName: overlay
  GraphOptions:
    overlay.mountopt: nodev
  GraphRoot: /var/lib/containers/storage
  GraphStatus:
    Backing Filesystem: xfs
    Native Overlay Diff: "true"
    Supports d_type: "true"
    Using metacopy: "false"
  ImageStore:
    number: 0
  RunRoot: /var/run/containers/storage
  VolumePath: /var/lib/containers/storage/volumes
```
## ERROR
```
#podman ps
Error: error creating libpod runtime: failed to mount overlay for metacopy check: invalid argument
```
 ![podman](https://upload-images.jianshu.io/upload_images/6000429-1eed6003e5a05638.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## solution
edit /etc/containers/storage.conf and remove metacopy.
https://github.com/containers/libpod/issues/3560#issuecomment-510630672

