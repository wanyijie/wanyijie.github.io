---
summary: "使用 webpacks 开发服务器中的[代理支持], 我们可以劫持某些 url 并将它们发送到后端服务器。我们这样做是通过传递一个文件给 --proxy-config 选项。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Proxy To Backend 
# 代理后端 

Using the [proxying support](https://webpack.js.org/configuration/dev-server/#devserver-proxy) in webpack's dev server we can highjack certain URLs and send them to a backend server.
We do this by passing a file to `--proxy-config`  
使用 webpacks 开发服务器中的[代理支持](https://webpack.js.org/configuration/dev-server/#devserver-proxy), 我们可以劫持某些 url 并将它们发送到后端服务器。我们这样做是通过传递一个文件给 `--proxy-config` 选项。 

Say we have a server running on `http://localhost:3000/api` and we want all calls to `http://localhost:4200/api` to go to that server.
假设我们有一个服务器运行在 `http://localhost:3000/api` 我们希望所有调用 `http://localhost:4200/api` 到该服务器上.

We create a file next to our project's `package.json` called `proxy.conf.json` with the content
我们在项目包旁边创建一个文件 `package.json` 命名为 `proxy.conf.json` 和如下的内容。


```json
{
  "/api": {
    "target": "http://localhost:3000",
    "secure": false
  }
}
```

You can read more about what options are available [here](https://webpack.js.org/configuration/dev-server/#devserver-proxy).  
您可以阅读更多关于[此处](https://webpack.js.org/configuration/dev-server/#devserver-proxy).可用选项的信息。


We can then add the `proxyConfig` option to the serve target:  
然后, 我们可以将 `proxyConfig` 选项添加到服务目标:

```json
"architect": {
  "serve": {
    "builder": "@angular-devkit/build-angular:dev-server",
    "options": {
      "browserTarget": "your-application-name:build",
      "proxyConfig": "src/proxy.conf.json"
    },
```

Now in order to run our dev server with our proxy config we can call `ng serve`.  

现在, 为了运行我们的开发服务器与我们的代理配置, 我们可以调用
 `ng serve`.

**After each edit to the proxy.conf.json file remember to relaunch the `ng serve` process to make your changes effective.**  
**每次编辑到 proxy.conf.json 文件后, 记住重新启动 ng serve 进程, 使您的更改生效**

### Rewriting the URL path
### 重写url路径

One option that comes up a lot is rewriting the URL path for the proxy. This is supported by the `pathRewrite` option.  
一个很重要的选项是重写代理的 URL 路径。这由 `pathRewrite` 选项支持

Say we have a server running on `http://localhost:3000` and we want all calls to `http://localhost:4200/api` to go to that server.  
假设我们有一个服务器运行在 http://localhost:3000, 我们希望所有调用 http://localhost:4200/api 到该服务器上。

in our `proxy.conf.json` file, we add the following content
在我们的 `proxy.conf.json` 文件, 我们添加如下内容

```json
{
  "/api": {
    "target": "http://localhost:3000",
    "secure": false,
    "pathRewrite": {
      "^/api": ""
    }
  }
}
```

If you need to access a backend that is not on localhost, you will need to add the `changeOrigin` option as follows:  
如果您需要访问不在本地主机上的后端，则需要添加 `changeOrigin` 选项，如下所示：

```json
{
  "/api": {
    "target": "http://npmjs.org",
    "secure": false,
    "pathRewrite": {
      "^/api": ""
    },
    "changeOrigin": true
  }
}
```

To help debug whether or not your proxy is working properly, you can also add the `logLevel` option as follows:  
为了帮助调试代理是否正常工作，您还可以添加 `logLevel` 选项，如下所示：

```json
{
  "/api": {
    "target": "http://localhost:3000",
    "secure": false,
    "pathRewrite": {
      "^/api": ""
    },
    "logLevel": "debug"
  }
}
```

Possible options for `logLevel` include `debug`, `info`, `warn`, `error`, and `silent` (default is `info`)  
`logLevel` 的可能选项包括 `debug`, `info`, `warn`, `error`, 和 `silent` (默认是`info`)


### Multiple entries
### 多入口

If you need to proxy multiple entries to the same target define the configuration in `proxy.conf.js` instead of `proxy.conf.json` e.g.  
如果需要将多个条目代理到同一目标，请在 `proxy.conf.js` 中定义配置，而不是`proxy.conf.json` 中的配置，例如

```js
const PROXY_CONFIG = [
    {
        context: [
            "/my",
            "/many",
            "/endpoints",
            "/i",
            "/need",
            "/to",
            "/proxy"
        ],
        target: "http://localhost:3000",
        secure: false
    }
]

module.exports = PROXY_CONFIG;
```

Make sure to point to the right file (`.js` instead of `.json`):  
确保指向正确的文件 (`.js` 而不是 `.json`): 

```json
"architect": {
  "serve": {
    "builder": "@angular-devkit/build-angular:dev-server",
    "options": {
      "browserTarget": "your-application-name:build",
      "proxyConfig": "src/proxy.conf.js"
    },
```

### Bypass the Proxy
### 绕过代理

If you need to optionally bypass the proxy, or dynamically change the request before it's sent,  define the configuration in proxy.conf.js e.g.  
如果需要绕过代理，或者在请求发送前动态更改请求，请在proxy.conf.js中定义配置，例如。

```js
const PROXY_CONFIG = {
    "/api/proxy": {
        "target": "http://localhost:3000",
        "secure": false,
        "bypass": function (req, res, proxyOptions) {
            if (req.headers.accept.indexOf("html") !== -1) {
                console.log("Skipping proxy for browser request.");
                return "/index.html";
            }
            req.headers["X-Custom-Header"] = "yes";
        }
    }
}

module.exports = PROXY_CONFIG;
```

### Using corporate proxy
### 使用企业代理

If you work behind a corporate proxy, the regular configuration will not work if you try to proxy
calls to any URL outside your local network.  
如果您在公司代理的后面工作，如果您尝试将呼叫代理到本地网络之外的任何URL，则常规配置将不起作用

In this case, you can configure the backend proxy to redirect calls through your corporate
proxy using an agent:  
在这种情况下，您可以配置后端代理以使用代理通过公司代理重定向呼叫

```bash
npm install --save-dev https-proxy-agent
```

Then instead of using a `proxy.conf.json` file, we create a file called `proxy.conf.js` with
the following content:  
然后，我们不使用 `proxy.conf.json` 文件，而是使用以下内容创建一个名为 `proxy.conf.js` 的文件：

```js
var HttpsProxyAgent = require('https-proxy-agent');
var proxyConfig = [{
  context: '/api',
  target: 'http://your-remote-server.com:3000',
  secure: false
}];

function setupForCorporateProxy(proxyConfig) {
  var proxyServer = process.env.http_proxy || process.env.HTTP_PROXY;
  if (proxyServer) {
    var agent = new HttpsProxyAgent(proxyServer);
    console.log('Using corporate proxy server: ' + proxyServer);
    proxyConfig.forEach(function(entry) {
      entry.agent = agent;
    });
  }
  return proxyConfig;
}

module.exports = setupForCorporateProxy(proxyConfig);
```

This way if you have a `http_proxy` or `HTTP_PROXY` environment variable defined, an agent will automatically be added to pass calls through your corporate proxy when running `npm start`.  
这样，如果您定义了 `http_proxy` 或 `HTTP_PROXY` 环境变量，则在运行 `npm start` 时，会自动添加代理以通过公司代理传递调用。
