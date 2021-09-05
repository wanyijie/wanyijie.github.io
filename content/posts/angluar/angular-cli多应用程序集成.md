---
summary: "Angular CLI 支持多应用程序在一个项目中，您可以使用 `.angular-cli.json` 中的应用程序数组来列出要用于不同应用程序的文件和文件夹。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Multiple Apps integration
# 多应用程序集成

Angular CLI supports multiple applications within one project.
You use the `apps` array in `.angular-cli.json` to list files and folders you want to use for different apps.  
Angular CLI 支持多应用程序在一个项目中，您可以使用 `.angular-cli.json` 中的应用程序数组来列出要用于不同应用程序的文件和文件夹。


By default one app is created when then new project is created and `apps` array looks like:  
默认情况下, 在创建新项目时创建一个应用程序, 并且 `apps` 数组如下所示:
```
"apps": [
  {
    "root": "src",
    ...
    "main": "main.ts",
    "polyfills": "polyfills.ts",
    "test": "test.ts",
    "tsconfig": "tsconfig.app.json",
    "testTsconfig": "tsconfig.spec.json",
    "prefix": "app",
    ...
  }
],
```

To create another app you can copy the app object and then change the values for the options you want to change. eg. If I want to create another app with different `main`, `polyfills`, `test` and `prefix` and keep other configurations such as `assets`, `styles`, `environment` etc. same. I can add it to apps array as below.  
若要创建其他应用程序, 可以复制应用程序对象, 然后更改要更改的选项的值。如如果我想创建另一个具有不同的 `main`、`polyfills`、`test`和 `prefix` 的应用程序, 并保留其他配置, 如 `assets`、`styles`、`enviroment`等。我可以添加到应用程序阵列如下。

```
"apps": [
  {
    "root": "src",
    ...
    "main": "main.ts",
    "polyfills": "polyfills.ts",
    "test": "test.ts",
    "tsconfig": "tsconfig.app.json",
    "testTsconfig": "tsconfig.spec.json",
    "prefix": "app",
    ...
  },
  {
    "root": "src",
    ...
    "main": "main2.ts",
    "polyfills": "polyfills2.ts",
    "test": "test2.ts",
    "tsconfig": "tsconfig.app.json",
    "testTsconfig": "tsconfig.spec.json",
    "prefix": "app2",
    ...
  }  
],
```
Now we can `serve`, `build` etc. both the apps by passing the app index with the commands. By default, it will pick the first app only.  
现在, 我们可以通过使用命令传递应用程序索引来 `serve`、`build` 等应用程序。默认情况下, 它将选择第一个应用程序。

To serve the first app: `ng serve --app=0` or `ng serve --app 0`  
为第一个应用程序运行： `ng serve --app=0` 或 `ng serve --app 0` 

To serve the second app: `ng serve --app=1` or `ng serve --app 1`
为第二个应用程序运行: `ng serve --app=1` 或 `ng serve --app 1`

You can also add the `name` property to the app object in `apps` array and then pass it to commands to distinguish between different applications.  
您还可以将 `name` 属性添加到 `apps` 组中的应用程序对象中, 然后将其传递给命令以区分不同的应用程序。

```
"apps": [
  {
    "name": "app1",
    "root": "src",
    "outDir": "dist",
....
```
To serve application by name `ng serve --app=app1` or `ng serve --app app1`.  
按名称运行应用程序 `ng serve --app=app1` 或 `ng serve --app app1`. 
