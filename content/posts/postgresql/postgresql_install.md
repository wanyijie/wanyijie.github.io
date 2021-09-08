---
title: "Postgresql 安装"
date: 2021-09-08T16:55:52+08:00
summary: "centos 7 安装, docker 安装"
tags:
    - wangyijie
    - database
    - postgresql
categories:
    - Development
    - Opetration
---

# centos 7 安装
    yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    yum install -y postgresql12 postgresql12-server
    /usr/pgsql-12/bin/postgresql-12-setup initdb 
    Systemctl start postgresql-12

# Dockerfile 制作
    from centos:7
    run yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    run yum install -y postgresql13-server wget net-tools
    env PATH $PATH:/usr/pgsql-13/bin
    env PGDATA /var/lib/pgsql/13/data/
    user postgres
    run initdb -D  /var/lib/pgsql/13/data/ --data-checksums
    ENTRYPOINT ["postgres", "-D","/var/lib/pgsql/13/data/"]

# 开通防火墙
    firewall-cmd --permanent --add-service=postgresql
    firewall-cmd --add-service=postgresql