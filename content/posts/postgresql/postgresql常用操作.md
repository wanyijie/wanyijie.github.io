---
title: "Postgresql 常用操作"
date: 2021-09-08T17:15:02+08:00
summary: "查看数据库和表数据大小,查看数据库运行配置,热更新配置"
tags:
    - wangyijie
    - database
    - postgresql
categories:
    - Development
    - Opetration
---

## 1. 查看数据库和表数据大小：
    select pg_database.datname, pg_database_size(pg_database.datname) AS size from pg_database; # 单位byte
    select pg_size_pretty(pg_database_size('bench'));
    select pg_size_pretty(pg_table_size('pgbench_accounts'));

##  2. 查看数据库运行配置

    docker exec -u postgres -it pam_pam-pgsql_1 psql -c "show shared_buffers"

    主要优化项：
    shared_buffers = 2GB #建议系统百分之二十五，默认128m

## 3. 热更新配置

    docker exec -it pam_pam-pgsql_1 psql -U postgres -c "SELECT pg_reload_conf();"

## 4. 查看流复制同步状态
    select * from pg_stat_replication;
## 5. 确定主库传到什么位置了
    postgres=# select pg_current_wal_lsn();
## 6. 确定备库接收到哪儿了
    postgres=# select pg_last_wal_receive_lsn();
## 7. 确定备库应用到哪儿了
    postgres=# select pg_last_wal_replay_lsn();
## 8. 最近事务应用的时间
    postgres=# select pg_last_xact_replay_timestamp();