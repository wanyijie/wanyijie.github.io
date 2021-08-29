我们在编写kubernetes资源清单的时候有很多细节不易记住，特别对于还不熟练的同学，寻找参考摸板是一件麻烦的事，下面介绍两种获取参考帮助的手段，足够大家无往不利
1.  kubectl get --export
kubectl get -o yaml --export
我们编写清单可以在集群找一个现成的资源摸板,然后修改我们想要的信息在以此创建新的资源，这能解决大部分需要了， kubectl get -o yaml --export 命令获得的资源内容就一个完美的摸板，-o yaml 用的比较多，--export 关注的可能就比较少，它的作用是把资源在当前集群的一些个性化数据过滤掉，给你一个清爽的摸板，去感受一下吧！
2.  kubectl explain 
有时我们通过上面的方法能找到的摸板可能没有我们要的配置，这时需要去别处寻找参考，或者去查看api文档，其实都可以不用，kubectl explain 可以根据资源路径给对应资源的子对象，就是其可以包含的字段或对象，比如看一个我不知道configMap卷怎么写的栗子：
```
[root@Registry ~]# kubectl explain deployments.spec.template.spec.volumes.configMap
RESOURCE: configMap <Object>

DESCRIPTION:
     ConfigMap represents a configMap that should populate this volume
    Adapts a ConfigMap into a volume.

FIELDS:
   defaultMode	<integer>
     Optional: mode bits to use on created files by default. Must be a value
     between 0 and 0777. Defaults to 0644. Directories within the path are not
     affected by this setting. This might be in conflict with other options that
     affect the file mode, like fsGroup, and the result can be other mode bits
     set.

   items	<[]Object>
     If unspecified, each key-value pair in the Data field of the referenced
     ConfigMap will be projected into the volume as a file whose name is the key
     and content is the value. If specified, the listed keys will be projected
     into the specified paths, and unlisted keys will not be present. If a key is
     specified which is not present in the ConfigMap, the volume setup will error
     unless it is marked optional. Paths must be relative and may not contain the
     '..' path or start with '..'.

   name	<string>
     Name of the referent. More info:
     https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names

   optional	<boolean>
     Specify whether the ConfigMap or it's keys must be defined
```
这样我们就可以了解到configMap下有三个子对象，分别是name, items, defaultMode, 并且items, defaultMode不是必须的。在进一步看items这个对象，我们就可以写出配置了，类型是Object或Object列表说名还有子对象。
```
  volumes: 
  -  configMap:
      defaultMode: 420
      name:  NAME
      items:
        key: keyname
        path:  group/my-username
```
挂载之后是什么形态可以亲自进入容器观摩一下，常用的做法是细写items, 默认是已key名做为文件名，里面存放值。
还有一点需要补充，学好英文，推荐一个学习网站：[https://www.duolingo.com/](https://www.duolingo.com/)
