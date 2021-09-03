openssl是个密码工具集，提供多端接口调用方式
组成: 
>  1. 代码库 libcryto ,libssl(ssl/tls)
> 2. 工具集 openssl 

## 对称加密
对称加密主要是用aes，des算法
usage: 
```
-in <file>     input file
-out <file>    output file 加密后的文件存放位置
-pass <arg>    pass phrase source
-e             encrypt  指定加密算法
-d             decrypt  指定解密算法
-a/-base64     base64 encode/decode, depending on encryption flag   #使用base64编/解码
-k             passphrase is the next argument   指定密码
-kfile         passphrase is the first line of the file argument
-md            the next argument is the md to use to create a key
                 from a passphrase.  One of md2, md5, sha or sha1
-S             salt in hex is the next argument
-K/-iv         key/iv in hex is the next argument 
-[pP]          print the iv/key (then exit if -P)
-bufsize <n>   buffer size
-nopad         disable standard block padding
-engine e      use engine e, possibly a hardware device.
Cipher Types
-aes-128-cbc               -aes-128-ccm               -aes-128-cfb
...
```


## 加密:
```
cat 123.txt
openssl.exe enc -e -aes-128-cbc -in 123.txt  -k qqqq -out 321.txt
```
## 解密:
```
openssl.exe enc -d -aes-128-cbc -in 321.txt  -k qqqq  -out 456.txt
cat  456.txt
```
