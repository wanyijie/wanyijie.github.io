日志收集可能因机器性能而产生延迟，filebeat默认10秒扫描一次文件，收集时间集中也会导致日志按时间排序混乱，container处理器会降低日志写入时间的精度，所以提取java输出日志的时间有利于排序查看日志，java日志的写入时间大多精确到微秒，可能不足以正确排序，还可以借助filebeat 记录的offset排序。
具体实现采用elasticsearch 的 ingest 节点功能，使用grok processor 从java日志中提取时间，

# 定义 ingest pipeline, 注意时间格式:
参考：[grok-patterns](https://github.com/elastic/elasticsearch/blob/7.8/libs/grok/src/main/resources/patterns/grok-patterns)

```
PUT _ingest/pipeline/get_java_time
{
  "description": "get java time", 
  "processors": [
    {
      "grok": {
        "field": "message",
        "patterns": ["%{TIMESTAMP_ISO8601:logtime}"]
      }
    }
  ]
}
```
# 设置 mapping，明确时间格式，其它可以自行推断
```
PUT /filebeat-test
{
  "mappings": {
    "properties": {
      "logtime":    { "type": "date", "format": "yyyy-MM-dd HH:mm:ss.SSS"}
    }
  }
}
```

# 写入log:
```
PUT filebeat-test/_doc/1?pipeline=get_java_time
{
    "log": {
      "offset": 0,
      "file": {
        "path": "/jsonfile/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653-json.log"
      }
    },
    "input": {
      "type": "container"
    },
    "fields": {
      "stack": "test",
      "tenant": "default",
      "log_source": "test",
      "log_topic": "target_index",
      "environment": "192.168.5.47:6444",
      "path": "/jsonfile/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653/*.log",
      "pod": "rabbit-86c8bd6448-r7ffj",
      "service": "rabbit",
      "log_type": "application",
      "type": "message",
      "namespace": "test",
      "container": "rabbit"
    },
    "ecs": {
      "version": "1.1.0"
    },
    "agent": {
      "version": "7.5.2",
      "type": "filebeat",
      "ephemeral_id": "5adeace2-3d9d-4e97-9e1f-daae8ae1913c",
      "hostname": "node1",
      "id": "28ebc3e5-c3c1-4c7c-9a50-6204b7b39c00"
    },
    "message": "2020-07-21 07:25:16.840 [debug] <0.283.0> Lager installed handler error_logger_lager_h into error_logger",
    "tags": [
      "test",
      "test",
      "rabbit",
      "rabbit-86c8bd6448-r7ffj",
      "rabbit",
      "container",
      "self"
    ],
    "host": {
      "name": "node1"
    },
    "stream": "stdout"
  }
```

#查看结果，多了一个logtime字段，可用于确定日志时间和排序：
GET filebeat-test/_doc/1
```
{
  "_index" : "filebeat-test",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "agent" : {
      "hostname" : "node1",
      "id" : "28ebc3e5-c3c1-4c7c-9a50-6204b7b39c00",
      "type" : "filebeat",
      "ephemeral_id" : "5adeace2-3d9d-4e97-9e1f-daae8ae1913c",
      "version" : "7.5.2"
    },
    "log" : {
      "file" : {
        "path" : "/jsonfile/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653-json.log"
      },
      "offset" : 0
    },
    "message" : "2020-07-21 07:25:16.840 [debug] <0.283.0> Lager installed handler error_logger_lager_h into error_logger",
    "tags" : [
      "test",
      "test",
      "rabbit",
      "rabbit-86c8bd6448-r7ffj",
      "rabbit",
      "container",
      "self"
    ],
    "input" : {
      "type" : "container"
    },
    "ecs" : {
      "version" : "1.1.0"
    },
    "stream" : "stdout",
    "host" : {
      "name" : "node1"
    },
    "fields" : {
      "container" : "rabbit",
      "path" : "/jsonfile/98f01b2565052a41ca90cf94442b4bde85e77547547da008c64b90956f723653/*.log",
      "stack" : "test",
      "log_topic" : "target_index",
      "environment" : "192.168.5.47:6444",
      "log_type" : "application",
      "pod" : "rabbit-86c8bd6448-r7ffj",
      "service" : "rabbit",
      "log_source" : "test",
      "namespace" : "test",
      "type" : "message",
      "tenant" : "default"
    },
    "logtime" : "2020-07-21 07:25:16.840"
  }
}
```
