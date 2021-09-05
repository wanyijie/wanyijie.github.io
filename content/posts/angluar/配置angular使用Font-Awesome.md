---
summary: "Font Awesome为您提供可立即定制的可缩放矢量图标 - 尺寸，颜色，阴影以及任何可以通过CSS强大功能进行定制的图标。"
tags:
    - wangyijie
categories:
    - Development
    - Opetration
---
# Include [Font Awesome](http://fontawesome.io/)
# 包含 [Font Awesome](http://fontawesome.io/)

[Font Awesome](http://fontawesome.io/) gives you scalable vector icons that can instantly be customized — size, color, drop shadow, and anything that can be done with the power of CSS.  
[Font Awesome](http://fontawesome.io/) 为您提供可立即定制的可缩放矢量图标 - 尺寸，颜色，阴影以及任何可以通过CSS强大功能进行定制的图标。

Create a new project and navigate into the project...  
创建一个新项目并导航到项目中...
```
ng new my-app
cd my-app
```

Install the `font-awesome` library and add the dependency to package.json...  
安装font-awesome库并将依赖关系添加到package.json...
```bash
npm install --save font-awesome
```

### Using CSS
### 使用 CSS

To add Font Awesome CSS icons to your app...  
将Font Awesome CSS图标添加到您的应用程序...
```json
// in angular.json
"build": {
  "options": {
    "styles": [
      "../node_modules/font-awesome/css/font-awesome.css"
      "styles.css"
    ],
  }
}
```
### 使用 SASS

Create an empty file _variables.scss in src/.  
在 `src/` 中创建一个空文件 `_variables.scss`。

Add the following to _variables.scss:  
将以下内容添加到 `_variables.scss`：

```
$fa-font-path : '../node_modules/font-awesome/fonts';
```
In styles.scss add the following:  
在 `instles.scss` 中添加如下内容：

```
@import 'variables';
@import '../node_modules/font-awesome/scss/font-awesome';
```
### Test
### 测试

Run `ng serve` to run your application in develop mode, and navigate to `http://localhost:4200`.  
运行 `ng serve` 以开发模式运行您的应用程序，并导航到 `http//localhost:4200`。

To verify Font Awesome has been set up correctly, change `src/app/app.component.html` to the following...  
要验证 `Font Awesome` 已正确设置，请将 `src/app/app.component.html` 更改为以下内容...
```html
<h1>
  {{title}} <i class="fa fa-check"></i>
</h1>
```

After saving this file, return to the browser to see the Font Awesome icon next to the app title.  
保存此文件后，返回到浏览器以查看应用标题旁边的 `Font Awesome` 图标。

### More Info
### 更多信息

- [Examples](http://fontawesome.io/examples/)
- [示例](http://fontawesome.io/examples/)
