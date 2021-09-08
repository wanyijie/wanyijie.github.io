---
summary: "netsh interface portproxy add v4tov4 listenaddress=172.20.0.2 listenport=1521 connectaddress=172.16.100.74 connectport=1521"
tags:
    - wangyijie
    - network
categories:
    - Opetration
---
## example 
```
netsh interface portproxy add v4tov4 listenaddress=172.20.0.2 listenport=1521 connectaddress=172.16.100.74 connectport=1521
netsh interface portproxy add v4tov4 listenaddress=172.20.0.2 listenport=1433 connectaddress=172.16.100.73 connectport=1433
```

## 删除
netsh interface portproxy delete v4tov4 listenport=3340 listenaddress=10.1.1.110
netsh.exe interface portproxy delete v4tov4 listenport=1521 listenaddress=172.20.0.2

## 清除所有当前的端口转发规则：

netsh interface portproxy reset
