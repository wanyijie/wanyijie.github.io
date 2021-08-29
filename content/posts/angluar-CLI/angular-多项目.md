# Multiple Projects
# 多项目

Angular CLI supports multiple applications within one workspace.  
Angular CLI支持多个应用在一个工作空间

To create another app you can use the following command:
创建另一个应用程序可以使用下面的命令:
```sh
ng generate application my-other-app
```

The new application will be generated inside `projects/my-other-app`.  
新应用程序 `projects/my-other-app` 将在内部生成.

Now we can `serve`, `build` etc. both the apps by passing the project name with the commands:  
现在, 我们可以通过使用命令传递项目名称来  `serve`, `build` 等两个应用程序:

```sh
ng serve my-other-app
```

You can also create libraries, which is detailed in [Create a library](stories-create-library).  
您还可以创建库, 这在创建库中是详细的。
