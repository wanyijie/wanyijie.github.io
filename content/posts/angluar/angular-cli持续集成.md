---
summary: "保持项目缺陷肃清的最好方法之一是通过测试套件，但忘记随时运行测试很容易。这就是持续集成（CI）服务器的用武之地。您可以设置您的项目存储库，以便您的测试可以在每次提交和提交请求时运行。"
tags:
    - wangyijie
    - angular
categories:
    - Development
    - Opetration
---
# Continuous Integration
# 持续集成

One of the best ways to keep your project bug free is through a test suite, but it's easy to forget
to run tests all the time.  
保持项目缺陷肃清的最好方法之一是通过测试套件，但忘记随时运行测试很容易。

That's where Continuous Integration (CI) servers come in.
You can set up your project repository so that your tests run on every commit and pull request.  
这就是持续集成（CI）服务器的用武之地。您可以设置您的项目存储库，以便您的测试可以在每次提交和提交请求时运行。

There are paid CI services like [Circle CI](https://circleci.com/) and
[Travis CI](https://travis-ci.com/), and you can also host your own for free using
[Jenkins](https://jenkins.io/) and others.  
有付费的CI服务，如[Circle CI](https://circleci.com/)和[Travis CI](https://travis-ci.com/)，您也可以使用[Jenkins](https://jenkins.io/)和其他人免费托管项目的服务。


Even though Circle CI and Travis CI are paid services, they are provided free for open source
projects.
You can create a public project on GitHub and add these services without paying.  
尽管Circle CI和Travis CI是有偿服务，但它们是免费提供给开源项目的。您可以在GitHub上创建一个公共项目并添加这些服务而无需付费。  
We're going to see how to update your test configuration to run in CI environments, and how to
set up Circle CI and Travis CI.  
我们将看到如何更新测试配置以在CI环境中运行，以及如何设置Circle CI和Travis CI。

## Update test configuration
## 更新测试配置

Even though `ng test` and `ng e2e` already run on your environment, they need to be adjusted to
run in CI environments.  
即使 `ng test` 和 `ng e2e` 已经在您的环境中运行，它们也需要进行调整才能在CI环境中运行。

When using Chrome in CI environments it has to be started without sandboxing.
We can achieve that by editing our test configs.  
在CI环境中使用Chrome时，必须在不使用沙箱的情况下启动。我们可以通过编辑我们的测试配置来实现这一点。

In `karma.conf.js`, add a custom launcher called `ChromeNoSandbox` below `browsers`:  
在 `karma.conf.js` 中, 添加一个自定义启动 `ChromeNoSandbox` 在 `browsers`:

```
browsers: ['Chrome'],
customLaunchers: {
  ChromeNoSandbox: {
    base: 'Chrome',
    flags: ['--no-sandbox']
  }
},
```

Create a new file in the root of your project called `protractor-ci.conf.js`, that extends
the original `protractor.conf.js`:  
在项目根目录创建一个文件命名为 `protractor-ci.conf.js`, 扩展内 `protractor.conf.js`:

```
const config = require('./protractor.conf').config;

config.capabilities = {
  browserName: 'chrome',
  chromeOptions: {
    args: ['--no-sandbox']
  }
};

exports.config = config;
```

Now you can run the following commands to use the `--no-sandbox` flag:  
现在可以运行以下命令来使用 `--no-sandbox` 标志:

```
ng test --single-run --no-progress --browser=ChromeNoSandbox
ng e2e --no-progress --config=protractor-ci.conf.js
```

For CI environments it's also a good idea to disable progress reporting (via `--no-progress`)
to avoid spamming the server log with progress messages.  
对于CI环境，禁用进度报告 (via `--no-progress`) 也是一个好主意，以避免使用进度消息来垃圾邮件服务器日志。


## Using Circle CI
## 使用 Circle CI

Create a folder called `.circleci` at the project root, and inside of it create a file called
`config.yml`:  
在项目根目录下创建一个名为 `.circleci` 的文件夹，并在其中创建一个名为 `config.yml` 的文件：

```yaml
version: 2
jobs:
  build:
    working_directory: ~/my-project
    docker:
      - image: circleci/node:8-browsers
    steps:
      - checkout
      - restore_cache:
          key: my-project-{{ .Branch }}-{{ checksum "package.json" }}
      - run: npm install
      - save_cache:
          key: my-project-{{ .Branch }}-{{ checksum "package.json" }}
          paths:
            - "node_modules"
      - run: xvfb-run -a npm run test -- --single-run --no-progress --browser=ChromeNoSandbox
      - run: xvfb-run -a npm run e2e -- --no-progress --config=protractor-ci.conf.js

```

We're doing a few things here:  
我们在这里做了几件事:
  -
  - `node_modules` is cached.   
     缓存 `node_modules`. 
  - [npm run](https://docs.npmjs.com/cli/run-script) is used to run `ng` because `@angular/cli` is
  not installed globally. The double dash (`--`) is needed to pass arguments into the npm script.  
  [npm run](https://docs.npmjs.com/cli/run-script)用于运行 `ng`，因为 `@angular/cli` 没有全局安装。 需要双短划线（ `--` ）将参数传递给npm脚本。
  - `xvfb-run` is used to run `npm run` to run a command using a virtual screen, which is needed by
  Chrome.  
  `xvfb-run` 用于运行 `npm run` 以使用Chrome需要的虚拟屏幕运行命令。

Commit your changes and push them to your repository.  
提交更改并将其推送到您的存储库。

Next you'll need to [sign up for Circle CI](https://circleci.com/docs/2.0/first-steps/) and
[add your project](https://circleci.com/add-projects).
Your project should start building.  
接下来，您需要注册Circle CI并添加您的项目。你的项目应该开始建设。

Be sure to check out the [Circle CI docs](https://circleci.com/docs/2.0/) if you want to know more.  
如果您想了解更多信息，请务必查看[Circle CI docs](https://circleci.com/docs/2.0/)文档。


## Using Travis CI
## 使用 Travis CI

Create a file called `.travis.yml` at the project root:
在项目根目录下创建一个名为.travis.yml的文件：


```yaml
dist: trusty
sudo: false

language: node_js
node_js:
  - "8"
  
addons:
  apt:
    sources:
      - google-chrome
    packages:
      - google-chrome-stable

cache:
  directories:
     - ./node_modules

install:
  - npm install

script:
  # Use Chromium instead of Chrome.
  - export CHROME_BIN=chromium-browser
  - xvfb-run -a npm run test -- --single-run --no-progress --browser=ChromeNoSandbox
  - xvfb-run -a npm run e2e -- --no-progress --config=protractor-ci.conf.js

```

Although the syntax is different, we're mostly doing the same steps as were done in the
Circle CI config.
The only difference is that Travis doesn't come with Chrome, so we use Chromium instead.  
虽然语法不同，但我们主要执行与Circle CI配置中完成的相同步骤。唯一的区别是Travis没有配备Chrome，所以我们使用Chromium。

Commit your changes and push them to your repository.  
提交更改并将其推送到您的存储库。

Next you'll need to [sign up for Travis CI](https://travis-ci.org/auth) and
[add your project](https://travis-ci.org/profile).
You'll need to push a new commit to trigger a build.  
接下来，您需要注册 [Travis CI](https://travis-ci.org/auth) 并 [添加您的项目](https://travis-ci.org/profile) 。您需要推送新的提交来触发构建。

Be sure to check out the [Travis CI docs](https://docs.travis-ci.com/) if you want to know more.  
如果您想了解更多信息，请务必查看[Travis CI文档](https://docs.travis-ci.com/)。
