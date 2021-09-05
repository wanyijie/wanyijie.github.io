---
summary: "部署Angular应用的一个简单方法是使用GitHub Pages. 如果自己做一个单页网站可以不需要自购web服务器"
tags:
    - Kubernetes
categories:
    - Development
    - Opetration
---
# Deploy to GitHub Pages
# 部署到 Github

A simple way to deploy your Angular app is to use
[GitHub Pages](https://help.github.com/articles/what-is-github-pages/).  
部署Angular应用的一个简单方法是使用[GitHub Pages](https://help.github.com/articles/what-is-github-pages/). 如果自己做一个单页网站可以不需要自购web服务器。

<!--more-->

The first step is to [create a GitHub account](https://github.com/join), and then
[create a repository](https://help.github.com/articles/create-a-repo/) for your project.
Make a note of the user name and project name in GitHub.  
第一步是[创建一个GitHub帐户](https://github.com/join)，然后为您的项目[创建一个存储库](https://help.github.com/articles/create-a-repo/) 。记下GitHub中的用户名和项目名称。

Then all you need to do is run `ng build --prod --output-path docs --base-href PROJECT_NAME`, where
`PROJECT_NAME` is the name of your project in GitHub.
Make a copy of `docs/index.html` and name it `docs/404.html`.  
然后你需要做的就是运行 `ng build --prod --output-path docs --base-href PROJECT_NAME`, `PROJECT_NAME` 是GitHub中项目的名称。复制 `docs/index.html` 并将其命名为 `docs/404.html`。

Commit your changes and push. On the GitHub project page, configure it to
[publish from the docs folder](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch).  
提交你的改变并推送到github。在GitHub项目页面上，将其配置为[从docs文件夹发布](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch)

And that's all you need to do! Now you can see your page at
`https://USER_NAME.github.io/PROJECT_NAME/`.  
这就是你需要做的一切！现在你可以看到你的网页了`https://USER_NAME.github.io/PROJECT_NAME/`.  

You can also use [angular-cli-ghpages](https://github.com/angular-buch/angular-cli-ghpages), a full
featured package that does this all this for you and has extra functionality.
