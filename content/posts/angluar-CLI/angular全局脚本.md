# Global scripts
# 全局脚本

You can add Javascript files to the global scope via the `scripts` option inside your
project's build target options in `angular.json`.
These will be loaded exactly as if you had added them in a `<script>` tag inside `index.html`.  
您可以通过angular.json中项目的构建目标选项中的 `脚本` 选项将JavaScript文件添加到全局范围。这些将被加载，就像您将它们添加到 `index.html` 中的 `<script>` 标记中一样。 
This is especially useful for legacy libraries or analytic snippets.  
这对旧版库或分析片段尤其有用。

```json
"architect": {
  "build": {
    "builder": "@angular-devkit/build-angular:browser",
    "options": {
      "scripts": [
        "src/global-script.js",
      ],
```

You can also rename the output and lazy load it by using the object format:  
您也可以使用对象格式重命名输出并延迟加载它：

```json
"scripts": [
  "src/global-script.js",
  { "input": "src/lazy-script.js", "lazy": true },
  { "input": "src/pre-rename-script.js", "bundleName": "renamed-script" },
],
```

Note: you will also need to add any scripts to the `test` builder if you need them for unit tests.  
注意：如果需要它们进行单元测试，您还需要将任何脚本添加到测试生成器。

## Using global libraries inside your app
## 在应用程序内使用全局库

Once you import a library via the scripts array, you should **not** import it via a import statement
in your TypeScript code (e.g. `import * as $ from 'jquery';`).
If you do that you'll end up with two different copies of the library: one imported as a
global library, and one imported as a module.  
一旦通过脚本数组导入库，您不应该通过TypeScript代码中的import语句导入它（例如， import * as $ from 'jquery'）

This is especially bad for libraries with plugins, like JQuery, because each copy will have
different plugins.  
对于带有插件的库如JQuery来说，这是非常糟糕的，因为每个副本都会有不同的插件。

Instead, download typings for your library (`npm install @types/jquery`) and follow
the [3rd Party Library Installation](https://github.com/angular/angular-cli/wiki/stories-third-party-lib) steps,
this will give you access to the global variables exposed by that library.  
相反，为你的库下载类型 (`npm install @types/jquery`) 和 根据 [3rd Party Library Installation](https://github.com/angular/angular-cli/wiki/stories-third-party-lib) 步骤, 这将使您可以访问该库公开的全局变量，

If the global library you need to use does not have global typings, you can also declare them
manually in `src/typings.d.ts` as `any`:  
如果您需要使用的全局库没有全局类型，您也可以在 `src / typings.d.ts` 中手动声明它们，如下所示：

```
declare var libraryName: any;
```

When working with scripts that extend other libraries, for instance with JQuery plugins
(e.g, `$('.test').myPlugin();`), since the installed `@types/jquery` may not include `myPlugin`,
you would need to add an interface like the one below in `src/typings.d.ts`.  
处理扩展其他库的脚本时，例如使用JQuery插件(e.g, `$('.test').myPlugin();`), 自安装`@types/jquery` 可能不包含 `myPlugin`, 您需要在 `src/typings.d.ts` 中添加如下所示的端口。

```
interface JQuery {
  myPlugin(options?: any): any;
}
```

Otherwise you may see `[TS][Error] Property 'myPlugin' does not exist on type 'JQuery'.` in your IDE.  
否则，你可能会看到 `[TS][Error] Property 'myPlugin' does not exist on type 'JQuery'.` 在你的IDE.
