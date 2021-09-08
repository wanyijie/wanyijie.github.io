---
summary: "将您的Angular Material应用程序主题化。"
tags:
    - wangyijie
    - angular
    - material
categories:
    - Development
    - Opetration
---
# Theming your Angular Material app
# 将您的Angular Material应用程序主题化


### What is a theme?
### 什么是主题？
A **theme** is the set of colors that will be applied to the Angular Material components. The
library's approach to theming is based on the guidance from the [Material Design spec][1].  
**主题**是将应用于 `Angular Material` 组件的一组颜色。库的主题化方法基于[Material设计规范][1]的指导。

In Angular Material, a theme is created by composing multiple palettes. In particular,
a theme consists of:  
在Angular Material中，通过组合多个调色板来创建主题。特别是，一个主题包括：
* A primary palette: colors most widely used across all screens and components.  
  主调色板：在所有屏幕和组件中使用最广泛的颜色。
* An accent palette: colors used for the floating action button and interactive elements.  
  重音调色板：用于浮动动作按钮和交互式元素的颜色。
* A warn palette: colors used to convey error state.  
  警告调色板：用于传达错误状态的颜色。
* A foreground palette: colors for text and icons.  
  前景调色板：文字和图标的颜色。
* A background palette: colors used for element backgrounds.  
  背景调色板：用于元素背景的颜色。

In Angular Material, all theme styles are generated _statically_ at build-time so that your
app doesn't have to spend cycles generating theme styles on startup.  
在Angular Material中，所有主题样式都是在构建时静态生成的，以便您的应用程序不必在启动时花费周期来生成主题样式。

[1]: https://material.google.com/style/color.html#color-color-palette

### Using a pre-built theme
### 使用预先构建的主题
Angular Material comes prepackaged with several pre-built theme css files. These theme files also
include all of the styles for core (styles common to all components), so you only have to include a
single css file for Angular Material in your app.  
Angular Material预装了几个预先构建的主题css文件。这些主题文件还包括核心的所有样式（所有组件通用的样式），所以你只需要在你的应用中包含一个用于Angular Material的css文件。

You can include a theme file directly into your application from
`@angular/material/prebuilt-themes`  
您可以直接从您的应用程序中包含主题文件`@angular/material/prebuilt-themes`

Available pre-built themes:  
可用的预建主题:
* `deeppurple-amber.css`  
   `深紫色-琥珀色.css`
* `indigo-pink.css`
 `靛青-粉红.css`
* `pink-bluegrey.css`  
  `粉红-蓝灰`
* `purple-green.css`  
  `紫色-绿.css`

If you're using Angular CLI, this is as simple as including one line
in your `styles.css`  file:  
如果您使用的是Angular CLI，这与在styles.css文件中包含一行一样简单：
```css
@import '~@angular/material/prebuilt-themes/deeppurple-amber.css';
```

Alternatively, you can just reference the file directly. This would look something like:  
或者，您可以直接引用该文件。这看起来像这样：
```html
<link href="node_modules/@angular/material/prebuilt-themes/indigo-pink.css" rel="stylesheet">
```
The actual path will depend on your server setup.  
实际路径将取决于您的服务器设置

You can also concatenate the file with the rest of your application's css.  
您还可以将该文件与应用程序的其余CSS进行连接.

Finally, if your app's content **is not** placed inside of a `mat-sidenav-container` element, you
need to add the `mat-app-background` class to your wrapper element (for example the `body`). This
ensures that the proper theme background is applied to your page.  
最后，如果你的应用程序的内容没有放置在 `mat-sidenav-container` 元素中，您需要将 `mat-app-background` 类添加到包装器元素（例如正文)。这可确保正确的主题背景应用于您的页面

### Defining a custom theme  
### 定义自定义主题
When you want more customization than a pre-built theme offers, you can create your own theme file.  
当您需要比预先构建的主题优惠更多的自定义功能时，您可以创建自己的主题文件。 

A custom theme file does two things:  
自定义主题文件有两件事：
1. Imports the `mat-core()` sass mixin. This includes all common styles that are used by multiple
components. **This should only be included once in your application.** If this mixin is included
multiple times, your application will end up with multiple copies of these common styles.  
  导入 `mat-core（）` sass 混合。这包括多个组件使用的所有常见样式。 **这应该只在你的应用程序中包含一次。** 如果这个mixin包含多次，你的应用程序将最终得到这些常用样式的多个副本。
2. Defines a **theme** data structure as the composition of multiple palettes. This object can be
created with either the `mat-light-theme` function or the `mat-dark-theme` function. The output of
this function is then passed to the  `angular-material-theme` mixin, which will output all of the
corresponding styles for the theme.  
 将 **主题** 数据结构定义为多个调色板的组合。可以使用 `mat-light-theme` 方法或 `mat-dark-theme` 方法创建此对象。
然后将方法的输出传递给 `angular-material-theme` 混合，它将输出主题的所有对应样式。


A typical theme file will look something like this:  
一个典型的主题文件将如下所示：
```scss
@import '~@angular/material/theming';
// Plus imports for other components in your app.

// Include the common styles for Angular Material. We include this here so that you only
// have to load a single css file for Angular Material in your app.
// Be sure that you only ever include this mixin once!
@include mat-core();

// Define the palettes for your theme using the Material Design palettes available in palette.scss
// (imported above). For each palette, you can optionally specify a default, lighter, and darker
// hue. Available color palettes: https://material.io/design/color/
$candy-app-primary: mat-palette($mat-indigo);
$candy-app-accent:  mat-palette($mat-pink, A200, A100, A400);

// The warn palette is optional (defaults to red).
$candy-app-warn:    mat-palette($mat-red);

// Create the theme object (a Sass map containing all of the palettes).
$candy-app-theme: mat-light-theme($candy-app-primary, $candy-app-accent, $candy-app-warn);

// Include theme styles for core and each component used in your app.
// Alternatively, you can import and @include the theme mixins for each component
// that you are using.
@include angular-material-theme($candy-app-theme);
```

You only need this single Sass file; you do not need to use Sass to style the rest of your app.  
你只需要这个单一的Sass文件;您不需要使用Sass来设计应用程序的其余部分。

If you are using the Angular CLI, support for compiling Sass to css is built-in; you only have to
add a new entry to the `"styles"` list in `angular-cli.json` pointing to the theme
file (e.g., `unicorn-app-theme.scss`).  
如果您使用Angular CLI，则支持将Sass编译为css，这是内置的;您只需在 `angular-cli.json` 中指向主题文件（例如，`unicorn-app-theme.scss`）的 `“样式”` 列表中添加一个新条目。

If you're not using the Angular CLI, you can use any existing Sass tooling to build the file (such
as gulp-sass or grunt-sass). The simplest approach is to use the `node-sass` CLI; you simply run:  
如果您不使用Angular CLI，则可以使用任何现有的Sass工具来构建文件（如gulp-sass或grunt-sass）。 最简单的方法是使用节点sass CLI;你只需运行：
```
node-sass src/unicorn-app-theme.scss dist/unicorn-app-theme.css
```
and then include the output file in your index.html.  
然后将输出文件包含在index.html中。

The theme file **should not** be imported into other SCSS files. This will cause duplicate styles
to be written into your CSS output. If you want to consume the theme definition object
(e.g., `$candy-app-theme`) in other SCSS files, then the definition of the theme object should be
broken into its own file, separate from the inclusion of the `mat-core` and
`angular-material-theme` mixins.  
主题文件不应该导入到其他SCSS文件中。这会导致重复样式被写入您的CSS输出。如果您想在其他SCSS文件中使用主题定义对象（例如 `$candy-app-theme`）。那么主题对象的定义应该被分解到它自己的文件中，与包含 `mat-core` 和 `angular-material-theme` mixins分开。

The theme file can be concatenated and minified with the rest of the application's css.  
主题文件可以与应用程序的其余部分进行连接和缩小。

Note that if you include the generated theme file in the `styleUrls` of an Angular component, those
styles will be subject to that component's [view encapsulation](https://angular.io/docs/ts/latest/guide/component-styles.html#!#view-encapsulation).  
请注意，如果您将生成的主题文件包含在Angular组件的styleUrls中，则这些样式将受该组件的视图封装支配。

#### Multiple themes
#### 多主题
You can create multiple themes for your application by including the `angular-material-theme` mixin
multiple times, where each inclusion is gated by an additional CSS class.  
您可以通过多次包含 `angular-material-theme` 混合来创建应用程序的多个主题，其中每个包含都由额外的CSS类进行门控。

Remember to only ever include the `@mat-core` mixin only once; it should not be included for each
theme.  
记住只有一次只包含 `@mat-core` 混合;它不应该包含在每个主题中。

##### Example of defining multiple themes:
##### 定义多主题的示例:
```scss
@import '~@angular/material/theming';
// Plus imports for other components in your app.

// Include the common styles for Angular Material. We include this here so that you only
// have to load a single css file for Angular Material in your app.
// **Be sure that you only ever include this mixin once!**
@include mat-core();

// Define the default theme (same as the example above).
$candy-app-primary: mat-palette($mat-indigo);
$candy-app-accent:  mat-palette($mat-pink, A200, A100, A400);
$candy-app-theme:   mat-light-theme($candy-app-primary, $candy-app-accent);

// Include the default theme styles.
@include angular-material-theme($candy-app-theme);


// Define an alternate dark theme.
$dark-primary: mat-palette($mat-blue-grey);
$dark-accent:  mat-palette($mat-amber, A200, A100, A400);
$dark-warn:    mat-palette($mat-deep-orange);
$dark-theme:   mat-dark-theme($dark-primary, $dark-accent, $dark-warn);

// Include the alternative theme styles inside of a block with a CSS class. You can make this
// CSS class whatever you want. In this example, any component inside of an element with
// `.unicorn-dark-theme` will be affected by this alternate dark theme instead of the default theme.
.unicorn-dark-theme {
  @include angular-material-theme($dark-theme);
}
```

In the above example, any component inside of a parent with the `unicorn-dark-theme` class will use
the dark theme, while other components will fall back to the default `$candy-app-theme`.  
在上面的例子中，具有 `unicorn-dark-theme` 类的父类中的任何组件都将使用黑色主题，而其他组件将回退到默认的`$candy-app-theme`。

You can include as many themes as you like in this manner. You can also `@include` the
`angular-material-theme` in separate files and then lazily load them based on an end-user
interaction (how to lazily load the CSS assets will vary based on your application).  
你可以用这种方式包括尽可能多的主题。您还可以在单独的文件中包含 `angular-material-theme`，然后基于最终用户交互延迟加载它们（如何根据您的应用程序延迟加载CSS资产）。

It's important to remember, however, that the `mat-core` mixin should only ever be included _once_.  
但是，重要的是要记住，`mat-core` 混合只能包含一次。

##### Multiple themes and overlay-based components
##### 多个主题和基于覆盖的组件

Since certain components (e.g. menu, select, dialog, etc.) are inside of a global overlay container,
an additional step is required for those components to be affected by the theme's css class selector
(`.unicorn-dark-theme` in the example above).  
由于某些组件（例如菜单，选择，对话框等）位于全局覆盖容器的内部，因此需要额外的步骤才能使这些组件受到主题的css类选择器的影响（上例中的 `.unicorn-dark-theme` ）。

To do this, you can add the appropriate class to the global overlay container. For the example above,
this would look like:  
为此，您可以将相应的类添加到全局覆盖容器。对于上面的例子，这看起来像：
```ts
import {OverlayContainer} from '@angular/cdk/overlay';

@NgModule({
  // ...
})
export class UnicornCandyAppModule {
  constructor(overlayContainer: OverlayContainer) {
    overlayContainer.getContainerElement().classList.add('unicorn-dark-theme');
  }
}
```

#### Theming only certain components  
##### 仅限某些组件
The `angular-material-theme` mixin will output styles for [all components in the library](https://github.com/angular/material2/blob/master/src/lib/core/theming/_all-theme.scss).
If you are only using a subset of the components (or if you want to change the theme for specific
components), you can include component-specific theme mixins. You also will need to include
the `mat-core-theme` mixin as well, which contains theme-specific styles for common behaviors
(such as ripples).  
`angular-material-theme` mixin将为库中的[所有组件](https://github.com/angular/material2/blob/master/src/lib/core/theming/_all-theme.scss)输出样式。如果您仅使用组件的子集（或者如果您想更改特定组件的主题），则可以包含特定于组件的主题混合.  您还需要包含 `mat-core-theme` 混合，其中包含常见行为（如涟漪）的主题特定样式。

 ```scss
@import '~@angular/material/theming';
// Plus imports for other components in your app.

// Include the common styles for Angular Material. We include this here so that you only
// have to load a single css file for Angular Material in your app.
// **Be sure that you only ever include this mixin once!**
@include mat-core();

// Define the theme.
$candy-app-primary: mat-palette($mat-indigo);
$candy-app-accent:  mat-palette($mat-pink, A200, A100, A400);
$candy-app-theme:   mat-light-theme($candy-app-primary, $candy-app-accent);

// Include the theme styles for only specified components.
@include mat-core-theme($candy-app-theme);
@include mat-button-theme($candy-app-theme);
@include mat-checkbox-theme($candy-app-theme);
```

### Theming your own components
### 主体化您自己的组件
For more details about theming your own components,
see [theming-your-components.md](./theming-your-components.md).  
有关自己组件的更多细节，请参阅[theming-your-components.md](./theming-your-components.md)。

### Future work
### 未来的工作
* Once CSS variables (custom properties) are available in all the browsers we support,
  we will explore how to take advantage of them to make theming even simpler.  
  一旦CSS变量（自定义属性）在我们支持的所有浏览器中都可用，我们将探索如何利用它们使其变得更简单。
* More prebuilt themes will be added as development continues.  
 随着发展的继续，将增加更多预建主题。
