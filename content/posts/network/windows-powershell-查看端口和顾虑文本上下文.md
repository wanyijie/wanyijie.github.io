## example
```
NETSTAT.EXE -abno | Select-String -Pattern Sangfor -Context 1,2
```
1. windows netstat使用-abno显示的信息最完善，建议常用
2. select-string 匹配文本，使用-context指定匹配文本的前后行数，例子是前面一行后面两行
谢谢！
