---
summary: "在库工作时，它通常使用 [npm link] 避免在每次构建时重复安装库。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Linked libraries
# 链接库

While working on a library, it is common to use [npm link](https://docs.npmjs.com/cli/link) to
avoid reinstalling the library on every build.  
在库工作时，它通常使用 [npm link] 避免在每次构建时重复安装库。

While this is very useful there are a few caveats to keep in mind.  
虽然这是非常有用的, 有几个告诫要牢记。

## The library needs to be AOT compatible
## 库需要 AOT 兼容

Angular CLI does static analysis even without the `--aot` flag in order to detect lazy-loade routes.
If your library is not AOT compatible, you will likely get a static analysis error.  
Angular CLI 静态分析即使没有 `--aot` 标记，为了惰加载路由。假如你的库不是AOT兼容，你将获得一个静态分析错误。

## The library still needs to be rebuilt on every change
## 每次改变库仍热需要重构

Angular libraries are usually built using TypeScript and thus require to be built before they
are published.
For simple cases, a linked library might work even without a build step, but this is the exception
rather than the norm.  
Angular的库经常使用Typescript构建，因此要求构建之前他们已经发布过。对于简单案例，即使没有生成步骤, 链接库也可能工作, 但这是例外
而不是规范。


If a library is not being built using its own build step, then it is being compiled by the
Angular CLI build system and there is no guarantee that it will be correctly built.
Even if it works on development it might not work when deployed.  
如果库未使用自己的构建步骤生成, 则由
Angular CLI 构建系统, 并不能保证它将被正确构建。即使它对开发起作用, 部署时也可能不起作用。 


When linking a library remember to have your build step running in watch mode and the library's
`package.json` pointing at the correct entry points (e.g. 'main' should point at a `.js` file, not
a `.ts` file).  
链接库时, 请记住在监视模式和库包中运行生成步骤. json 指向正确的入口点 (例如, `main` 应该指向 `.js` 文件, 而不是 `.ts` 文件)。


## Use TypesScript path mapping for Peer Dependencies
## 使用 TypesScript 路径映射每个依赖

Angular libraries should list all `@angular/*` dependencies as
[Peer Dependencies](https://nodejs.org/en/blog/npm/peer-dependencies/).
This insures that, when modules ask for Angular, they all get the exact same module.
If a library lists `@angular/core` in `dependencies` instead of `peerDependencies` then it might
get a *different* Angular module instead, which will cause your application to break.  
库应将所有角度/依赖项列出为对等依赖项。这保证, 当模块要求角, 他们都得到完全相同的模块。如果库在依赖项中列出了角度/核心而不是 peerDependencies, 那么它可能会得到一个不同的角度模块, 这将导致应用程序中断。

While developing a library, you'll need to have all of your peer dependencies also installed
via `devDependencies` - otherwise you could not compile.
A linked library will then have it's own set of Angular libraries that it is using for building,
located in it's `node_modules` folder.
This can cause problems while building or running your application.  
在开发库时, 您还需要通过 devDependencies 安装所有的对等依赖项, 否则您无法编译。链接库将有自己的一组用于构建的 `angular`库, 位于其 `node_modules` 文件夹中。这可能会导致生成或运行应用程序时出现问题


To get around this problem you can use the TypeScript
[path mapping](https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping).
With it, you can tell TypeScript that it should load some modules from a specific location.  
要解决此问题, 可以使用文稿[路径映射](https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping)。通过它, 您可以告诉文稿它应该从特定位置加载一些模块。

You should list all the peer dependencies that your library uses in `./tsconfig.json`, pointing
them at the local copy in the apps `node_modules` folder.
This ensures that you all will always load the local copies of the modules your library asks for.  
您应该列出库在 `.tsconfig` 中使用的所有对等依赖项, 并将它们指向应用程序 `node_modules` 文件夹中的本地副本。这将确保您始终加载库要求的模块的本地副本。

```
{
  "compilerOptions": {
    // ...
    // Note: these paths are relative to `baseUrl` path.
    "paths": {
      "@angular/*": [
        "../node_modules/@angular/*"
      ]
    }
  }
}
```
