---
summary: "Angular CLI v6通过插入到我们在Angular CLI中使用的构建系统中的ng-packagr提供库支持，以及用于生成库的原理图。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Library support in Angular CLI 6
# 库支持在 Angular CLI 6

Angular CLI v6 comes with library support via [ng-packagr](https://github.com/dherges/ng-packagr)
plugged into the build system we use in Angular CLI, together with schematics for generating a
library.  
Angular CLI v6通过插入到我们在Angular CLI中使用的构建系统中的[ng-packagr](https://github.com/dherges/ng-packagr)提供库支持，以及用于生成库的原理图。


## Generating a library
## 生成库

You can create a library in a existing workspace by running the following commands:  
您可以通过运行以下命令在现有工作区中创建库：

```
ng generate library my-lib
```

You should now have a library inside `projects/my-lib`.
It contains a component and a service inside a NgModule.  
你现在应该在 `projects/my-lib` 中有一个库。它包含一个组件和一个NgModule内的服务。


## Building your library
## 构建你的库

You can build this library via `ng build my-lib`, and also unit test it and lint it by replacing
`build` with `test` or `lint`.  
您可以通过 `ng build my-lib` 来构建这个库，并且还可以通过用test或lint替换构建来对其进行单元测试并对其进行测试

## Using your library inside your apps
## 在应用中使用库

Before you use your library, it's important to understand the mental model of how libraries are
used in general.  
在使用库之前，了解库一般使用的心理模型很重要。

When you want to use a library from `npm`, you must:
当你想从npm使用一个库时，你必须：

- install the library into node_modules via `npm install library-name`  
  通过 `npm install library-name` 将库安装到node_modules中
- import it in your application by name `import { something } from 'library-name';`  
  通过 `import { something } from 'library-name';` 将库安装到node_modules中

This works because importing a library in Angular CLI looks for a mapping between library name
and location on disk.  
这是有效的，因为在Angular CLI中导入库会查找本地磁盘上库名声带库和位置之间的映射。

Angular CLI first looks in your tsconfig paths, then in the node_modules folder.  
Angular CLI首先在您的tsconfig路径中查找，然后在node_modules文件夹中查找。

When you build your own libraries it doesn't go into node_modules so we use the tsconfig paths
to tell the build system where it is.
Generating a library automatically adds its path to the tsconfig file.  
当您构建自己的库时，它不会进入node_modules，因此我们使用tsconfig路径来告诉构建系统它在哪里。生成库自动将其路径添加到tsconfig文件。

Using your own library follows a similar pattern:  
使用你自己的库遵循类似的模式：

- build the library via `ng build my-lib`  
  通过 `ng build my-li` b构建库
- import it in your application by name `import { something } from 'my-lib';`  
  通过`import { something } from 'my-lib';` 导入到应用程序中;

It's important to note that your app can never use your library before it is built.  
请注意，您的应用在构建之前不能使用您的库。

For instance, if you clone your git repository and run `npm install`, your editor will show
the `my-lib` imports as missing.
This is because you haven't yet built your library.  
例如，如果你克隆你的git仓库并运行npm install，你的编辑器会显示缺少my-lib导入。这是因为你还没有建立你的图书馆。

Another common problem is changes to your library not being reflected in your app.
This is often because your app is using an old build of your library.
If this happens just rebuild your library.  
另一个常见问题是您的库的更改没有反映在您的应用程序中。这通常是因为你的应用程序正在使用你的库的旧版本。如果发生这种情况只是重建你的图书馆。


## Publishing your library
## 发布你的库


To publish your library follow these steps:  
要发布您的库，请按照以下步骤操作

```
ng build my-lib --prod
cd dist/my-lib
npm publish
```

If you've never published a package in npm before, you will need to create a user account.
You can read more about publishing on npm here:
https://docs.npmjs.com/getting-started/publishing-npm-packages  
如果您以前从未在npm发布过软件包，则需要创建一个用户帐户。你可以在这里阅读更多关于npm的发布：https://docs.npmjs.com/getting-started/publishing-npm-packages

The `--prod` flag should be used when building to publish because it will completely clean the build
directory for the library beforehand, removing old code leftover code from previous versions.  
构建发布时应使用 `--prod` 标志，因为它会事先完全清除库的构建目录，从旧版本中删除旧的代码剩余代码。


## Why do I need to build the library everytime I make changes?
## 每当我进行更改时，为什么需要构建库？

Running `ng build my-lib` every time you change a file is bothersome and takes time.  
每次更改文件时运行构建my-lib都很麻烦并且需要时间。

Some similar setups instead add the path to the source code directly inside tsconfig.
This makes seeing changes in your app faster.  
一些类似的设置直接在tsconfig中添加源代码的路径。这可以更快地查看应用程序的更改。

But doing that is risky.
When you do that, the build system for your app is building the library as well.
But your library is built using a different build system than your app.  
但这样做是有风险的。当你这样做时，你的应用程序的构建系统也在构建这个库。但是你的库是使用与你的应用程序不同的构建系统构建的

Those two build systems can build things slightly different, or support completely different
features.  
这两个构建系统可以构建稍微不同的东西，或支持完全不同的功能。

This leads to subtle bugs where your published library behaves differently from the one in your
development setup.  
这会导致您发布的库的行为与开发设置中的行为不同的细微错误。
For this reason we decided to err on the side of caution, and make the recommended usage
the safe one.  
出于这个原因，我们决定谨慎犯错，并推荐使用安全的产品。

In the future we want to add watch support to building libraries so it is faster to see changes.  
在将来，我们希望增加对建筑图书馆的监视支持，以便更快地查看更改。

We are also planning to add internal dependency support to Angular CLI.
This means that Angular CLI would know your app depends on your library, and automatically rebuilds
the library when the app needs it.  
我们还计划向Angular CLI添加内部依赖关系支持。这意味着Angular CLI会知道你的应用程序依赖于你的库，并在应用程序需要时自动重建库


## Note for upgraded projects
## 升级项目的注意事项

If you are using an upgraded project, there are some additional changes you have to make to support
monorepo (a workspace with multiple projects) setups:  
如果您正在使用升级项目，则需要进行一些其他更改才能支持monorepo（具有多个项目的工作区）设置：

- in `angular.json`, change the `outputPath` to `dist/project-name` for your app
  在 `angular.json`中, 修改 `outputPath` 为 `dist/project-name` 为你的项目
- remove `baseUrl` in `src/tsconfig.app.json` and `src/tsconfig.spec.json`
  移除 `baseUrl` 在 `src/tsconfig.app.json` 和 `src/tsconfig.spec.json`
- add `"baseUrl": "./"` in `./tsconfig.json`
  添加 `"baseUrl": "./"` 在 `./tsconfig.json`
- change any absolute path imports in your app to be absolute from the root (including `src/`),
or make them relative  
将您的应用程序中的所有绝对路径导入更改为绝对路径（包括src /），或使它们相对

This is necessary to support multiple projects in builds and in your editor.
New projects come with this configuration by default.  
这对于在编译和编辑器中支持多个项目是必需的。新项目默认配置此配置。
