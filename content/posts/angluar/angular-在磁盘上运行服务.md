---
summary: "CLI支持通过运行 `ng serve` 来为用户运行实时浏览器重新加载体验。这将在文件保存时编译应用程序，并用新编译的应用程序重新载入浏览器。"
tags:
    - wangyijie
categories:
    - Development
    - Opetration
---
# Serve from Disk
# 在磁盘上运行服务

The CLI supports running a live browser reload experience to users by running `ng serve`. This will compile the application upon file saves and reload the browser with the newly compiled application. This is done by hosting the application in memory and serving it via [webpack-dev-server](https://webpack.js.org/guides/development/#webpack-dev-server).  
CLI支持通过运行 `ng serve` 来为用户运行实时浏览器重新加载体验。这将在文件保存时编译应用程序，并用新编译的应用程序重新载入浏览器。这是通过将应用程序托管在内存中并通过[webpack-dev-server](https://webpack.js.org/guides/development/#webpack-dev-server).来完成的。

If you wish to get a similar experience with the application output to disk please use the steps below. This practice will allow you to ensure that serving the contents of your `dist` dir will be closer to how your application will behave when it is deployed.  
如果您希望获得与应用程序输出到磁盘相似的体验，请使用以下步骤。这种做法将允许您确保提供远程目录的内容将更接近您的应用程序在部署时的行为方式。

## Environment Setup
## 环境设置
### Install a web server
### 安装一个web服务器
You will not be using webpack-dev-server, so you will need to install a web server for the browser to request the application. There are many to choose from but a good one to try is [lite-server](https://github.com/johnpapa/lite-server) as it will auto-reload your browser when new files are output.  
您将不会使用webpack-dev-server，因此您需要安装Web服务器以供浏览器请求应用程序。有很多可供选择的，但最好尝试的是[lite-server](https://github.com/johnpapa/lite-server)，因为它会在输出新文件时自动重新加载浏览器

## Usage
## 使用
You will need two terminals to get the live-reload experience. The first will run the build in a watch mode to compile the application to the `dist` folder. The second will run the web server against the `dist` folder. The combination of these two processes will mimic the same behavior of ng serve.  
您将需要两个终端才能获得实时加载体验。第一个将以监视模式运行构建以将应用程序编译到 `dist` 文件夹。第二个将针对 `dist` 文件夹运行Web服务器。这两个过程的结合将模拟ng服务的相同行为。

### 1st terminal - Start the build
### 第一个终端，开始构建
```bash
ng build --watch
```

### 2nd terminal - Start the web server
### 第二个终端。开始web服务器
```bash
lite-server --baseDir="dist"
```
When using `lite-server` the default browser will open to the appropriate URL.  
使用 `lite-server` 时，默认浏览器将打开相应的URL。
