go语言之旅：[https://tour.go-zh.org/](https://tour.go-zh.org/)
如何使用go编程：[https://go-zh.org/doc/code.html](https://go-zh.org/doc/code.html)
时效go编程：[https://go-zh.org/doc/effective_go.html](https://go-zh.org/doc/effective_go.html)
golang安装包下载：[https://gomirrors.org/](https://gomirrors.org/)
go mod 代理地址：[https://goproxy.io/](https://goproxy.io/)

## bash
```bash
# Enable the go modules feature
export GO111MODULE=on
# Set the GOPROXY environment variable
export GOPROXY=https://goproxy.io
```
## PowerShell
```Powershell
# Enable the go modules feature
$env:GO111MODULE=on
# Set the GOPROXY environment variable
$env:GOPROXY=https://goproxy.io
```

## Go version >= 1.13
```
go env -w GOPROXY=https://goproxy.io, direct
# Set environment variable allow bypassing the proxy for selected modules
go env -w GOPRIVATE=*.corp.example.com
```
