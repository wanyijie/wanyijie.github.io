Extundelete工具简介
Extundelete 是基于 linux 的开源数据恢复软件。如果您不小心误删除数据，并且 Linux 系统也没有与 Windows 系统下回收站类似的功能，您可以方便快速安装此工具。

在利用 extundelete 恢复文件时并不依赖特定文件格式，首先extundelete会通过文件系统的inode信息（根目录的inode一般为2）来获得当前文件系统下所有文件的信息，包括存在的和已经删除的文件，这些信息包括文件名和inode。然后利用inode信息结合日志去查询该inode所在的block位置，包括直接块，间接块等信息。最后利用dd命令将这些信息备份出来，从而恢复数据文件。该工具最给力的一点就是支持ext3/ext4双格式分区恢复，基于整个磁盘的恢复功能较为强大。
注意：在实际线上恢复过程中，切勿将extundelete安装到你误删的文件所在硬盘，这样会有一定几率将需要恢复的数据彻底覆盖

## src/extundelete --help

A typical usage scenario is presented below.  Note that some
of the commands below require special permissions to
complete.  Adding 'sudo ' before the command is one way to
ensure you have the necessary permissions.  Assume you
have deleted a file called **/home/user/an/important/file.**
Also assume the output of the 'mount' command shows this
line (among others):
/dev/sda3 on /home type ext3 (rw)
This line shows that the /home directory is on the partition
named /dev/sda3, so then run:
`umount /dev/sda3`
and check that it is now unmounted by running the mount
command again and seeing it is not listed.
Now, with this information, run extundelete:
`extundelete /dev/sda3 --restore-file user/an/important/file`
If you have deleted the directory 'important', you can run:
`extundelete /dev/sda3 --restore-directory user/an/important`
Or if you have deleted everything, you can run:
`extundelete /dev/sda3 --restore-all`
