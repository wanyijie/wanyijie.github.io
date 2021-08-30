## 概述
HTTPS服务是工作在SSL/TLS上的HTTP。 
首先简单区分一下HTTPS，SSL ，TLS ，OpenSSL这四者的关系：
SSL：（Secure Socket Layer，安全套接字层）是在客户端和服务器之间建立一条SSL安全通道的安全协议；
TLS：（Transport Layer Security，传输层安全协议），用于两个应用程序之间提供保密性和数据完整性；
TLS的前身是SSL；
OpenSSL是TLS/SSL协议的开源实现，提供开发库和命令行程序；
HTTPS是HTTP的加密版，底层使用的加密协议是TLS。
结论：SSL/TLS 是协议，OpenSSL是协议的代码实现。

用OpenSSL配置带有SubjectAltName的ssl请求
对于多域名，只需要一个证书就可以保护非常多的域名。 
SubjectAltName是X509 Version 3 (RFC 2459)的扩展，允许ssl证书指定多个可以匹配的名称。

SubjectAltName 可以包含email 地址，ip地址，正则匹配DNS主机名，等等。 
ssl这样的一个特性叫做：SubjectAlternativeName（简称：san）

## 生成证书请求文件
对于一个通用的ssl证书请求文件（CSR），openssl不需要很多操作。 
因为我们可能需要添加一个或者两个SAN到我们CSR，我们需要在openssl配置文件中添加一些东西：你需要告诉openssl创建一个包含x509 V3扩展的CSR，并且你也需要告诉openssl在你的CSR中包含subject alternative names列表。

创建一个openssl配置文件（openssl.cnf），并启用subject alternative names：

找到req段落。这段落的内容将会告诉openssl如何去处理证书请求（CSR）。 
在req段落中应该要包含一个以req_extensions开始的行。如下：
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

这个配置是告诉openssl在CSR中要包含v3_req段落的部分。 
现在我们来配置v3_req，如下：
```
[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = US
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = MN
localityName = Locality Name (eg, city)
localityName_default = Minneapolis
organizationalUnitName  = Organizational Unit Name (eg, section)
organizationalUnitName_default  = Domain Control Validated
commonName = Internet Widgits Ltd
commonName_max  = 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = kb.example.com
DNS.2 = helpdesk.example.org
DNS.3 = systems.example.net
IP.1 = 192.168.1.1
IP.2 = 192.168.69.14
```

请注意：无论`v3_req`放哪里，都是可以的，都会在所有生成的`CSR`中。 
要是之后，你又想生成一个不同的`SANs`的`CSR`文件，你需要编辑这个配置文件，并改变`DNS.x`列表。

# 生成私钥

首先我们创建一个私钥：
```
openssl genrsa -out san_domain_com.key 2048
# 如果是生成ca的使用，建议这样
openssl genrsa -out ca.key 2048
```
这里的san_domain_com，是你正式使用的服务器的全称地址
创建CSR文件
执行下面语句
```
openssl req -new -out san_domain_com.csr -key san_domain_com.key -config openssl.cnf
# 注意这里指定了openssl.cnf，使用了上面我们创建的，因为默认是没有`san`。
# 如果之前创建的是ca.key
openssl req -new -out ca.csr -key c.key -confaig openssl.cnf
```
执行后，系统会提示你要你输入组织信息，并询问你是否想要包含密码（你可以不需要）。接着你将会看到san_domain_com.csr被创建。

检查我们是否创建好了，我们可以使用下面的命令来查看CSR包含的信息：
```
openssl req -text -noout -in san_domain_com.csr
# 如果是ca.csr
openssl req -text -noout -in ca.csr
```
自签名并创建证书
```
openssl x509 -req -days 3650 -in san_domain_com.csr -signkey san_domain_com.key
 -out san_domain_com.crt-extensions v3_req -extfile openssl.cnf

# 如果是ca.csr
openssl x509 -req -days 3650 -in ca.csr -signkey ca.key
 -out ca.crt-extensions v3_req -extfile openssl.cnf
```
<script src="https://utteranc.es/client.js" repo="wanyijie/blog" issue-term="pathname" label="web"
      theme="github-light" crossorigin="anonymous" async>
      </script>