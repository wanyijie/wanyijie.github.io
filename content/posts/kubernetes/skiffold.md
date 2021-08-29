# 调试可用的配置，花了不少时间踩坑，拿走不谢！
```
apiVersion: skaffold/v1beta8
kind: Config
- name: profile-prod    #       a unique profile name.
  patches:
  activation:
  - env: ENV=production
    kubeContext: minikube
    command: deploy
  - env: ENV=develop
    kubeContext: minikube
    command: dev
build:
  artifacts:
  - image:  axd-register
    jibMaven:
      module: axd-register
      args:
      - -DskipTests
  - image:  axd-gateway
    jibMaven:
      module: axd-gateway
      args:
      - -DskipTests
  - image:  axd-activity-provider
    jibMaven:
      module: axd-gateway
      args:
      - -DskipTests
  - image:  axd-auth-provider
    jibMaven:
      module: axd-auth-provider
      args:
      - -DskipTests
  - image:  axd-basic-provider
    jibMaven:
      module: axd-basic-provider
      args:
      - -DskipTests
  - image:  axd-book-provider
    jibMaven:
      module: axd-book-provider
      args:
      - -DskipTests
  - image:  axd-manager-provider
    jibMaven:
      module: axd-manager-provider
      args:
      - -DskipTests
  - image:  axd-merchant-provider
    jibMaven:
      module: axd-merchant-provider
      args:
      - -DskipTests
  - image:  axd-mq-provider
    jibMaven:
      module: axd-mq-provider
      args:
      - -DskipTests
  - image:  axd-order-provider
    jibMaven:
      module: axd-order-provider
      args:
      - -DskipTests
  - image:  axd-push-provider
    jibMaven:
      module: axd-push-provider
      args:
      - -DskipTests
  - image:  axd-user-provider
    jibMaven:
      module: axd-user-provider
      args:
      - -DskipTests

# optional profile to run the jib build on Google Cloud Build
deploy:
  kubectl:
    manifests:
    - axd-register/k8s.yml
    - axd-gateway/k8s.yml
    - axd-gateway-rms/k8s.yml
    - axd-activity-provider/k8s.yml
    - axd-auth-provider/k8s.yml
    - axd-basic-provider/k8s.yml
    - axd-book-provider/k8s.yml
    - axd-manager-provider/k8s.yml
    - axd-merchant-provider/k8s.yml
    - axd-mq-provider/k8s.yml
    - axd-order-provider/k8s.yml
    - axd-push-provider/k8s.yml
    - axd-user-provider/k8s.yml
```
