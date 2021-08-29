# 3rd Party Library Installation
# 第三方库安装

Simply install your library via `npm install lib-name --save` and import it in your code.  
只需通过 `npm install lib-name --save` 安装你的库并将其导入到你的代码中。

If the library does not include typings, you can install them using npm:  
如果库不包括类型，你可以使用npm来安装它们：

```bash
npm install d3 --save
npm install @types/d3 --save-dev
```

Then open `src/tsconfig.app.json` and add it to the `types` array:  
然后打开 `src/tsconfig.app.json` 并将其添加到 `types` 数组中:

```
"types":[
  "d3"
]
```

If the library you added typings for is only to be used on your e2e tests,
instead use `e2e/tsconfig.e2e.json`.
The same goes for unit tests and `src/tsconfig.spec.json`.  
如果您添加类型的库仅用于您的e2e测试，请改为使用 `e2e/tsconfig.e2e.json`。单元测试和`src/tsconfig.spec.json` 也是如此。

If the library doesn't have typings available at `@types/`, you can still use it by
manually adding typings for it:  
如果库在 `@types/` 中没有可用类型，则仍然可以通过手动添加类型来使用它：

1. First, create a `typings.d.ts` file in your `src/` folder. This file will be automatically included as global type definition.  
   首先，在 `src/` 文件夹中创建一个 `typings.d.ts` 文件。该文件将被自动包含为全局类型定义。

2. Then, in `src/typings.d.ts`, add the following code:  
   然后，在 `src/typings.d.ts` 中添加以下代码：

  ```typescript
  declare module 'typeless-package';
  ```

3. Finally, in the component or file that uses the library, add the following code:  
   最后，在使用该库的组件或文件中，添加以下代码：

  ```typescript
  import * as typelessPackage from 'typeless-package';
  typelessPackage.method();
  ```

Done. Note: you might need or find useful to define more typings for the library that you're trying to use.  
完成。注意：您可能需要或发现有用的定义您尝试使用的库的更多类型。
