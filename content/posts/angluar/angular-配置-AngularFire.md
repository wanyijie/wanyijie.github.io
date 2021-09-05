---
summary: "Firebase是一个移动和Web应用程序平台，其中包含旨在帮助开发人员构建高品质应用程序的工具和基础结构。 AngularFire2是在您的应用中使用Firebase的官方Angular库。"
tags:
    - wangyijie
categories:
    - Development
    - Opetration
---
# Include AngularFire
# 包含 AngularFire

[Firebase](https://firebase.google.com/) is a mobile and web application platform with tools and infrastructure designed
to help developers build high-quality apps. [AngularFire2](https://github.com/angular/angularfire2) is the official
Angular library to use Firebase in your apps.  
Firebase是一个移动和Web应用程序平台，其中包含旨在帮助开发人员构建高品质应用程序的工具和基础结构。 AngularFire2是在您的应用中使用Firebase的官方Angular库。

#### Create new project
#### 创建新项目

Create a new project and navigate into the project.
创建一个新项目并导航到项目中。

```bash
$ ng new my-app
$ cd my-app
```

#### Install dependencies
#### 安装依赖

In the new project you need to install the required dependencies.  
在新项目中，您需要安装所需的依赖关系。

```bash
$ npm install --save angularfire2 firebase
```

#### Get Firebase configuration details
#### 获得 Firebase 配置纤细

In order to connect AngularFire to Firebase you need to get the configuration details.  
为了将AngularFire连接到Firebase，您需要获取配置详细信息

Firebase offers an easy way to get this, by showing a JavaScript object that you can copy and paste.  
通过显示可以复制和粘贴的JavaScript对象，Firebase提供了一种简单的方法来获取此信息。

- Log in to the [Firebase](https://firebase.google.com) console.  
  登录到Firebase控制台。
- Create New Project or open an existing one.  
  创建新项目或打开一个存在的
- Click `Add Firebase to your web app`.  
  点击 `Add Firebase to your web app`.
- From the modal window that pops up you copy the `config` object.  
  从弹出的模式窗口中复制配置对象

```javascript
  var config = {
    apiKey: "your-api-key",
    authDomain: "your-auth-domain",
    databaseURL: "your-database-url",
    storageBucket: "your-storage-bucket",
    messagingSenderId: "your-message-sender-id"
  };
```

#### Configure the Environment
#### 配置环境

These configuration details need to be stored in our app, one way to do this using the `environment`. This allows you to
use different credentials in development and production.  
这些配置细节需要存储在我们的应用程序中，一种使用 `environment` 来做到这一点的方法，这使您可以在开发和生产中使用不同的凭证。 

Open `src/environments/environment.ts` and add a key `firebase` to the exported constant:  
打开 `src/environments/environment.ts` 并向导出的常量添加一个键的 `firebase`:

```typescript
export const environment = {
  production: false,
  firebase: {
    apiKey: 'your-api-key',
    authDomain: 'your-auth-domain',
    databaseURL: 'your-database-url',
    storageBucket: 'your-storage-bucket',
  }
};
```

To define the keys for production you need to update
 `src/environments/environment.prod.ts`.  
 要定义生产密钥，您需要更新 `src/environments/environment.prod.ts`. 

#### Import and load FirebaseModule
#### 导入和加载 FirebaseModule

The final step is to import `AngularFireModule` and initialize it using the parameters from the `environment`.  
最后一步是导入 `AngularFireModule` 并使用 `environment` 中的参数对其进行初始化.

Open `src/app/app.module.ts` and add the following lines on the top of the file, with the other imports:

```typescript
import { AngularFireModule } from 'angularfire2';
import { environment } from '../environments/environment';
```

To initialize AngularFire add the following line to the `imports` array inside the `NgModule`:  
要初始化 `AngularFire`，将以下行添加到 `NgModule` 内的 `imports` 数组中：

```typescript
@NgModule({
  // declarations
  imports: [
    // BrowserModule, etc
    AngularFireModule.initializeApp(environment.firebase),
  ]
  // providers
  // bootstrap
})
```

#### Congratulations, you can now use Firebase in your Angular app!  
#### 恭喜，您现在可以在您的Angular应用中使用Firebase！
