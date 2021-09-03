**10.240.0.4是remoteserver后面的主机，把访问本机5500端口的流量通过remoteserver转发到10.240.0.4**
demo自己参照理解
ssh -L 5500:10.240.0.4:3389   remoteserver
mstsc.exe /v:localhost:5500
