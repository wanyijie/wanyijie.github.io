---
summary: "deploy elasticsearch persistent volume"
tags:
    - wangyijie
    - kubernetes
categories:
    - Development
    - Opetration
---
## deploy elasticsearch persistent volume
```
cat pv-master.yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: efk-master-volume
  labels:
    type: localspec:
  storageClassName: elasticsearch-master
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data/efk-master"
mkdir -p /mnt/data/efk-master && kubectl create -f pv-master.yaml
```
### data
```
cat pv-data.yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: efk-data-volume
  labels:
    type: local
spec:
  storageClassName: elasticsearch-data
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data/efk-data"
mkdir -p /mnt/data/efk-data && kubectl create -f pv-data.yaml
```
## deploy elasticsearch
kubectl create namespace logs
helm install elasticsearch stable/elasticsearch --namespace=logs \
--set client.replicas=1 \
--set master.replicas=1 \
--set cluster.env.MINIMUM_MASTER_NODES=1 \
--set cluster.env.RECOVER_AFTER_MASTER_NODES=1 \
--set cluster.env.EXPECTED_MASTER_NODES=1 \
--set data.replicas=1 \
--set data.heapSize=300m \
--set master.persistence.storageClass=elasticsearch-master \
--set master.persistence.size=5Gi \
--set data.persistence.storageClass=elasticsearch-data \
--set data.persistence.size=5Gi

### template
```
---
# Source: elasticsearch/templates/client-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "client"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-client
---
# Source: elasticsearch/templates/data-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "data"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-data
---
# Source: elasticsearch/templates/master-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "master"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-master
---
# Source: elasticsearch/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: elasticsearch
  labels:
    app: elasticsearch
    chart: "elasticsearch-1.32.4"
    release: "elasticsearch"
    heritage: "Helm"
data:
  elasticsearch.yml: |-
    cluster.name: elasticsearch

    node.data: ${NODE_DATA:true}
    node.master: ${NODE_MASTER:true}
    node.ingest: ${NODE_INGEST:true}
    node.name: ${HOSTNAME}
    network.host: 0.0.0.0
    # see https://github.com/kubernetes/kubernetes/issues/3595
    bootstrap.memory_lock: ${BOOTSTRAP_MEMORY_LOCK:false}

    discovery:
      zen:
        ping.unicast.hosts: ${DISCOVERY_SERVICE:}
        minimum_master_nodes: ${MINIMUM_MASTER_NODES:2}

    # see https://github.com/elastic/elasticsearch-definitive-guide/pull/679
    processors: ${PROCESSORS:}

    # avoid split-brain w/ a minimum consensus of two masters plus a data node
    gateway.expected_master_nodes: ${EXPECTED_MASTER_NODES:2}
    gateway.expected_data_nodes: ${EXPECTED_DATA_NODES:1}
    gateway.recover_after_time: ${RECOVER_AFTER_TIME:5m}
    gateway.recover_after_master_nodes: ${RECOVER_AFTER_MASTER_NODES:2}
    gateway.recover_after_data_nodes: ${RECOVER_AFTER_DATA_NODES:1}
  log4j2.properties: |-
    status = error
    appender.console.type = Console
    appender.console.name = console
    appender.console.layout.type = PatternLayout
    appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n
    rootLogger.level = info
    rootLogger.appenderRef.console.ref = console
    logger.searchguard.name = com.floragunn
    logger.searchguard.level = info

  data-pre-stop-hook.sh: |-
    #!/bin/bash
    exec &> >(tee -a "/var/log/elasticsearch-hooks.log")
    NODE_NAME=${HOSTNAME}
    echo "Prepare to migrate data of the node ${NODE_NAME}"
    echo "Move all data from node ${NODE_NAME}"
    curl -s -XPUT -H 'Content-Type: application/json' 'elasticsearch-client:9200/_cluster/settings' -d "{
      \"transient\" :{
          \"cluster.routing.allocation.exclude._name\" : \"${NODE_NAME}\"
      }
    }"
    echo ""

    while true ; do
      echo -e "Wait for node ${NODE_NAME} to become empty"
      SHARDS_ALLOCATION=$(curl -s -XGET 'http://elasticsearch-client:9200/_cat/shards')
      if ! echo "${SHARDS_ALLOCATION}" | grep -E "${NODE_NAME}"; then
        break
      fi
      sleep 1
    done
    echo "Node ${NODE_NAME} is ready to shutdown"
  data-post-start-hook.sh: |-
    #!/bin/bash
    exec &> >(tee -a "/var/log/elasticsearch-hooks.log")
    NODE_NAME=${HOSTNAME}
    CLUSTER_SETTINGS=$(curl -s -XGET "http://elasticsearch-client:9200/_cluster/settings")
    if echo "${CLUSTER_SETTINGS}" | grep -E "${NODE_NAME}"; then
      echo "Activate node ${NODE_NAME}"
      curl -s -XPUT -H 'Content-Type: application/json' "http://elasticsearch-client:9200/_cluster/settings" -d "{
        \"transient\" :{
            \"cluster.routing.allocation.exclude._name\" : null
        }
      }"
    fi
    echo "Node ${NODE_NAME} is ready to be used"
---
# Source: elasticsearch/templates/tests/test-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: elasticsearch-test
  labels:
    app: elasticsearch
    chart: "elasticsearch-1.32.4"
    heritage: "Helm"
    release: "elasticsearch"
data:
  run.sh: |-
    @test "Test Access and Health" {
      curl -D - http://elasticsearch-client:9200
      curl -D - http://elasticsearch-client:9200/_cluster/health?wait_for_status=green
    }
---
# Source: elasticsearch/templates/client-svc.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "client"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-client

spec:
  ports:
    - name: http
      port: 9200
      targetPort: http
  selector:
    app: elasticsearch
    component: "client"
    release: elasticsearch
  type: ClusterIP
---
# Source: elasticsearch/templates/master-svc.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "master"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-discovery
spec:
  clusterIP: None
  ports:
    - port: 9300
      targetPort: transport
  selector:
    app: elasticsearch
    component: "master"
    release: elasticsearch
---
# Source: elasticsearch/templates/client-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "client"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-client
spec:
  selector:
    matchLabels:
      app: elasticsearch
      component: "client"
      release: elasticsearch
  replicas: 1
  template:
    metadata:
      labels:
        app: elasticsearch
        component: "client"
        release: elasticsearch
      annotations:
        checksum/config: 9648c9871ce1de6ddcb85de48e3ef7619e585522c065e42dc5795ae9a9e66f95
    spec:
      serviceAccountName: elasticsearch-client
      securityContext:
        fsGroup: 1000
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  app: "elasticsearch"
                  release: "elasticsearch"
                  component: "client"
      initContainers:
      # see https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
      # and https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration-memory.html#mlockall
      - name: "sysctl"
        image: "busybox:latest"
        imagePullPolicy: "Always"
        resources:
            {}
        command: ["sysctl", "-w", "vm.max_map_count=262144"]
        securityContext:
          privileged: true
      containers:
      - name: elasticsearch
        env:
        - name: NODE_DATA
          value: "false"
        - name: NODE_MASTER
          value: "false"
        - name: DISCOVERY_SERVICE
          value: elasticsearch-discovery
        - name: PROCESSORS
          valueFrom:
            resourceFieldRef:
              resource: limits.cpu
        - name: ES_JAVA_OPTS
          value: "-Djava.net.preferIPv4Stack=true -Xms512m -Xmx512m  "
        - name: EXPECTED_MASTER_NODES
          value: "1"
        - name: MINIMUM_MASTER_NODES
          value: "1"
        - name: RECOVER_AFTER_MASTER_NODES
          value: "1"
        resources:
            limits:
              cpu: "1"
            requests:
              cpu: 25m
              memory: 512Mi
        readinessProbe:
          httpGet:
            path: /_cluster/health
            port: 9200
          initialDelaySeconds: 5
        livenessProbe:
          httpGet:
            path: /_cluster/health?local=true
            port: 9200
          initialDelaySeconds: 90
        image: "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.6"
        imagePullPolicy: "IfNotPresent"
        ports:
        - containerPort: 9200
          name: http
        - containerPort: 9300
          name: transport
        volumeMounts:
        - mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
          name: config
          subPath: elasticsearch.yml
      volumes:
      - name: config
        configMap:
          name: elasticsearch
---
# Source: elasticsearch/templates/data-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "data"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-data
spec:
  selector:
    matchLabels:
      app: elasticsearch
      component: "data"
      release: elasticsearch
      role: data
  serviceName: elasticsearch-data
  replicas: 1
  template:
    metadata:
      labels:
        app: elasticsearch
        component: "data"
        release: elasticsearch
        role: data
    spec:
      serviceAccountName: elasticsearch-data
      securityContext:
        fsGroup: 1000
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  app: "elasticsearch"
                  release: "elasticsearch"
                  component: "data"
      initContainers:
      # see https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
      # and https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration-memory.html#mlockall
      - name: "sysctl"
        image: "busybox:latest"
        imagePullPolicy: "Always"
        resources:
            {}
        command: ["sysctl", "-w", "vm.max_map_count=262144"]
        securityContext:
          privileged: true
      - name: "chown"
        image: "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.6"
        imagePullPolicy: "IfNotPresent"
        resources:
            {}
        command:
        - /bin/bash
        - -c
        - >
          set -e;
          set -x;
          chown elasticsearch:elasticsearch /usr/share/elasticsearch/data;
          for datadir in $(find /usr/share/elasticsearch/data -mindepth 1 -maxdepth 1 -not -name ".snapshot"); do
            chown -R elasticsearch:elasticsearch $datadir;
          done;
          chown elasticsearch:elasticsearch /usr/share/elasticsearch/logs;
          for logfile in $(find /usr/share/elasticsearch/logs -mindepth 1 -maxdepth 1 -not -name ".snapshot"); do
            chown -R elasticsearch:elasticsearch $logfile;
          done
        securityContext:
          runAsUser: 0
        volumeMounts:
        - mountPath: /usr/share/elasticsearch/data
          name: data
      containers:
      - name: elasticsearch
        env:
        - name: DISCOVERY_SERVICE
          value: elasticsearch-discovery
        - name: NODE_MASTER
          value: "false"
        - name: PROCESSORS
          valueFrom:
            resourceFieldRef:
              resource: limits.cpu
        - name: ES_JAVA_OPTS
          value: "-Djava.net.preferIPv4Stack=true -Xms300m -Xmx300m  "
        - name: EXPECTED_MASTER_NODES
          value: "1"
        - name: MINIMUM_MASTER_NODES
          value: "1"
        - name: RECOVER_AFTER_MASTER_NODES
          value: "1"
        image: "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.6"
        imagePullPolicy: "IfNotPresent"
        ports:
        - containerPort: 9300
          name: transport

        resources:
            limits:
              cpu: "1"
            requests:
              cpu: 25m
              memory: 1536Mi
        readinessProbe:
          httpGet:
            path: /_cluster/health?local=true
            port: 9200
          initialDelaySeconds: 5
        volumeMounts:
        - mountPath: /usr/share/elasticsearch/data
          name: data
        - mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
          name: config
          subPath: elasticsearch.yml
        - name: config
          mountPath: /data-pre-stop-hook.sh
          subPath: data-pre-stop-hook.sh
        - name: config
          mountPath: /data-post-start-hook.sh
          subPath: data-post-start-hook.sh
        lifecycle:
          preStop:
            exec:
              command: ["/bin/bash","/data-pre-stop-hook.sh"]
          postStart:
            exec:
              command: ["/bin/bash","/data-post-start-hook.sh"]
      terminationGracePeriodSeconds: 3600
      volumes:
      - name: config
        configMap:
          name: elasticsearch
  podManagementPolicy: OrderedReady
  updateStrategy:
    type: OnDelete
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
        - "ReadWriteOnce"
      storageClassName: "elasticsearch-data"
      resources:
        requests:
          storage: "5Gi"
---
# Source: elasticsearch/templates/master-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: elasticsearch
    chart: elasticsearch-1.32.4
    component: "master"
    heritage: Helm
    release: elasticsearch
  name: elasticsearch-master
spec:
  selector:
    matchLabels:
      app: elasticsearch
      component: "master"
      release: elasticsearch
      role: master
  serviceName: elasticsearch-master
  replicas: 1
  template:
    metadata:
      labels:
        app: elasticsearch
        component: "master"
        release: elasticsearch
        role: master
    spec:
      serviceAccountName: elasticsearch-master
      securityContext:
        fsGroup: 1000
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  app: "elasticsearch"
                  release: "elasticsearch"
                  component: "master"
      initContainers:
      # see https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
      # and https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration-memory.html#mlockall
      - name: "sysctl"
        image: "busybox:latest"
        imagePullPolicy: "Always"
        resources:
            {}
        command: ["sysctl", "-w", "vm.max_map_count=262144"]
        securityContext:
          privileged: true
      - name: "chown"
        image: "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.6"
        imagePullPolicy: "IfNotPresent"
        resources:
            {}
        command:
        - /bin/bash
        - -c
        - >
          set -e;
          set -x;
          chown elasticsearch:elasticsearch /usr/share/elasticsearch/data;
          for datadir in $(find /usr/share/elasticsearch/data -mindepth 1 -maxdepth 1 -not -name ".snapshot"); do
            chown -R elasticsearch:elasticsearch $datadir;
          done;
          chown elasticsearch:elasticsearch /usr/share/elasticsearch/logs;
          for logfile in $(find /usr/share/elasticsearch/logs -mindepth 1 -maxdepth 1 -not -name ".snapshot"); do
            chown -R elasticsearch:elasticsearch $logfile;
          done
        securityContext:
          runAsUser: 0
        volumeMounts:
        - mountPath: /usr/share/elasticsearch/data
          name: data
      containers:
      - name: elasticsearch
        env:
        - name: NODE_DATA
          value: "false"
        - name: DISCOVERY_SERVICE
          value: elasticsearch-discovery
        - name: PROCESSORS
          valueFrom:
            resourceFieldRef:
              resource: limits.cpu
        - name: ES_JAVA_OPTS
          value: "-Djava.net.preferIPv4Stack=true -Xms512m -Xmx512m  "
        - name: EXPECTED_MASTER_NODES
          value: "1"
        - name: MINIMUM_MASTER_NODES
          value: "1"
        - name: RECOVER_AFTER_MASTER_NODES
          value: "1"
        resources:
            limits:
              cpu: "1"
            requests:
              cpu: 25m
              memory: 512Mi
        readinessProbe:
          httpGet:
            path: /_cluster/health?local=true
            port: 9200
          initialDelaySeconds: 5
        image: "docker.elastic.co/elasticsearch/elasticsearch-oss:6.8.6"
        imagePullPolicy: "IfNotPresent"
        ports:
        - containerPort: 9300
          name: transport

        volumeMounts:
        - mountPath: /usr/share/elasticsearch/data
          name: data
        - mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
          name: config
          subPath: elasticsearch.yml
      volumes:
      - name: config
        configMap:
          name: elasticsearch
  podManagementPolicy: OrderedReady
  updateStrategy:
    type: OnDelete
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
        - "ReadWriteOnce"
      storageClassName: "elasticsearch-master"
      resources:
        requests:
          storage: "5Gi"
---
# Source: elasticsearch/templates/tests/test.yaml
apiVersion: v1
kind: Pod
metadata:
  name: elasticsearch-test
  labels:
    app: elasticsearch
    chart: "elasticsearch-1.32.4"
    heritage: "Helm"
    release: "elasticsearch"
  annotations:
    "helm.sh/hook": test-success
spec:
  initContainers:
    - name: test-framework
      image: "dduportal/bats:0.4.0"
      command:
      - "bash"
      - "-c"
      - |
        set -ex
        # copy bats to tools dir
        cp -R /usr/local/libexec/ /tools/bats/
      volumeMounts:
      - mountPath: /tools
        name: tools
  containers:
    - name: elasticsearch-test
      image: "dduportal/bats:0.4.0"
      command: ["/tools/bats/bats", "-t", "/tests/run.sh"]
      volumeMounts:
      - mountPath: /tests
        name: tests
        readOnly: true
      - mountPath: /tools
        name: tools
  volumes:
  - name: tests
    configMap:
      name: elasticsearch-test
  - name: tools
    emptyDir: {}
  restartPolicy: Never
```

## deploy fluent bit
helm install fluent-bit stable/fluent-bit --namespace=logs --set backend.type=es --set backend.es.host=elasticsearch-client

## template
```
.es.host=elasticsearch-client
---
# Source: fluent-bit/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
  name: fluent-bit
---
# Source: fluent-bit/templates/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: "fluent-bit-es-tls-secret"
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
type: Opaque
data:
  es-tls-ca.crt: ""
---
# Source: fluent-bit/templates/config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
data:
  fluent-bit-service.conf: |
    [SERVICE]
        Flush        1
        Daemon       Off
        Log_Level    info
        Parsers_File parsers.conf

  fluent-bit-input.conf: |
    [INPUT]
        Name              tail
        Path              /var/log/containers/*.log
        Parser            docker
        Tag               kube.*
        Refresh_Interval  5
        Mem_Buf_Limit     5MB
        Skip_Long_Lines   On


  fluent-bit-filter.conf: |
    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_Tag_Prefix     kube.var.log.containers.
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        Merge_Log           On
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On


  fluent-bit-output.conf: |

    [OUTPUT]
        Name  es
        Match *
        Host  elasticsearch-client
        Port  9200
        Logstash_Format On
        Retry_Limit False
        Type  flb_type
        Time_Key @timestamp
        Replace_Dots On
        Logstash_Prefix kubernetes_cluster






  fluent-bit.conf: |
    @INCLUDE fluent-bit-service.conf
    @INCLUDE fluent-bit-input.conf
    @INCLUDE fluent-bit-filter.conf
    @INCLUDE fluent-bit-output.conf

  parsers.conf: |
---
# Source: fluent-bit/templates/tests/test-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-test
  labels:
    app: fluent-bit
    chart: "fluent-bit-2.8.16"
    heritage: "Helm"
    release: "fluent-bit"
data:
  run.sh: |-
    @test "Test Elasticssearch Indices" {
      url="http://elasticsearch-client:9200/_cat/indices?format=json"
      body=$(curl $url)

      result=$(echo $body | jq -cr '.[] | select(.index | contains("kubernetes_cluster"))')
      [ "$result" != "" ]

      result=$(echo $body | jq -cr '.[] | select((.index | contains("kubernetes_cluster")) and (.health != "green"))')
      [ "$result" == "" ]
    }

  fluentd.conf: |-
    <source>
      @type forward
      bind 0.0.0.0
      port 24284
      shared_key
    </source>

    <match **>
      @type stdout
    </match>
---
# Source: fluent-bit/templates/cluster-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
  name: fluent-bit
rules:
  - apiGroups:
      - ""
    resources:
      - pods
    verbs:
      - get
---
# Source: fluent-bit/templates/cluster-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
  name: fluent-bit
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: fluent-bit
subjects:
  - kind: ServiceAccount
    name: fluent-bit
    namespace: logs
---
# Source: fluent-bit/templates/daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluent-bit
  labels:
    app: fluent-bit
    chart: fluent-bit-2.8.16
    heritage: Helm
    release: fluent-bit
spec:
  selector:
    matchLabels:
      app: fluent-bit
      release: fluent-bit
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: fluent-bit
        release: fluent-bit
      annotations:
        checksum/config: d101fcf28e011075e57f8582773e26107826ecceb2812b4c2366016b328e368a
    spec:
      hostNetwork: false
      dnsPolicy: ClusterFirst
      serviceAccountName: fluent-bit
      containers:
      - name: fluent-bit
        image: "fluent/fluent-bit:1.3.7"
        imagePullPolicy: "Always"
        env:
          []
        resources:
          {}
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
        - name: config
          mountPath: /fluent-bit/etc/fluent-bit.conf
          subPath: fluent-bit.conf
        - name: config
          mountPath: /fluent-bit/etc/fluent-bit-service.conf
          subPath: fluent-bit-service.conf
        - name: config
          mountPath: /fluent-bit/etc/fluent-bit-input.conf
          subPath: fluent-bit-input.conf
        - name: config
          mountPath: /fluent-bit/etc/fluent-bit-filter.conf
          subPath: fluent-bit-filter.conf
        - name: config
          mountPath: /fluent-bit/etc/fluent-bit-output.conf
          subPath: fluent-bit-output.conf

      terminationGracePeriodSeconds: 10

      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
      - name: config
        configMap:
          name: fluent-bit-config
---
# Source: fluent-bit/templates/tests/test.yaml
apiVersion: v1
kind: Pod
metadata:
  name: fluent-bit-test
  labels:
    app: fluent-bit
    chart: "fluent-bit-2.8.16"
    heritage: "Helm"
    release: "fluent-bit"
  annotations:
    "helm.sh/hook": test-success
spec:
  initContainers:
    - name: test-framework
      image: "dduportal/bats:0.4.0"
      command:
      - "bash"
      - "-c"
      - |
        set -ex
        # copy bats to tools dir
        cp -R /usr/local/libexec/ /tools/bats/
      volumeMounts:
      - mountPath: /tools
        name: tools
  containers:
    - name: fluent-bit-test
      image: "dwdraju/alpine-curl-jq"
      command: ["/tools/bats/bats", "-t", "/tests/run.sh"]
      volumeMounts:
        - mountPath: /tests
          name: tests
          readOnly: true
        - mountPath: /tools
          name: tools
  volumes:
  - name: tests
    configMap:
      name: fluent-bit-test
  - name: tools
    emptyDir: {}
  restartPolicy: Never
```
## deploy kibana
helm install kibana stable/kibana --namespace=logs --set env.ELASTICSEARCH_HOSTS=http://elasticsearch-client:9200 --set service.type=NodePort --set service.nodePort=31000
  kubectl --namespace=logs get pods -l "app=kibana"
    export NODE_PORT=$(kubectl get --namespace logs -o jsonpath="{.spec.ports[0].nodePort}" services kibana)
    export NODE_IP=$(kubectl get nodes --namespace logs -o jsonpath="{.items[0].status.addresses[0].address}")
    echo http://$NODE_IP:$NODE_PORT
### template
```
---
# Source: kibana/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kibana
  labels:
    app: kibana
    chart: "kibana-3.2.6"
    release: kibana
    heritage: Helm
data:
  kibana.yml: |
    elasticsearch.hosts: http://elasticsearch:9200
    server.host: "0"
    server.name: kibana
---
# Source: kibana/templates/tests/test-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kibana-test
  labels:
    app: kibana
    chart: "kibana-3.2.6"
    heritage: "Helm"
    release: "kibana"
data:
  run.sh: |-
    @test "Test Status" {
      url="http://kibana:443/api/status"

      # retry for 1 minute
      run curl -s -o /dev/null -I -w "%{http_code}" --retry 30 --retry-delay 2 $url

      code=$(curl -s -o /dev/null -I -w "%{http_code}" $url)
      body=$(curl $url)
      if [ "$code" == "503" ]
      then
        skip "Kibana Unavailable (503), can't get status - see pod logs: $body"
      fi

      result=$(echo $body | jq -cr '.status.statuses[]')
      [ "$result" != "" ]

      result=$(echo $body | jq -cr '.status.statuses[] | select(.state != "green")')
      [ "$result" == "" ]
    }
---
# Source: kibana/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kibana
    chart: kibana-3.2.6
    release: kibana
    heritage: Helm
  name: kibana
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 5601
      protocol: TCP

      nodePort: 31000

  selector:
    app: kibana
    release: kibana
---
# Source: kibana/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: kibana
    chart: "kibana-3.2.6"
    heritage: Helm
    release: kibana
  name: kibana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kibana
      release: kibana
  revisionHistoryLimit: 3
  template:
    metadata:
      annotations:
        checksum/config: 4f6afe69a2710fe67fee2348ad3aec4692d74d4005449338e5598c00dd54695d
      labels:
        app: kibana
        release: "kibana"
    spec:
      serviceAccountName: default
      containers:
      - name: kibana
        image: "docker.elastic.co/kibana/kibana-oss:6.7.0"
        imagePullPolicy: IfNotPresent
        env:
        - name: "ELASTICSEARCH_HOSTS"
          value: "http://elasticsearch-client:9200"
        ports:
        - containerPort: 5601
          name: kibana
          protocol: TCP
        resources:
          {}
        volumeMounts:
        - name: kibana
          mountPath: "/usr/share/kibana/config/kibana.yml"
          subPath: kibana.yml
      tolerations:
        []
      volumes:
        - name: kibana
          configMap:
            name: kibana
---
# Source: kibana/templates/tests/test.yaml
apiVersion: v1
kind: Pod
metadata:
  name: kibana-test
  labels:
    app: kibana
    chart: "kibana-3.2.6"
    heritage: "Helm"
    release: "kibana"
  annotations:
    "helm.sh/hook": test-success
spec:
  initContainers:
    - name: test-framework
      image: "dduportal/bats:0.4.0"
      command:
      - "bash"
      - "-c"
      - |
        set -ex
        # copy bats to tools dir
        cp -R /usr/local/libexec/ /tools/bats/
      volumeMounts:
      - mountPath: /tools
        name: tools
  containers:
    - name: kibana-test
      image: "dwdraju/alpine-curl-jq"
      command: ["/tools/bats/bats", "-t", "/tests/run.sh"]
      volumeMounts:
        - mountPath: /tests
          name: tests
          readOnly: true
        - mountPath: /tools
          name: tools
  volumes:
  - name: tests
    configMap:
      name: kibana-test
  - name: tools
    emptyDir: {}
  restartPolicy: Never
```
