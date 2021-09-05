---
summary: "linuz zip create compress package"
tags:
    - wangyijie
    - knowledge
categories:
    - leaning
---
# linux
**zip -r test.zip ./**
```bash
[root@ip-172-31-28-124 ec2-user]# cd /opt/
[root@ip-172-31-28-124 opt]# ls
[root@ip-172-31-28-124 opt]# mkdir test
[root@ip-172-31-28-124 opt]# ls
test
[root@ip-172-31-28-124 opt]# echo 123 >> test/test.txt
[root@ip-172-31-28-124 opt]# ls
test
[root@ip-172-31-28-124 opt]# zip -r test.zip .
  adding: test/ (stored 0%)
  adding: test/test.txt (stored 0%)
[root@ip-172-31-28-124 opt]# ls
test  test.zip

[root@ip-172-31-28-124 opt]# rm -rf test
[root@ip-172-31-28-124 opt]# unzip test.zip 
Archive:  test.zip
   creating: test/
 extracting: test/test.txt           
[root@ip-172-31-28-124 opt]# ls
test  test.zip
[root@ip-172-31-28-124 opt]#
```
# windows
**Compress-Archive -Path * -DestinationPath doc.zip**
```powershell
PS D:\web\doc> Compress-Archive -Path * -DestinationPath doc.zip
PS D:\web\doc> ls

    目录: D:\web\doc

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----        11/1/2017  10:51 PM                doc
d-----       10/19/2017   2:18 PM                hugo-theme-docdock
d-----       10/19/2017   2:18 PM                hugo-theme-learn
d-----        11/1/2017  10:42 AM                kubernetes
d-----       10/23/2017   1:46 PM                zhikong
-a----        6/26/2018   5:14 PM       75689120 doc.zip
PS D:\web\doc>
```
