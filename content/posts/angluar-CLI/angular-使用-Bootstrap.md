# Include [Bootstrap](http://getbootstrap.com/)
# 包括 [Bootstrap](http://getbootstrap.com/)

[Bootstrap](http://getbootstrap.com/) is a popular CSS framework which can be used within an Angular project.
This guide will walk you through adding bootstrap to your Angular CLI project and configuring it to use bootstrap.  
[Bootstrap](http://getbootstrap.com/) 是一个流行的CSS框架，可以在Angular项目中使用。本指南将引导您为Angular CLI项目添加引导程序并将其配置为使用引导程序。

## Using CSS
## 使用CSS

### Getting Started
### 开始

Create a new project and navigate into the project  
创建一个新项目并导航到项目中

```
ng new my-app
cd my-app
```

### Installing Bootstrap
### 安装 Bootstrap

With the new project created and ready you will next need to install bootstrap to your project as a dependency.
Using the `--save` option the dependency will be saved in package.json  
随着新项目的创建和准备，接下来需要将引导程序作为依赖项安装到项目中。使用--save选项，依赖项将被保存在package.json中

```sh
npm install bootstrap --save
```

### Configuring Project
### 配置项目

Now that the project is set up it must be configured to include the bootstrap CSS.  
现在该项目已经建立，它必须配置为包含引导CSS。

- Open the file `angular.json` from the root of your project.  
  从项目的根目录打开文件angular.json。
- Under the property `projects` find your project.  
  在项目属性下找到你的项目。
- Inside `architect.build.options` locate the `styles` property.  
  在 `architect.build.options` 内部找到 `styles` 属性。
- This property allows external global styles to be applied to your application.   
  该属性允许将外部全局样式应用于您的应用程序。
- Specify the path to `bootstrap.min.css`  
  指定 `bootstrap.min.css` 的路径

  It should look like the following when you are done:  
  完成后它应该如下图所示：
  ```json
  "build": {
    "options": {
      "styles": [
        "../node_modules/bootstrap/dist/css/bootstrap.min.css",
        "styles.css"
      ],
    }
  }
  ```

**Note:** When you make changes to `angular.json` you will need to re-start `ng serve` to pick up configuration changes.  
注意：当您对 `angular.json` 进行更改时，您将需要重新启动服务来获取配置更改。

### Testing Project
### 测试项目

Open `app.component.html` and add the following markup:
打开 `app.component.html` 添加下列标记:

```html
<button class="btn btn-primary">Test Button</button>
```

With the application configured, run `ng serve` to run your application in develop mode.
In your browser navigate to the application `localhost:4200`.
Verify the bootstrap styled button appears.  
在配置应用程序后，运行 `ng serve` 以开发模式运行您的应用程序。在浏览器中导航到应用程序 `localhost:4200`。验证引导样式按钮出现。

## Using SASS
## 使用 SASS

### Getting Started
### 开始

Create a new project and navigate into the project  
创建一个新项目并导航到项目中

```
ng new my-app --style=scss
cd my-app
```

### Installing Bootstrap
### 安装 Bootstrap

```sh
npm install bootstrap --save
```

### Configuring Project
### 配置项目

Create an empty file `_variables.scss` in `src/`.  
在 `src/` 中创建一个文件 `_variables.scss` 

If you are using `bootstrap-sass`, add the following to `_variables.scss`:
如果你使用 `bootstrap-sass`, 将下面的内容添加到 `_variables.scss`:

```sass
$icon-font-path: '../node_modules/bootstrap-sass/assets/fonts/bootstrap/';
```

in `styles.scss` add the following:
在 `styles.scss` 中添加下列内容:

```sass
@import 'variables';
@import '../node_modules/bootstrap/scss/bootstrap';
```

### Testing Project
### 测试项目

Open `app.component.html` and add the following markup:
打开 `app.component.html` 添加下列标记:

```html
<button class="btn btn-primary">Test Button</button>
```

With the application configured, run `ng serve` to run your application in develop mode.
In your browser navigate to the application `localhost:4200`.
Verify the bootstrap styled button appears.
To ensure your variables are used open `_variables.scss` and add the following:  
配置应用程序后， 运行 `ng serve` 启动你的应用程序在开发模式。 在浏览器中导航到你的应用程序 `localhost:4200`. 验证引导样式按钮出现. 要确保您的变量使用打开_variables.scss并添加以下内容

```sass
$primary: red;
```

Return the browser to see the font color changed.  
返回浏览器查看更改的字体颜色。
