---
summary: "如果您正在致力于国际化，CLI可以通过以下步骤为您提供帮助"
tags:
    - wangyijie
categories:
    - Development
    - Opetration
---
# Internationalization (i18n)
# 国际化 (i18n)

If you are working on internationalization, the CLI can help you with the following steps:  
如果您正在致力于国际化，CLI可以通过以下步骤为您提供帮助：
- extraction  
  提取
- serve  
  服务
- build  
  构建

The first thing that you have to do is to setup your application to use i18n.
To do that you can follow [the cookbook on angular.io](https://angular.io/docs/ts/latest/cookbook/i18n.html).  
你必须做的第一件事是设置你的应用程序使用国际化。要做到这一点，你查看 [关于angular.io的食谱 ](https://angular.io/docs/ts/latest/cookbook/i18n.html) 。

### Extraction
### 提取
When your app is ready, you can extract the strings to translate from your templates with the
`ng xi18n` command.  
当您的应用程序准备就绪时，您可以使用 `ng xi18n` 命令从您的模板中提取字符串以进行翻译。

By default it will create a file named `messages.xlf` in your `src` folder.
You can use [parameters from the xi18n command](./xi18n) to change the format,
the name, the location and the source locale of the extracted file.  
默认情况下，它会在 `src` 文件夹中创建一个名为 `messages.xlf` 的文件. 您可以使用 [xi18n命令中的参数](./xi18n)更改提取文件的格式，名称，位置和源语言环境。

For example to create a file in the `src/locale` folder you would use:  
例如，要在src / locale文件夹中创建一个文件，您可以使用：
```sh
ng xi18n --output-path src/locale
```

### Building and serving
### 建设和服务
Now that you have generated a messages bundle source file, you can translate it.
Let's say that your file containing the french translations is named `messages.fr.xlf`
and is located in the `src/locale` folder.  
现在您已经生成了一个消息包源文件，您可以将其翻译。假设您的包含法文翻译的文件名为messages.fr.xlf并位于src / locale文件夹中。

If you want to use it when you serve your application you can use the 4 following options:  
如果您想在为应用程序提供服务时使用它，则可以使用以下4个选项：
- `i18nFile` Localization file to use for i18n.
- `i18nFile` 用于i18n的本地化文件.
- `i18nFormat` Format of the localization file specified with --i18n-file.
- `i18nFormat` 使用--i18n-file指定的本地化文件的格式.
- `i18nLocale` Locale to use for i18n.
- `i18nLocale` 用于i18n的语言环境.
- `i18nMissingTranslation` Defines the strategy to use for missing i18n translations. 
- `i18nMissingTranslation` 定义用于缺少i18n翻译的策略。. 


In our case we can load the french translations with the following configuration:  
在我们的案例中，我们可以使用以下配置加载法语翻译:  
```json
"architect": {
  "build": {
    "builder": "@angular-devkit/build-angular:browser",
    "options": { ... },
    "configurations": {
      "fr": {
        "aot": true,
        "outputPath": "dist/my-project-fr/",
        "i18nFile": "src/locale/messages.fr.xlf",
        "i18nFormat": "xlf",
        "i18nLocale": "fr",
        "i18nMissingTranslation": "error",
      }
// ...
"serve": {
  "builder": "@angular-devkit/build-angular:dev-server",
  "options": {
    "browserTarget": "your-project-name:build"
  },
  "configurations": {
    "production": {
      "browserTarget": "your-project-name:build:production"
    },
    "fr": {
      "browserTarget": "your-project-name:build:fr"
    }
  }
},
```

To build the application using the French i18n options, use `ng build --configuration=fr`.
To serve, use `ng serve --configuration=fr`.  
使用法语i18n选项构建应用程序,使用 `ng build --configuration=fr`. 运行服务，请使用ng `serve --configuration=fr`.

Our application is exactly the same but the `LOCALE_ID` has been provided with "fr",
`TRANSLATIONS_FORMAT` with "xlf" and `TRANSLATIONS` with the content of `messages.fr.xlf`.
All the strings flagged for i18n have been replaced with their french translations.  
我们的应用程序是完全相同的，但是 `LOCALE_ID` 有提供“fr”, 带有“xlf”的`TRANSLATIONS_FORMAT` 和带有` messages.fr.xlf` 内容的 `TRANSLATIONS`。

Note: this only works for AOT, if you want to use i18n in JIT you will have to update  
your bootstrap file yourself.  
注意：这只适用于AOT，如果你想在JIT中使用i18n，你必须自己更新引导文件。

### Using multiple languages
### 使用多种语言

When you build your application for a specific locale, it is probably a good idea to change
the output path with the `outputPath` options in order to save the files to a different location.  
在为特定语言环境构建应用程序时，最好使用 `outputPath` 选项更改输出路径，以便将文件保存到其他位置。

If you end up serving this specific version from a subdirectory, you can also change
the base url used by your application with the `baseHref` option.  
如果您最终从子目录中提供此特定版本，您还可以使用 `baseHref` 选项更改应用程序使用的基础URL。

For example if the french version of your application is served from https://myapp.com/fr/
then you would build the french version like this:  
例如，如果您的应用程序的法语版本是从https://myapp.com/fr/提供的，那么您可以像这样构建法语版本：

```json
"configurations": {
  "fr": {
    "aot": true,
    "outputPath": "dist/my-project-fr/",
    "baseHref": "/fr/",
    "i18nFile": "src/locale/messages.fr.xlf",
    "i18nFormat": "xlf",
    "i18nLocale": "fr",
    "i18nMissingTranslation": "error",
  }
```

If you need more details about how to create scripts to generate the app in multiple
languages and how to setup Apache 2 to serve them from different subdirectories,
you can read [this great tutorial](https://medium.com/@feloy/deploying-an-i18n-angular-app-with-angular-cli-fc788f17e358#.1xq4iy6fp)
by Philippe Martin.  
如果您需要更多关于如何创建脚本以多种语言生成应用程序的详细信息，以及如何设置Apache 2以便从不同的子目录提供它们，你可以阅读菲利普马丁的这个[伟大的教程](https://medium.com/@feloy/deploying-an-i18n-angular-app-with-angular-cli-fc788f17e358#.1xq4iy6fp)。
