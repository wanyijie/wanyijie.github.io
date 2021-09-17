---
title: "使用Mermaid语法创建图表"
date: 2021-09-17T16:41:50+08:00
summary: "Mermaid 是一种类似于 Markdown 的语法，您可以在其中使用文本来描述和自动生成图表。使用 Mermaid 的受 Markdown 启发的语法，您可以生成流程图、UML 图、饼图、甘特图等。"
tags:
    - wangyijie
    - UML
categories:
    - Development
    - Opetration
---

Mermaid 是一种类似于 Markdown 的语法，您可以在其中使用文本来描述和自动生成图表。使用 Mermaid 的受 Markdown 启发的语法，您可以生成流程图、UML 图、饼图、甘特图等。

许多开发人员更喜欢使用文本来描述他们的数据结构和流程，从而避免上下文切换的需要。

## 美人鱼语法

图表是通过使用箭头连接器链接文本标签来创建的。您可以选择不同的形状、为连接线添加标签，以及为连接线和形状设置样式。

[完整语法和样式选项的美人鱼文档](https://mermaid-js.github.io/mermaid/#/)

| **形状样式** | `[rectangle]` | `(rounded rectangle)` |
|   | `((circle))` | `{diamond}` |
| **连接器样式** | 箭： `A-->B` | 加点： `A-.-->B` |
|   | 没有箭头： `A---B` | 带标签： `A-->|label|B` |
| **图表类型** | `graph` | `pie` |
|   | `gantt` | `sequenceDiagram` |
|   | `stateDiagram` | `classDiagram` |
|   | `gitgraph` |   |
| **甘特图** | 任务状态：`done`, `active`, `crit`,`after` | `section` |
| **馅饼** | `title` |   |
| **gitgraph** | 动作：`commit`, `branch`, `checkout`,`merge` |   |
| **UML** | 生命线：`participant` | `activate` |
|   | 容器：`loop`, `alt`,`opt` | `class` |
| **信息** | 评论： `%%` | `note` |

查看下面的示例，了解如何使用 Mermaid 语法定义文本中的各种图表。在 diagrams.net 中打开这些示例美人鱼图。

### 流程图

**注意：**标签可以包含新行以实现更清晰的布局。

```
graph TD
   A(Coffee machine <br>not working) --> B{Machine has power?}
   B -->|No| H(Plug in and turn on)
   B -->|Yes| C{Out of beans or water?} -->|Yes| G(Refill beans and water)
   C -->|No| D{Filter warning?} -->|Yes| I(Replace or clean filter)
   D -->|No| F(Send for repair)

```

![美人鱼语法的流程图示例](https://upload-images.jianshu.io/upload_images/6000429-ece7d5a5cb3c6e13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 甘特图

甘特图受到许多项目经理的喜爱，因为它们可以跟踪项目的任务、依赖关系和时间表。虽然在 diagrams.net 中创建甘特图可能很繁琐，但从文本描述中生成甘特图要容易得多。

```
gantt
 title Example Gantt diagram
    dateFormat  YYYY-MM-DD
    section Team 1
    Research & requirements :done, a1, 2020-03-08, 2020-04-10
    Review & documentation : after a1, 20d
    section Team 2
    Implementation      :crit, active, 2020-03-25  , 20d
    Testing      :crit, 20d

```

![从美人鱼代码插入的甘特图示例](https://upload-images.jianshu.io/upload_images/6000429-5a9929a72a357465.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### UML类图

以下是来自 diagrams.net 的简单类图模板在 Mermaid 语法中的外观。

```
classDiagram
   Person <|-- Student
   Person <|-- Professor
   Person : +String name
   Person : +String phoneNumber
   Person : +String emailAddress
   Person: +purchaseParkingPass()
   Address "1" <-- "0..1" Person:lives at
   class Student{
      +int studentNumber
      +int averageMark
      +isEligibleToEnrol()
      +getSeminarsTaken()
    }
    class Professor{
      +int salary
    }
    class Address{
      +String street
      +String city
      +String state
      +int postalCode
      +String country
      -validate()
      +outputAsLabel()  
    }			

```

![美人鱼语法中来自 diagrams.net 的简单类示例模板](https://upload-images.jianshu.io/upload_images/6000429-6141297d2dee1eb4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### UML序列图

UML 序列图用于显示完成流程所采取的步骤和参与者。这些图在软件开发中被大量使用。

```
sequenceDiagram
    autonumber
    Student->>Admin: Can I enrol this semester?
    loop enrolmentCheck
        Admin->>Admin: Check previous results
    end
    Note right of Admin: Exam results may <br> be delayed
    Admin-->>Student: Enrolment success
    Admin->>Professor: Assign student to tutor
    Professor-->>Admin: Student is assigned

```

![使用 Mermaid 语法插入的简单序列图](https://upload-images.jianshu.io/upload_images/6000429-3c5243c50068ce84.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 饼形图

虽然您可以手动构建饼图 diagrams.net，但使用 Mermaid 语法可以很容易地准确获得饼切片的正确分布。在美人鱼代码中，您可以使用百分比值，也可以使用每组的实际值。在下面的示例中，您可以看到哪几天最繁忙的提交到 GitHub 上的 diagrams.net 主存储库。

```
pie title Commits to mxgraph2 on GitHub
	"Sunday" : 4
	"Monday" : 5
	"Tuesday" : 7
  "Wednesday" : 3

```

![每天提交到 mxgraph2 GitHub 存储库，使用 Mermaid 语法插入到 diagrams.net](https://upload-images.jianshu.io/upload_images/6000429-8312f485fbb74936.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)