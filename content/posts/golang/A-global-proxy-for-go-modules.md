
First, you will need to enable the Go Modules feature and configure Go to use the proxy.
bash:
```
export GOPROXY=https://goproxy.io
```
Or
powershell:
```
$env:GOPROXY = "https://goproxy.io"
```
Now, when you build and run your applications, go will fetch dependencies via goproxy.io.

Note: This proxy can't fetch your private repos of course.

# Private proxy

## Started

```
./goproxy -listen=0.0.0.0:80 -cacheDir=/data
```

## Use docker image
```
docker run -d -p80:8081 goproxy/goproxy

```

Use the -v flag to persisting the proxy module data (change ***cacheDir*** to your own dir):

```
docker run -d -p80:8081 -v cacheDir:/go goproxy/goproxy
```
