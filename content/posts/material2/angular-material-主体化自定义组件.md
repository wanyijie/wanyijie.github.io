# Theming your custom components
# 主体化自定义的组件
In order to style your own components with Angular Material's tooling, the component's styles must be defined with Sass.  
为了使用Angular Material的工具设计自己的组件，组件的样式必须用Sass定义。

### Using `@mixin` to automatically apply a theme  
### 使用@mixin自动应用主题

#### Why using `@mixin`
The advantage of using a `@mixin` function is that when you change your theme, every file that uses it will be automatically updated.
Calling the `@mixin` with a different theme argument allows multiple themes within the app or component.

#### How to use `@mixin`
#### 怎样使用`@mixin`
We can better theme our custom components by adding a `@mixin` function to its theme file, and then call this function to apply a theme.

All you need is to create a `@mixin` function in the custom-component-theme.scss  
使用 `@mixin` 函数的优势在于，当您更改主题时，每个使用它的文件都会自动更新。

```scss
// Import all the tools needed to customize the theme and extract parts of it
@import '~@angular/material/theming';

// Define a mixin that accepts a theme and outputs the color styles for the component.
@mixin candy-carousel-theme($theme) {
  // Extract whichever individual palettes you need from the theme.
  $primary: map-get($theme, primary);
  $accent: map-get($theme, accent);

  // Use mat-color to extract individual colors from a palette as necessary.
  .candy-carousel {
    background-color: mat-color($primary);
    border-color: mat-color($accent, A400);
  }
}
```
Now you just have to call the `@mixin` function to apply the theme:  
现在你只需要调用@mixin函数来应用主题：

```scss
// Import a pre-built theme
@import '~@angular/material/prebuilt-themes/deeppurple-amber.css';
// Import your custom input theme file so you can call the custom-input-theme function
@import 'app/candy-carousel/candy-carousel-theme.scss';

// Using the $theme variable from the pre-built theme you can call the theming function
@include candy-carousel-theme($theme);
```

For more details about the theming functions, see the comments in the
[source](https://github.com/angular/material2/blob/master/src/lib/core/theming/_theming.scss).  
有关主题功能的更多详细信息，请参阅源[代码](https://github.com/angular/material2/blob/master/src/lib/core/theming/_theming.scss).中的注释。

#### Best practices using `@mixin`
#### `@mixin` 的最佳使用方式
When using `@mixin`, the theme file should only contain the definitions that are affected by the passed-in theme.  
使用@mixin时，主题文件应只包含受传入主题影响的定义。

All styles that are not affected by the theme should be placed in a `candy-carousel.scss` file.
This file should contain everything that is not affected by the theme like sizes, transitions...  
所有不受主题影响的样式应放置在 `candy-carousel.scss` 文件中。这个文件应该包含所有不受大小，转换等主题影响的内容......

Styles that are affected by the theme should be placed in a separated theming file as
`_candy-carousel-theme.scss` and the file should have a `_` before the name. This file should
contain the `@mixin` function responsible for applying the theme to the component.  
受该主题影响的样式应该放置在一个单独的主题文件中，名称为 `_candy-carousel-theme.scss`，并且该文件的名称前应该有一个_。该文件应该包含负责将主题应用到组件的@mixin函数。


### Using colors from a palette 
### 使用调色板中的颜色
You can consume the theming functions and Material palette variables from
`@angular/material/theming`. You can use the `mat-color` function to extract a specific color
from a palette. For example:  
您可以使用 `@ngular/material/theming` 中的主题功能和材料调色板变量。您可以使用底色功能从调色板中提取特定颜色。例如：

```scss
// Import theming functions
@import '~@angular/material/theming';
// Import your custom theme
@import 'src/unicorn-app-theme.scss';

// Use mat-color to extract individual colors from a palette as necessary.
// The hue can be one of the standard values (500, A400, etc.), one of the three preconfigured
// hues (default, lighter, darker), or any of the aforementioned prefixed with "-contrast".
// For example a hue of "darker-contrast" gives a light color to contrast with a "darker" hue.
// Note that quotes are needed when using a numeric hue with the "-contrast" modifier.
// Available color palettes: https://material.io/design/color/
.candy-carousel {
  background-color: mat-color($candy-app-primary);
  border-color: mat-color($candy-app-accent, A400);
  color: mat-color($candy-app-primary, '100-contrast');
}
```
