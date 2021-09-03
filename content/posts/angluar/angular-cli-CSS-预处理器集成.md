# CSS Preprocessor integration
# CSS 预处理器集成

Angular CLI supports all major CSS preprocessors:  
Angular CLI 支持所有anjor css 预处理器:
- sass/scss ([http://sass-lang.com/](http://sass-lang.com/))
- less ([http://lesscss.org/](http://lesscss.org/))
- stylus ([http://stylus-lang.com/](http://stylus-lang.com/))

To use these preprocessors simply add the file to your component's `styleUrls`:  
要使用这些预处理器只需将文件添加到组件的 styleUrls:


```javascript
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'app works!';
}
```

When generating a new project you can also define which extension you want for
style files:  
在生成新项目时，您还可以定义样式文件所需的扩展名：

```bash
ng new sassy-project --style=sass
```

Or set the default style on an existing project:  
或者在现有项目上设置默认样式

```bash
ng config schematics.@schematics/angular:component.styleext scss
# note: @schematics/angular is the default schematic for the Angular CLI
```

Style strings added to the `@Component.styles` array _must be written in CSS_ because the CLI cannot apply a pre-processor to inline styles.  
添加到@ Component.styles数组的样式字符串必须用CSS编写，因为CLI不能将预处理器应用于内联样式。
