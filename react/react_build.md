# Reactで実行したコマンド
## 初期化
### package.jsonの作成
```
$ npm init -y
```

### パッケージのインストール
typesctiptとwebpack

```
npm install --save-dev webpack@5.50.0 webpack-cli@4.7.2 typescript@4.3.5 ts-loader@9.2.5 serve@12.0.0
```

ts-loaderは、webpackでモジュールをバンドルするときに、TypeScriptで記述されたファイルを事前にJavascriptに変換するために必要なパッケージ

serveは、localhostでサーバを立ててHTMLファイルにアクセスできるように用意しているもの。特に今回のアプリケーションでは必須ではないが、動作確認しやすくするためにインストール

**--save-dev**はローカルインストールのオプション。
**node-modules**ディレクトリ内の実行ファイルを実行すればいい。
**devDependencies**になるので、開発時のみ使用するパッケージの意味になる。ちな、**package.json**に追記されます。
アプリコードからは使わないものを指定する。

ちなみに、**-g**がグローバルインストールオプション。

### webpackの設定ファイル用意
***webpack.config.js***作成する


### tsconfig.jsonの作成
作成する。

流れ：TypeScript⇨JavaScript⇨依存解決　なので、TSをJSに変換する際にもソースマップを出力しておく。
ソースマップはwebpackで読み込む。

> SourceMapとは、コンパイル前とコンパイル後の対応関係を記したファイル。だそうです。
Json形式で記述されています。

ついでに、package.jsonのビルドコマンドを調整

### ここまでで実行
```
npm run build
```
distに

`npm run dev`でホットリロードしてくれる

### アーキテクチャ
今回のアプリはMVC(Model-View-Controller)形式

### npmについて
`npm install`でインストールすると、JavaScriptのライブラリでもTypeScriptから利用可能。なぜなら、型定義ファイルが含まれているから。ただし、installしただけでは型定義がないものもある！！

型定義ファイル：.d.ts拡張子

ないとTypeScriptから実行できない。

その場合は、***DefinitelyTyped***というリポジトリから型定義ファイルをインストールできる！
```
npm install @types/{パッケージ名}
```

インストールすると、**node_modules/@types**ディレクトリ配下に、ディレクトリが作成されて、**.d.ts**ファイルが作成される。
これが型定義ファイルで、これが参照される


### 追加
```
npm install dragula@3.7.3
npm install --save-dev @types/dragula@3.7.1
```

