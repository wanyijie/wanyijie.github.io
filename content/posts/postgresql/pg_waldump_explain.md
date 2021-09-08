---
title: "Pg_waldump 示例解读"
date: 2021-09-08T17:03:09+08:00
summary: "PostgreSQL内部将WAL日志归类到20多种不同的资源管理器。这条WAL记录所属资源管理器为 Heap,即堆表。除了Heap还有Btree"
tags:
    - wangyijie
    - database
    - postgresql
categories:
    - Development
    - Opetration
---
# 示例
    rmgr: Heap  len (rec/tot): 65/  177, tx:  717, lsn: 1/92021450, prev 1/92021418, desc: HOT_UPDATE off 1 xmax 717 flags 0x20 ; new off 2 xmax 0, blkref #0: rel 1663/16395/17623 blk 0 FPW
    
    rmgr: Heap ：PostgreSQL内部将WAL日志归类到20多种不同的资源管理器。这条WAL记录所属资源管理器为 Heap,即堆表。除了Heap还有Btree,Transaction等。
    len (rec/tot): 65/ 177：wal记录的长度。
    tx: 717： 事务号。
    lsn: 1/92021450：本条wal记录的lsn。
    prev 1/92021418：上条wal记录的lsn。
    desc: HOT_UPDATE off 1 xmax 717 flags 0x20 ; new off 2 xmax 0： 这是一条热更新类型的记录，旧数据
    offset为1，xmax为717。旧tuple在page中的位置为1(即ctid的后半部分)，新tuple在page中的位置为2。
    blkref #0: rel 1663/16395/17623 blk 0 ：引用的第一个page(新tuple所在page)所属的堆表文件为1663/13543/16469,块号为0(即ctid的前半部分)。