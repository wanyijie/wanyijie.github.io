## 现象
通过grafana查看部分容器没有监控数据
## 关键信息
通过查看influxdb发现异常日志
```
[write] 2019/04/25 09:56:05 write failed for shard 170: max-series-per-database limit exceeded: db=k8s (1000000/1000000) dropped=2111
[httpd] 172.16.3.10 - root [25/Apr/2019:09:56:05 +0000] "POST /write?consistency=&db=k8s&precision=&rp=default HTTP/1.1" 400 115 "-" "heapster/v1.5.1" 579d5b31-6740-11e9-8057-000000000000 156302
```
日志提示有序列超出了最大数限制：
查看文档有对应的参数：
![influxdb.png](https://upload-images.jianshu.io/upload_images/6000429-19a2603408699daf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
##解决方法：
添加环境变量覆盖参数：
```
      - image: registry-vpc.cn-shenzhen.aliyuncs.com/acs/heapster-influxdb-amd64:v1.1.1
        imagePullPolicy: IfNotPresent
        name: influxdb
        env:
        - name: INFLUXDB_DATA_MAX_SERIES_PER_DATABASE
          value: "0"
        - name: INFLUXDB_DATA_MAX_VALUES_PER_TAG
          value: "0"
```
变量值需加引号
## 验证方法
influxdb没有图形界面了，命令工具也不易安装，curl最方便，不过格式需要注意，我参照了许多才找到合适的，记录个例子：
```
curl http://172.21.11.108:8086/query?pretty=true --data-urlencode "db=k8s" --data-urlencode "q=SELECT * FROM \"cpu/usage\" WHERE (\"type\" = 'pod' AND \"namespace_name\" =~ /^blue$/) AND  time >= now() - 30m"
```
