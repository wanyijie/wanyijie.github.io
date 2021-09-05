---
summary: "您可以通过 angular.json 中项目的构建目标选项中的 styles 选项添加更多全局样式。这些将被加载，就像您将它们添加到index.html中的<link>标记中一样。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Global styles
# 全局样式

The `styles.css` file allows users to add global styles and supports
[CSS imports](https://developer.mozilla.org/en/docs/Web/CSS/@import).  
`styles.css` 文件允许用户添加全局样式和支持
[CSS imports](https://developer.mozilla.org/en/docs/Web/CSS/@import).

If the project is created with the `--style=sass` option, this will be a `.sass`
file instead, and the same applies to `scss/less/styl`.  
假如项目创建使用 `--style=sass` 选项, 这是一个 `.sass`
文件的代替, 同样适用于 `scss/less/styl`.

You can add more global styles via the `styles` option inside your project's build target options
in `angular.json`.
These will be loaded exactly as if you had added them in a `<link>` tag inside `index.html`.  
您可以通过 `angular.json` 中项目的构建目标选项中的 `styles` 选项添加更多全局样式。这些将被加载，就像您将它们添加到index.html中的<link>标记中一样。


```json
"architect": {
  "build": {
    "builder": "@angular-devkit/build-angular:browser",
    "options": {
      "styles": [
        "src/styles.css",
        "src/more-styles.css",
      ],
      ...
```

You can also rename the output and lazy load it by using the object format:  
您也可以使用对象格式重命名输出并延迟加载它：

```json
"styles": [
  "src/styles.css",
  "src/more-styles.css",
  { "input": "src/lazy-style.scss", "lazy": true },
  { "input": "src/pre-rename-style.scss", "bundleName": "renamed-style" },
],
```

In Sass and Stylus you can also make use of the `includePaths` functionality for both component and
global styles, which allows you to add extra base paths that will be checked for imports.  
在Sass和Stylus中，您还可以使用组件和全局样式的 `includePaths` 功能，这允许您添加额外的基准路径，这些基准路径将被检查以导入。

To add paths, use the `stylePreprocessorOptions` option:  
要添加路径，请使用 `stylePreprocessorOptions` 选项：

```
"stylePreprocessorOptions": {
  "includePaths": [
    "src/style-paths"
  ]
},
```

Files in that folder, e.g. `src/style-paths/_variables.scss`, can be imported from anywhere in your
project without the need for a relative path:  
该文件夹中的文件，例如 'src/style-paths _variables.scss'，可以从项目中的任何位置导入，而不需要相对路径：

```
// src/app/app.component.scss
// A relative path works
// 相对路径工作
@import '../style-paths/variables';
// But now this works as well
// 但现在也工作
@import 'variables';
```

Note: you will also need to add any styles to the `test` builder if you need them for unit tests.  
注意：如果需要它们进行单元测试，您还需要向测试生成器添加任何样式。
