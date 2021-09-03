The package is for el7, and there are assumptions based on el7 that are no longer true for RHEL8. For now, instead of running sudo yum install azure-cli, please follow the 
workaround to install azure-cli:
<!--more-->
```
$ sudo yum install python2
$ sudo yum install yum-utils
$ sudo yumdownloader azure-cli
$ sudo rpm -ivh --nodeps azure-cli-2.0.75-1.el7.x86_64.rpm
```

Then edit the second line of /usr/bin/az (result of which az) to specify using python2:
PYTHONPATH=/usr/lib64/az/lib/python2.7/site-packages python2 -sm azure.cli "$@"
