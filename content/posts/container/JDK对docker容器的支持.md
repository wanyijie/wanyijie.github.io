## java8及java9

Java 8u131及以上版本开始支持了Docker的cpu和memory限制。

### cpu limit

即如果没有显式指定-XX:ParalllelGCThreads 或者 -XX:CICompilerCount, 那么JVM使用docker的cpu限制。如果docker有指定cpu limit，jvm参数也有指定-XX:ParalllelGCThreads 或者 -XX:CICompilerCount，那么以指定的参数为准。

### memory limit

在java8u131+及java9，需要加上-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap才能使得Xmx感知docker的memory limit。

***查看参数默认值***

```
java -XX:+UnlockDiagnosticVMOptions -XX:+UnlockExperimentalVMOptions -XX:+PrintFlagsFinal
```

部分输出

```
bool UseCGroupMemoryLimitForHeap = false {experimental} {default}
```

> 可以看到在java9，UseCGroupMemoryLimitForHeap参数还是实验性的，默认关闭。

## java10

```
bool UseCGroupMemoryLimitForHeap = false {experimental} {default}
```

> java10，UseCGroupMemoryLimitForHeap还是experimental，不过标记为废弃。

不过java10新引入了1个参数

```
int ActiveProcessorCount = -1 {product} {default}
```

> ActiveProcessorCount可以用来指定cpu的个数

## java11

java11正式移除UseCGroupMemoryLimitForHeap，代码改动见[8194086: Remove deprecated experimental flag UseCGroupMemoryLimitForHeap](http://hg.openjdk.java.net/jdk/jdk/rev/48b6b247eb7a)

同时引入1个新参数

```
bool UseContainerSupport = true {product} {default}
```

> UseContainerSupport默认为true，可以使用-Xlog:os+container=trace参数来查看详情。
> 即使使用-XX:-UseContainerSupport禁用了容器支持，-XX:ActiveProcessorCount如果有指定，该参数值仍然会被使用。

## 小结

| 参数/版本 | -XX:+UseCGroupMemoryLimitForHeap | -XX:ActiveProcessorCount | -XX:+UseContainerSupport |
| --- | --- | --- | --- |
| java9 | experimental，默认false | 无 | 无 |
| java10 | experimental，默认false | -1 | 无 |
| java11 | 移除 | -1 | product，默认true |


