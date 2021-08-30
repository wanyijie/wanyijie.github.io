---
summary: "postgreql版本：12+ barman版本：2.+"
tags:
    - Kubernetes
categories:
    - Development
    - Opetration
---

# 前置条件：
postgreql版本：12+
barman版本：2.+
运行环境：centos系列加上网
# 脚本：
结合末尾的执行参数看更容易理解
```
cat pg_disaster_recovery_with_barman.sh
#!/bin/bash
set -o nounset #遇到变量不存在，脚本报错
set -o xtrace # 打印执行命令
set -o errexit # 错误退出
set -o pipefail # 只要一个子命令失败，整个管道命令就失败，脚本就会终止执行
target=$1

# 设置本地yum源
function set_pg_repo(){
echo "[barman-pg]
name=barman-pg-rhel7
baseurl=https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8-x86_64/
gpgcheck=0" > /etc/yum.repos.d/barman-pg.repo
}

function set_pg_admin_secret(){
echo "${pg_host}:5432:*:${pg_user}:${pg_password}" > ${HOME}/.pgpass
chmod 600 ${HOME}/.pgpass

}

function create_pg_user_barman(){
psql -h ${pg_host} -U ${pg_user} -c "CREATE USER barman WITH superuser LOGIN REPLICATION createdb createrole ENCRYPTED password '${pg_password}';"
}

function install_barman(){
    yum install epel-release -y
    set_pg_repo
    yum install  barman -y
    yum  install  postgresql12 -y
}


function config_barman(){
set_pg_repo
install_barman
set_pg_admin_secret
create_pg_user_barman
mkdir -p  /var/lib/barman/
echo "${pg_host}:5432:*:barman:${pg_password}" >/var/lib/barman/.pgpass
chown barman:barman /var/lib/barman/.pgpass
chmod 600 /var/lib/barman/.pgpass  
if su - barman -c "psql -c 'SELECT version()' -U barman -h ${pg_host} postgres"
then
    echo "barman user is ok"
else
    echo "barman user in pg is bad"
    exit 1
fi
sed  -e 's/streaming_barman/barman/' -e "s/=pg/=${pg_host}/" -e 's/;path_prefix/path_prefix/'  /etc/barman.d/streaming-server.conf-template > /etc/barman.d/streaming-server.conf
echo "export PATH=\$PATH:/usr/pgsql-12/bin" > /etc/profile.d/pg.sh
source /etc/profile.d/pg.sh

barman receive-wal --create-slot streaming
if ! barman switch-xlog --force --archive --archive-timeout 60 streaming  # if failed, do it baragain
then
    barman switch-xlog --force --archive --archive-timeout 60 streaming 
fi
barman check streaming
}

if test $target = "barman"
then
    pg_host=$2
    pg_user=$3
    pg_password=$4
    config_barman
    echo "config barman successful"
    echo "execute barman backup streaming to start backup"
fi
```
# 使用方式
例如
```
bash pg_disaster_recovery_with_barman.sh barman 10.0.0.1 postgres 123456
```
# 备份恢复
## 本地恢复
```
barman list-backup streaming
chown barman /var/lib/postgresql
barman recover --target-time "2021-07-07 17:56:09+08:00" --target-action promote  streaming 20210707T173939 /var/lib/postgresql
#barman recover  streaming 20210707T145829 /var/lib/postgresql
chown -R postgres:postgres /var/lib/postgresql
mv -f /opt/data/postgresql/postgresql.auto.conf{.origin,}
mv -f  /opt/data/postgresql/postgresql.conf{.origin,} 
```
## 远程恢复
```
#为barman用户生成证书
su - barman -c "ssh-keygen -t rsa -P '' -b 4096 -C 'barman@pg-barman' -m PEM  -f /var/lib/barman/pg.pem"
# 把公钥/var/lib/barman/pg.pem放在pg恢复的目标数据库主机上有权限的用户，具体请了解linux公钥交换认证
su - barman -c "cat /var/lib/barman/pg.pem.pub"
#恢复示例
barman recover --remote-ssh-command "ssh root@10.0.0.1 -i /var/lib/barman/pg.pem" --target-time "2021-07-07 17:56:09+08:00" --target-action promote  streaming 20210707T173939 /opt/data/postgresql
```

## 工作中使用的，效果很好,遇到问题请留言讨论
