java日志出现错误的时候日志不再是一条一行，可能出来换行，这不适应默认的日志采集方式，正确的做法是使用规则确定行的开始，到下一个开始才是一行的结束，主流的日志收集插件都支持多行的配置定义。现在多用容器运行服务，日志输出到标准输出，这样使用日志采集工具去采集通过docker存储的日志文件，日志包含在json文本中，采集策略得对于调整。

<!--more-->

在filebeat中使用container解析器，设置多行合并参数即可，细节如下：
# 开始流程：
## filebeat配置: filebeat.yml
```yaml
filebeat.config.inputs:
  enabled: true
  path: inputs.d/*.yml
  reload.enabled: true
  reload.period: 10s
filebeat.config.modules.path: ${path.config}/modules.d/*.yml
output.elasticsearch:
  enabled: false
  hosts: '127.0.0.1:9200'
  username: '${ELASTICSEARCH_USERNAME:}'
  password: '${ELASTICSEARCH_PASSWORD:}'
output.file:
  enabled: false
  path: "/tmp/filebeat"
  filename: filebeat
output.console:
  pretty: true
  enabled: true
```
## 日志收集配置： cat inputs.d/java.yml 
```yml
- type: container
  multiline.pattern: '^2020-07-15'
  multiline.negate: true
  multiline.match: after
  json.message_key: log
 # json.keys_under_root: false
  overwrite_keys: true
  paths:
    - /var/log/err.log

```
## 日志示例：/var/log/err.log 
```
{"log":"2020-07-15 03:15:35 [INFO ] [main] org.springframework.context.support.PostProcessorRegistrationDelegate$BeanPostProcessorChecker - Bean 'shiroProperyConfig' of type [com.wwtx.chinesemedicine.service.config.propery.ShiroProperyConfig$$EnhancerBySpringCGLIB$$b7434c17] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)\n","stream":"stdout","time":"2020-07-15T03:15:35.819881438Z"}
{"log":"Logging initialized using 'class org.apache.ibatis.logging.stdout.StdOutImpl' adapter.\n","stream":"stdout","time":"2020-07-15T03:15:35.968119304Z"}
{"log":"2020-07-15 03:15:36 [INFO ] [main] org.springframework.context.support.PostProcessorRegistrationDelegate$BeanPostProcessorChecker - Bean 'org.springframework.boot.autoconfigure.jdbc.DataSourceInitializerInvoker' of type [org.springframework.boot.autoconfigure.jdbc.DataSourceInitializerInvoker] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)\n","stream":"stdout","time":"2020-07-15T03:15:36.428202427Z"}
{"log":"Registered plugin: 'AbstractSqlParserHandler(sqlParserList=null, sqlParserFilter=null)'\n","stream":"stdout","time":"2020-07-15T03:15:36.51131214Z"}
{"log":"Parsed mapper file: 'class path resource [mapper/ArticlesHitsMapper.xml]'\n","stream":"stdout","time":"2020-07-15T03:15:36.877433778Z"}
{"log":"[com.wwtx.chinesemedicine.service.dao.ArticlesDao.selectById] Has been loaded by XML or SqlProvider or Mybatis's Annotation, so ignoring this injection for [class com.baomidou.mybatisplus.core.injector.methods.SelectById]\n","stream":"stdout","time":"2020-07-15T03:15:36.963122274Z"}
{"log":"Parsed mapper file: 'class path resource [mapper/ArticlesMapper.xml]'\n","stream":"stdout","time":"2020-07-15T03:15:36.99978738Z"}

```
##  启动运行：filebeat -e -strict.perms=false

## 采集后七条日志变成了两条
```json
{
  "@timestamp": "2020-07-15T03:15:35.819Z",
  "@metadata": {
    "beat": "filebeat",
    "type": "_doc",
    "version": "7.8.0"
  },
  "input": {
    "type": "container"
  },
  "ecs": {
    "version": "1.5.0"
  },
  "host": {
    "name": "1b6f43203770"
  },
  "agent": {
    "name": "1b6f43203770",
    "type": "filebeat",
    "version": "7.8.0",
    "hostname": "1b6f43203770",
    "ephemeral_id": "ebaa6a78-bb7f-4399-89ca-baad22b8e535",
    "id": "d00521ba-c888-4bed-a7fb-ae20731871e9"
  },
  "log": {
    "offset": 0,
    "file": {
      "path": "/var/log/err.log"
    },
    "flags": [
      "multiline"
    ]
  },
  "stream": "stdout",
  "json": {},
  "message": "2020-07-15 03:15:35 [INFO ] [main] org.springframework.context.support.PostProcessorRegistrationDelegate$BeanPostProcessorChecker - Bean 'shiroProperyConfig' of type [com.wwtx.chinesemedicine.service.config.propery.ShiroProperyConfig$$EnhancerBySpringCGLIB$$b7434c17] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)\nLogging initialized using 'class org.apache.ibatis.logging.stdout.StdOutImpl' adapter."
}
{
  "@timestamp": "2020-07-15T03:15:36.428Z",
  "@metadata": {
    "beat": "filebeat",
    "type": "_doc",
    "version": "7.8.0"
  },
  "input": {
    "type": "container"
  },
  "ecs": {
    "version": "1.5.0"
  },
  "host": {
    "name": "1b6f43203770"
  },
  "agent": {
    "hostname": "1b6f43203770",
    "ephemeral_id": "ebaa6a78-bb7f-4399-89ca-baad22b8e535",
    "id": "d00521ba-c888-4bed-a7fb-ae20731871e9",
    "name": "1b6f43203770",
    "type": "filebeat",
    "version": "7.8.0"
  },
  "log": {
    "file": {
      "path": "/var/log/err.log"
    },
    "flags": [
      "multiline"
    ],
    "offset": 605
  },
  "stream": "stdout",
  "json": {},
  "message": "2020-07-15 03:15:36 [INFO ] [main] org.springframework.context.support.PostProcessorRegistrationDelegate$BeanPostProcessorChecker - Bean 'org.springframework.boot.autoconfigure.jdbc.DataSourceInitializerInvoker' of type [org.springframework.boot.autoconfigure.jdbc.DataSourceInitializerInvoker] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)\nRegistered plugin: 'AbstractSqlParserHandler(sqlParserList=null, sqlParserFilter=null)'\nParsed mapper file: 'class path resource [mapper/ArticlesHitsMapper.xml]'\n[com.wwtx.chinesemedicine.service.dao.ArticlesDao.selectById] Has been loaded by XML or SqlProvider or Mybatis's Annotation, so ignoring this injection for [class com.baomidou.mybatisplus.core.injector.methods.SelectById]\nParsed mapper file: 'class path resource [mapper/ArticlesMapper.xml]'"
}
```

