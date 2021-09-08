---
summary: "Angular Material附带Angular CLI原理图，使创建Material应用程序变得更加简单。"
tags:
    - wangyijie
    - angular
    - material
categories:
    - Development
    - Opetration
---
Angular Material comes packaged with Angular CLI schematics to make
creating Material applications easier.  
Angular Material附带Angular CLI原理图，使创建Material应用程序变得更加简单。

## Install Schematics
## 安装原理图
Schematics come packaged with Angular Material, so once you have
installed the npm package, they will be available via the Angular CLI.  
原理图与Angular Material一起打包，所以一旦安装了npm软件包，它们将通过Angular CLI提供。

If you run it will automatically install Angular Material for you
and run the install schematic.  
如果您运行下面的命令，它会自动为您安装Angular Material并运行安装原理图。

```
ng add @angular/material
```

The install schematic will help you quickly add Material to a new project. 
This schematic will:  
安装原理图将帮助您快速将材料添加到新项目。这个原意图将会：

- Ensure project dependencies in `package.json`  
  确保package.json中的项目依赖关系
- Ensure project dependencies in your app module  
  确保您的应用模块中的项目依赖关系
- Adds Prebuilt or Setup Custom Theme  
  添加预置或设置自定义主题
- Adds Roboto fonts to your index.html  
  将Roboto字体添加到您的index.html
- Apply simple CSS reset to body  
  将简单的CSS重置应用于body


## Generator Schematics
## 生成原理图
In addition to the install schematic Angular Material has three schematics it comes packaged with:  
除了安装示意图以外，Angular Material还提供三种原理图：

- Navigation  
  导航
- Dashboard  
  控制台
- Table  
  数据表

### Navigation Schematic
### 导航原理图
The navigation schematic will create a new component that includes
a toolbar with the app name and the side nav responsive based on Material
breakpoints.  
导航示意图将创建一个新组件，其中包含一个带有应用程序名称的工具栏，以及基于材料断点响应的侧边导航栏。

```
ng generate @angular/material:material-nav --name <component-name>
```

### Dashboard Schematic
### 控制台原理图
The dashboard schematic will create a new component that contains
a dynamic grid list of cards.  
控制台原理图将创建一个包含卡片动态网格列表的新组件。

```
ng generate @angular/material:material-dashboard --name <component-name>
```

### Table Schematic
### 数据表原理图
The table schematic will create a new table component pre-configured
with a datasource for sorting and pagination.  
表格示意图将创建一个新的表格组件，预先配置一个用于排序和分页的数据源。

```
ng generate @angular/material:material-table --name <component-name>
```
