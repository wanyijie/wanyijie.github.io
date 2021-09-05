---
summary: "Angular CLI 支持为应用程序生成通用集成。这是一个 CommonJS 格式的包, 可以通过 `require()` 进入节点应用程序 , 并与`@angular/platform-server` 的 api 一起使用以预渲染应用程序。"
tags:
    - wangyijie
categories:
    - Development
    - Opetration
---
# Angular Universal Integration
# Angular 通用集成

The Angular CLI supports generation of a Universal build for your application. This is a CommonJS-formatted bundle which can be `require()`'d into a Node application (for example, an Express server) and used with `@angular/platform-server`'s APIs to prerender your application.  
Angular CLI 支持为应用程序生成通用集成。这是一个 CommonJS 格式的包, 可以通过 `require()` 进入节点应用程序 , 并与`@angular/platform-server` 的 api 一起使用以预渲染应用程序。

---

## Example CLI Integration:
## CLI 集成例子:

[Angular Universal-Starter](https://github.com/angular/universal-starter) - Clone the universal-starter for a working example.  
[Angular 通用启动器](https://github.com/angular/universal-starter) -克隆通用启动器的一个工作示例。 -

---

# Integrating Angular Universal into existing CLI Applications
# 将Angular Universal集成到现有的CLI应用程序中

This story will show you how to set up Universal bundling for an existing `@angular/cli` project in 5 steps.  
这个故事将向您展示如何通过5个步骤为现有的 `@angular/cli` 项目设置通用构建。

---

## Install Dependencies
## 安装依赖

Install `@angular/platform-server` into your project. Make sure you use the same version as the other `@angular` packages in your project.  
安装 `@angular/platform-server` 到你的项目. 确保您的项目中使用与其他@angular软件包相同的版本。

> You'll also need ts-loader (for your webpack build we'll show later) and @nguniversal/module-map-ngfactory-loader, as it's used to handle lazy-loading in the context of a server-render. (by loading the chunks right away)
> 您还需要ts-loader（用于您的webpack构建，稍后会显示）和 `@nguniversal/module-map-ngfactory-loader`，因为它用于处理服务器呈现环境中的延迟加载。 （通过立即加载块）

```bash
$ npm install --save @angular/platform-server @nguniversal/module-map-ngfactory-loader ts-loader
```

## Step 1: Prepare your App for Universal rendering
## 步骤一：准备您的应用程序进行通用渲染

The first thing you need to do is make your `AppModule` compatible with Universal by adding `.withServerTransition()` and an application ID to your `BrowserModule` import:  
您需要做的第一件事是通过向您的 `BrowserModule` 导入添加 `.withServerTransition（）`和一个应用程序ID，使您的 `AppModule` 与通用兼容：


### src/app/app.module.ts:

```javascript
@NgModule({
  bootstrap: [AppComponent],
  imports: [
    // Add .withServerTransition() to support Universal rendering.
    // The application ID can be any identifier which is unique on
    // the page.
    BrowserModule.withServerTransition({appId: 'my-app'}),
    ...
  ],

})
export class AppModule {}
```

Next, create a module specifically for your application when running on the server. It's recommended to call this module `AppServerModule`.  
接下来，在服务器上运行时，专门为您的应用程序创建一个模块。建议调用这个模块`AppServerModule`。

This example places it alongside `app.module.ts` in a file named `app.server.module.ts`:  
这个例子将它放在 `app.module.ts` 名为的文件 `app.server.module.ts`旁边: 


### src/app/app.server.module.ts:

You can see here we're simply Importing everything from AppModule, followed by ServerModule.  
您可以在这里看到我们只是从AppModule导入所有内容，然后导入ServerModule。

> One important thing to Note: We need `ModuleMapLoaderModule` to help make Lazy-loaded routes possible during Server-side renders with the Angular CLI.  
注意一件重要的事情：我们需要使用ModuleMapLoaderModule，以便在使用Angular CLI进行服务器端呈现期间使延迟加载的路由成为可能。  


```typescript
import {NgModule} from '@angular/core';
import {ServerModule} from '@angular/platform-server';
import {ModuleMapLoaderModule} from '@nguniversal/module-map-ngfactory-loader';

import {AppModule} from './app.module';
import {AppComponent} from './app.component';

@NgModule({
  imports: [
    // The AppServerModule should import your AppModule followed
    // by the ServerModule from @angular/platform-server.
    AppModule,
    ServerModule,
    ModuleMapLoaderModule // <-- *Important* to have lazy-loaded routes work
  ],
  // Since the bootstrapped component is not inherited from your
  // imported AppModule, it needs to be repeated here.
  bootstrap: [AppComponent],
})
export class AppServerModule {}
```

---
## Step 2: Create a server "main" file and tsconfig to build it
## 步骤二: 创建服务器 "main" 文件并 tsconfig 以生成它

Create a main file for your Universal bundle. This file only needs to export your `AppServerModule`. It can go in `src`. This example calls this file `main.server.ts`:  
创建一个主文件为通用包. 这个文件只需要导出你的 `AppServerModule`. 它可以进去 `src`. 这个例子调用这个文件 `main.server.ts`:

### src/main.server.ts:

```typescript
export { AppServerModule } from './app/app.server.module';
```

Copy `tsconfig.app.json` to `tsconfig.server.json` and change it to build with a `"module"` target of `"commonjs"`.  
复制`tsconfig.app.json` 到 `tsconfig.server.json` 并改变它与建立一个 `"module"` 目标为 `"commonjs"`.

Add a section for `"angularCompilerOptions"` and set `"entryModule"` to your `AppServerModule`, specified as a path to the import with a hash (`#`) containing the symbol name. In this example, this would be `app/app.server.module#AppServerModule`.  
为 `“angularCompilerOptions”` 添加一个属性并将 `“entryModule”` 设置为您的`AppServerModule`，使用包含符号名称的散列（＃）指定为导入路径。在这个例子中，这将是`app/app.server.module＃AppServerModule`。


### src/tsconfig.server.json:

```javascript
{
  "extends": "../tsconfig.json",
  "compilerOptions": {
    "outDir": "../out-tsc/app",
    "baseUrl": "./",
    // Set the module format to "commonjs":
    "module": "commonjs",
    "types": []
  },
  "exclude": [
    "test.ts",
    "**/*.spec.ts"
  ],
  // Add "angularCompilerOptions" with the AppServerModule you wrote
  // set as the "entryModule".
  "angularCompilerOptions": {
    "entryModule": "app/app.server.module#AppServerModule"
  }
}
```

---
## Step 3: Create a new target in `angular.json`
## 步骤三: 在 `angular.json` 中创建一个目标

In `angular.json` locate the `architect` property inside your project, and add a new `server`
target:  
在 `angular.json` 中找到项目中的 `architect` 属性，并添加一个新的 `server` 属性：

```javascript
"architect": {
  "build": { ... }
  "server": {
    "builder": "@angular-devkit/build-angular:server",
    "options": {
      "outputPath": "dist/your-project-name-server",
      "main": "src/main.server.ts",
      "tsConfig": "src/tsconfig.server.json"
    }
  }
}
```

## Building the bundle
## 构建包

With these steps complete, you should be able to build a server bundle for your application, using the `--app` flag to tell the CLI to build the server bundle, referencing its index of `1` in the `"apps"` array in `.angular-cli.json`:  
完成这些步骤后，您应该能够为应用程序构建一个服务器包，使用 `--app` 标志告诉CLI构建服务器包，在.` angular-cli.json 中apps”数组中引用索引1以.json：

```bash
# This builds your project using the server target, and places the output
# in dist/your-project-name-server/
$ ng run your-project-name:server

Date: 2017-07-24T22:42:09.739Z
Hash: 9cac7d8e9434007fd8da
Time: 4933ms
chunk {0} main.js (main) 9.49 kB [entry] [rendered]
chunk {1} styles.css (styles) 0 bytes [entry] [rendered]
```

---


## Step 4: Setting up an Express Server to run our Universal bundles  
## 设置Express服务器来运行我们的Universal套件

Now that we have everything set up to -make- the bundles, how we get everything running?  
现在我们已经把所有东西都设置成了 - 捆绑包，我们如何让所有的东西都运行？

PlatformServer offers a method called `renderModuleFactory()` that we can use to pass in our AoT'd AppServerModule, to serialize our application, and then we'll be returning that result to the Browser.  
PlatformServer提供了一个名为 `renderModuleFactory()` 的方法，我们可以使用它传递我们的预编译支持AppServerModule，序列化我们的应用程序，然后我们将返回结果给浏览器。

```typescript
app.engine('html', (_, options, callback) => {
  renderModuleFactory(AppServerModuleNgFactory, {
    // Our index.html
    document: template,
    url: options.req.url,
    // DI so that we can get lazy-loading to work differently (since we need it to just instantly render it)
    extraProviders: [
      provideModuleMap(LAZY_MODULE_MAP)
    ]
  }).then(html => {
    callback(null, html);
  });
});
```

You could do this, if you want complete flexibility, or use an express-engine with a few other built in features from [`@nguniversal/express-engine`](https://github.com/angular/universal/tree/master/modules/express-engine) found here.  
你可以做到这一点，如果你想要完全的灵活性，或者使用Express引擎和其他一些内置的功能，你可以在这里找到 `@nguniversal/express-engine`。

```typescript
// It's used as easily as
import { ngExpressEngine } from '@nguniversal/express-engine';

app.engine('html', ngExpressEngine({
  bootstrap: AppServerModuleNgFactory,
  providers: [
    provideModuleMap(LAZY_MODULE_MAP)
  ]
}));
```

Below we can see a TypeScript implementation of a -very- simple Express server to fire everything up.  
下面我们可以看到一个简单的Express服务器的TypeScript实现来启动一切

> Note: This is a very bare bones Express application, and is just for demonstrations sake. In a real production environment, you'd want to make sure you have other authentication and security things setup here as well. This is just meant just to show the specific things needed that are relevant to Universal itself. The rest is up to you!  
注意：这是一个非常简单的Express应用程序，只是为了演示。在真实的生产环境中，您需要确保您在此处设置了其他身份验证和安全性功能。这只是为了显示与通用本身相关的具体事情。其余的由你决定！

At the ROOT level of your project (where package.json / etc are), created a file named: **`server.ts`**  
在项目的根级别（package.json / etc所在的位置）创建一个名为：**`server.ts`** 的文件

### ./server.ts (root project level)

```typescript
// These are important and needed before anything else
import 'zone.js/dist/zone-node';
import 'reflect-metadata';

import { renderModuleFactory } from '@angular/platform-server';
import { enableProdMode } from '@angular/core';

import * as express from 'express';
import { join } from 'path';
import { readFileSync } from 'fs';

// Faster server renders w/ Prod mode (dev mode never needed)
enableProdMode();

// Express server
const app = express();

const PORT = process.env.PORT || 4000;
const DIST_FOLDER = join(process.cwd(), 'dist');

// Our index.html we'll use as our template
const template = readFileSync(join(DIST_FOLDER, 'browser', 'index.html')).toString();

// * NOTE :: leave this as require() since this file is built Dynamically from webpack
const { AppServerModuleNgFactory, LAZY_MODULE_MAP } = require('./dist/server/main.bundle');

const { provideModuleMap } = require('@nguniversal/module-map-ngfactory-loader');

app.engine('html', (_, options, callback) => {
  renderModuleFactory(AppServerModuleNgFactory, {
    // Our index.html
    document: template,
    url: options.req.url,
    // DI so that we can get lazy-loading to work differently (since we need it to just instantly render it)
    extraProviders: [
      provideModuleMap(LAZY_MODULE_MAP)
    ]
  }).then(html => {
    callback(null, html);
  });
});

app.set('view engine', 'html');
app.set('views', join(DIST_FOLDER, 'browser'));

// Server static files from /browser
app.get('*.*', express.static(join(DIST_FOLDER, 'browser')));

// All regular routes use the Universal engine
app.get('*', (req, res) => {
  res.render(join(DIST_FOLDER, 'browser', 'index.html'), { req });
});

// Start up the Node server
app.listen(PORT, () => {
  console.log(`Node server listening on http://localhost:${PORT}`);
});
```

## Step 5: Setup a webpack config to handle this Node server.ts file and serve your application! 
## 第5步：设置一个webpack配置来处理这个Node server.ts文件并为您的应用程序提供服务

Now that we have our Node Express server setup, we need to pack it and serve it!  
现在我们已经安装了Node Express服务器，我们需要打包并提供服务！

Create a file named `webpack.server.config.js` at the ROOT of your application.  
在应用程序的ROOT处创建一个名为 `webpack.server.config.js` 的文件。

> This file basically takes that server.ts file, and takes it and compiles it and every dependency it has into `dist/server.js`.  
这个文件基本上接受了server.ts文件，并将其编译到 `dist/server.js` 中。

### ./webpack.server.config.js (root project level)

```typescript
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: {  server: './server.ts' },
  resolve: { extensions: ['.js', '.ts'] },
  target: 'node',
  // this makes sure we include node_modules and other 3rd party libraries
  externals: [/(node_modules|main\..*\.js)/],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: '[name].js'
  },
  module: {
    rules: [
      { test: /\.ts$/, loader: 'ts-loader' }
    ]
  },
  plugins: [
    // Temporary Fix for issue: https://github.com/angular/angular/issues/11580
    // for "WARNING Critical dependency: the request of a dependency is an expression"
    new webpack.ContextReplacementPlugin(
      /(.+)?angular(\\|\/)core(.+)?/,
      path.join(__dirname, 'src'), // location of your src
      {} // a map of your routes
    ),
    new webpack.ContextReplacementPlugin(
      /(.+)?express(\\|\/)(.+)?/,
      path.join(__dirname, 'src'),
      {}
    )
  ]
}
```

**Almost there!**  
**差不多了！**

Now let's see what our resulting structure should look like, if we open up our `/dist/` folder we should see:  
现在让我们看看我们的结构应该是什么样子，如果我们打开我们应该看到的 `/dist/` 文件夹：

```
/dist/
   /browser/
   /server/
```

To fire up the application, in your terminal enter  
要启动应用程序，请在终端中输入

```bash
node dist/server.js
```

:sparkles:

Now lets create a few handy scripts to help us do all of this in the future.  
现在让我们创建一些便利的脚本来帮助我们在未来完成所有这些。

```json
"scripts": {

  // These will be your common scripts
  "build:ssr": "npm run build:client-and-server-bundles && npm run webpack:server",
  "serve:ssr": "node dist/server.js",

  // Helpers for the above scripts
  "build:client-and-server-bundles": "ng build --prod && ng build --prod --app 1 --output-hashing=false",
  "webpack:server": "webpack --config webpack.server.config.js --progress --colors"
}
```

In the future when you want to see a Production build of your app with Universal (locally), you can simply run:  
在将来，当您想通过Universal（本地）查看您的应用程序的Production版本时，只需运行：

```bash
npm run build:ssr && npm run serve:ssr
```

Enjoy!  
 欣赏!

Once again to see a working version of everything, check out the [universal-starter](https://github.com/angular/universal-starter).  
再次看到一切的工作版本，请查看[通用启动器](https://github.com/angular/universal-starter)。
