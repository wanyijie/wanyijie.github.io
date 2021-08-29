## Include [Flex Layout](https://github.com/angular/flex-layout) in your CLI application
## 在您的CLI应用程序中包含[Flex布局](https://github.com/angular/flex-layout)

<a href="https://tburleson-layouts-demos.firebaseapp.com/#/docs" target="_blank">
  <img src="https://user-images.githubusercontent.com/210413/28999595-65e9be78-7a11-11e7-9403-69ecae10fcb4.png"></img>
</a>

> Above is snapshot of a [Online Demos](https://tburleson-layouts-demos.firebaseapp.com/#/docs) using @angular/flex-layout  
> 这个截图是一个[在线演示](https://tburleson-layouts-demos.firebaseapp.com/#/docs)使用@angular/flex-layout


<br/>

### Include `@angular/flex-layout` as detailed below:
### 包含 `@angular/flex-layout` 详情如下:

Install the  library and add the dependency to package.json...  
安装该库并将依赖项添加到package.json...
```bash
npm install --save @angular/flex-layout
```

Or install the nightly build using:  
或者使用以下命令安装每晚构建:

```bash
npm i --save @angular/flex-layout-builds
```

Import the Angular Flex-Layout NgModule into your app module...  
将Angular Flex布局NgModule导入您的应用程序模块...
```javascript
//in src/app/app.module.ts 

import { FlexLayoutModule } from '@angular/flex-layout';
// other imports 

@NgModule({
  imports: [
    ...
    FlexLayoutModule
  ],
  ...
})
```

Run `ng serve` to run your application in develop mode, and navigate to `http://localhost:4200`  
运行 `ng serve` 以开发模式运行您的应用程序，并导航到 `http://localhost：4200`

<br/>

### Sample App
### 示例应用程序

添加下列内容到 `src/app/app.component.css`...
```css
[fxLayout="column"] { border: 1px solid;padding:4px; margin-top:50px; },
[fxFlex]{  padding:5px;},
h3      {  padding-top:20px; },
.header {  background-color: lightyellow;  },
.left   {  background-color: lightblue;  },
.right  {  background-color: pink;  }
```

要验证flex-layout已正确设置，请更改 `src/app/app.component.html` 为以下内容...
```html
 <div fxLayout="column">
   <div class="header" fxLayout="row" fxLayoutAlign="space-between center">
       <h3>
         {{title}}
       </h3>
   </div>
   <div fxLayout="row">
       <div class="left" fxFlex="20"> LEFT: 20% wide </div>
       <div class="right" fxFlex> RIGHT: 80% wide </div>
   </div>
 </div>
 ```

After saving this file, return to the browser to see the very ugly but demonstrative flex-layout.  
保存此文件后，返回浏览器查看非常丑陋但具有示范性的弹性布局。

![screen shot 2017-08-05 at 7 20 05 pm](http://upload-images.jianshu.io/upload_images/6000429-c8619053871e27e0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Among what you should see are - a light yellow header that is the entire width of the window, sitting directly atop 2 columns. Of those 2 columns, the left column should be light blue, and 20% wide, while the right column is pink, 80% to start, and will flex with window (re)size.  
在你应该看到的是 - 一个淡黄色的标题，是整个窗口的宽度，直接坐在2列上。在这2列中，左栏应为浅蓝色，宽20％。在这2列中，左列应该是浅蓝色，宽20％，右列是粉红色，80％开始，并且会随着窗口（再）尺寸而弯曲。

<br/>

### More Info 
### 更多信息

 - [Installation](https://github.com/angular/flex-layout/wiki/Using-Angular-CLI)
 - [API Overview](https://github.com/angular/flex-layout/wiki/Declarative-API-Overview)
 - [Demo](https://tburleson-layouts-demos.firebaseapp.com/#/docs)

