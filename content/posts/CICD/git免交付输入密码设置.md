---
title: "Git免交付输入密码设置"
date: 2021-09-05T17:44:20+08:00
draft: true
summary: "git config --local http.https://github.com/.extraheader AUTHORIZATION: basic dXNlcjpwYXNz"
tags:
    - wangyijie
    - git
categories:
    - Development
    - Opetration
---
github action使用的一些git玄幻操作
## Initializing the repository
    /usr/bin/git init /home/runner/work/wanyijie.github.io/wanyijie.github.io
    /usr/bin/git remote add origin https://github.com/wanyijie/wanyijie.github.io
    /usr/bin/git config --local gc.auto 0
## Setting up auth
    /usr/bin/git config --local --name-only --get-regexp core\.sshCommand
    /usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'core\.sshCommand' && git config --local --unset-all 'core.sshCommand' || :
    /usr/bin/git config --local --name-only --get-regexp http\.https\:\/\/github\.com\/\.extraheader
    /usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'http\.https\:\/\/github\.com\/\.extraheader' && git config    --local --unset-all 'http.https://github.com/.extraheader' || :
    /usr/bin/git config --local http.https://github.com/.extraheader AUTHORIZATION: basic ***
## Fetching the repository
    /usr/bin/git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin +2aa2c6ca34016346b6ed57816e32cb4809cb6dde:refs/remotes/origin/master
    /usr/bin/git checkout --progress --force -B master refs/remotes/origin/master
    /usr/bin/git log -1 --format='%H'

# 正文开始
## 配置basic认证
    user=admin
    pass=admin
    git config credential.authority basic
    git config --local http.https://github.com/.extraheader \"AUTHORIZATION: basic $(echo -n "user:pass"|base64)\"

##  启动存储密码在仓库
    git config credential.helper store
    git config --global credential.helper store

## github使用url path存储密码
    git config --global credential.github.com.useHttpPath true
    git remote set-url origin https://<USERNAME>:<PASSWORD>@github.com/path/to/repo.git

## 注意
路过看见的，没亲测过，测试后如果记得会指名，或者哪位测试了请留言交流
