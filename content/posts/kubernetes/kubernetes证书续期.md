---
summary: "kubeadm 默认证书为一年，一年过期后，会导致api service不可用，使用过程中会出现：x509: certificate has expired or is not yet valid"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
kubeadm 默认证书为一年，一年过期后，会导致api service不可用，使用过程中会出现：x509: certificate has expired or is not yet valid.

方案一 通过修改kubeadm 调整证书过期时间
# 一、使用kubadm 更新证书
##  1. 查看证书有效期
```
kubeadm alpha certs check-expiration
```
##  2. 重新签发证书
```
kubeadm  alpha certs renew admin.conf
kubeadm  alpha certs renew scheduler.conf 
kubeadm  alpha certs renew controller-manager.conf
```

## 3. 重启控制平面使生效
重启kubelet会自动重新创建核心组件
```
systemctl restart kubelet
```
## 4. 验证
```kubeadm alpha certs check-expiration```

#  二、创建长期有效期证书
自己创建这四个文件需要的证书，替换四个文件使用的内嵌证书。我们自己创建的证书的有效期为50年，不再有过期的风险。步骤如下：
## 生成证书：
```
cd /etc/kubernetes
mkdir cert
cd cert/
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "438000h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "438000h"
      }
    }
  }
}
EOF
cat > admin-csr.json << EOF
{
  "CN": "kubernetes-admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Guangdong",
      "L": "Shenzhen",
      "O": "system:masters",
      "OU": "Wise2C"
    }
  ]
}
EOF

cat > controller-manager-csr.json << EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF

cat > scheduler-csr.json << EOF
{
  "CN": "system:scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF
```


### 生成admin证书
```
cfssl gencert -ca=/etc/kubernetes/pki/ca.crt -ca-key=/etc/kubernetes/pki/ca.key -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
```
### 生成controller-manager证书
```
cfssl gencert -ca=/etc/kubernetes/pki/ca.crt -ca-key=/etc/kubernetes/pki/ca.key -config=ca-config.json -profile=kubernetes controller-manager-csr.json | cfssljson -bare controller-manager
```
### 生成scheduler证书
```
cfssl gencert -ca=/etc/kubernetes/pki/ca.crt -ca-key=/etc/kubernetes/pki/ca.key -config=ca-config.json -profile=kubernetes scheduler-csr.json | cfssljson -bare scheduler
```
### 放置到正确的位置
```
cp *.pem /etc/kubernetes/pki/
```

## 替换内嵌证书为刚刚生成的证书，可以用如下脚本：
```
#!/bin/bash
cd /etc/kubernetes/

sed -i.bak 's#client-certificate-data:.*$#client-certificate: /etc/kubernetes/pki/admin.pem#g' admin.conf
sed -i 's#client-key-data:.*$#client-key: /etc/kubernetes/pki/admin-key.pem#g' admin.conf

sed -i.bak 's#client-certificate-data:.*$#client-certificate: /etc/kubernetes/pki/controller-manager.pem#g' controller-manager.conf 
sed -i 's#client-key-data:.*$#client-key: /etc/kubernetes/pki/controller-manager-key.pem#g' controller-manager.conf
```
## 由于schedule的证书文件没有挂载到pod内，所以我们还需要手动修改#/etc/kubernetes/manifests文件夹内kube-scheduler.yaml文件，添加挂载主机目录的#volume
```
sed -i.bak 's#client-certificate-data:.*$#client-certificate: /etc/kubernetes/pki/scheduler.pem#g' scheduler.conf 
sed -i 's#client-key-data:.*$#client-key: /etc/kubernetes/pki/scheduler-key.pem#g' scheduler.conf
```
