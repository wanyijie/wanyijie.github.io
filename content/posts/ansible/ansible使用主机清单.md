---
tags:
    - wangyijie
    - ansible
categories:
    - Development
    - Opetration
---
Ansible同时针对基础架构中的多个系统。它通过选择Ansible库存中列出的系统部分来实现这一点，默认情况下将保存在该位置`/etc/ansible/hosts`。您可以使用命令行上的选项指定不同的清单文件。
<!--more-->
`-i <path>`

此库存不仅可配置，还可以同时使用多个库存文件并从动态或云源或不同格式（YAML，ini等）中提取库存，如[使用动态库存中所述](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#intro-dynamic-inventory)。Ansible在2.4版本中引入了库存插件，使其具有灵活性和可定制性。

## [主机和组](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id5)[](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#hosts-and-groups "这个标题的永久链接")

库存文件可以采用多种格式之一，具体取决于您拥有的库存插件。对于这个例子，格式`/etc/ansible/hosts`是类似INI的（Ansible的默认值之一），如下所示：
```
mail.example.com

[Web服务器]
foo.example.com
bar.example.com
[dbservers]
one.example.com
two.example.com
three.example.com
```

括号中的标题是组名，用于对系统进行分类并确定您在什么时间控制什么系统以及为了什么目的。

YAML版本将如下所示：
```
all ：
  hosts ：
    mail.example.com ：
  children ：
    webservers ：
      hosts ：
        foo.example.com ：
        bar.example.com ：
    dbservers ：
      hosts ：
        one.example.com ：
        two.example.com ：
        three.example.com ：
```

可以将系统放在多个组中，例如服务器既可以是Web服务器也可以是dbserver。如果你这样做，请注意变量将来自他们所属的所有组。变量优先级在后面的章节中详细介绍。

如果您的主机在非标准SSH端口上运行，则可以使用冒号将端口号放在主机名后面。SSH配置文件中列出的端口不会与**paramiko**连接一起使用，但会与**openssh**连接一起使用。

为了明确地说明，如果事情没有在默认端口上运行，建议您设置它们：

    badwolf.example.com:5309

假设你只有静态IP并且想要设置一些生存在主机文件中的别名，或者你正在通过隧道进行连接。你也可以通过变量来描述主机：

在INI中：  

    jumper ansible_port=5555 ansible_host=192.0.2.50

在YAML中：

```
...
  hosts:
    jumper:
      ansible_port: 5555
      ansible_host: 192.0.2.50

```

在上面的例子中，试图对主机别名“跳线”（甚至可能不是真正的主机名）采取行动，将在端口5555上联系192.0.2.50。请注意，这是使用库存文件的一项功能来定义一些特殊变量。一般来说，这不是定义描述系统策略的变量的最佳方式，但我们会在以后分享这些建议。

>注意:
使用`key=value`语法以INI格式传递的值不被解释为Python字面结构（字符串，数字，元组，列表，字典，布尔值，无），而是作为字符串。例如，`var=FALSE`会创建一个等于'FALSE'的字符串。不要依赖定义期间设置的类型，在使用变量时务必确保在需要时指定带有过滤器的类型。

如果您添加了许多类似模式的主机，则可以这样做，而不是列出每个主机名：
```
[webservers]
www[01:50].example.com
```
对于数字模式，根据需要可以包含或移除前导零。范围是包容性的。您还可以定义字母范围：
```
[databases]
db-[a:f].example.com
```
您也可以按主机选择连接类型和用户：
```
[targets]

localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_user=mpdehaan
other2.example.com     ansible_connection=ssh        ansible_user=mdehaan
```
如上所述，在清单文件中设置这些内容只是简写，我们将在稍后介绍如何将它们存储在'host_vars'目录中的单个文件中。

## [主机变量](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id6)[](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#host-variables "这个标题的永久链接")

如上所述，很容易将变量分配给将在以后的剧本中使用的主机：
```
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
host2 http_port=303 maxRequestsPerChild=909
```
## [组变量](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id7)[](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#group-variables "这个标题的永久链接")

变量也可以同时应用于整个组：

INI方式：
```
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```
YAML版本：
```
atlanta:
  hosts:
    host1:
    host2:
  vars:
    ntp_server: ntp.atlanta.example.com
    proxy: proxy.atlanta.example.com
```
请注意，这只是将变量一次应用到多个主机的简便方法; 即使您可以按组来定位主机，但在执行播放之前，**变量总是会展平到主机级别**。

## [组和组变量](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id8)[](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#groups-of-groups-and-group-variables "这个标题的永久链接")

也可以使用`:children`INI中的后缀或`children:`YAML中的条目来创建组。您可以使用`:vars`或应用变量`vars:`：
```
 [atlanta]
host1
host2

[raleigh]
host2
host3

[southeast:children]
atlanta
raleigh

[southeast:vars]
some_server=foo.southeast.example.com
halon_system_timeout=30
self_destruct_countdown=60
escape_pods=2

[usa:children]
southeast
northeast
southwest
northwest
```
****
```
all:
  children:
    usa:
      children:
        southeast:
          children:
            atlanta:
              hosts:
                host1:
                host2:
            raleigh:
              hosts:
                host2:
                host3:
          vars:
            some_server: foo.southeast.example.com
            halon_system_timeout: 30
            self_destruct_countdown: 60
            escape_pods: 2
        northeast:
        northwest:
        southwest:
```
如果您需要存储列表或散列数据，或者希望将主机和组特定变量与库存文件分开，请参阅下一节。儿童组有几个属性需要注意：

> *   任何属于子组的成员都自动成为父组的成员。
> *   子组的变量将具有更高的优先级（覆盖）父组的变量。
> *   组可以有多个父母和孩子，但不是循环关系。
> *   主机也可以在多个组，但只会有**一个**主机的情况下，合并来自多个组的数据。

## [默认组](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#id9)[](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#default-groups "这个标题的永久链接")

有两个默认组：`all`和`ungrouped`。`all`包含每个主机。 `ungrouped`包含除了没有其他组的所有主机`all`。每个主持人总是属于至少两个组。虽然`all`并`ungrouped`始终存在，但它们可以是隐含的，不会出现在组列表中`group_names`。


