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
npm install react@17.0.2 react-dom@17.0.2 styled-components@5.3.0
npm install -D @types/react@17.0.17 @types/react-dom@17.0.9 @types/styled-components@5.1.12
npm install @auth0/auth0-react
```

ts-loaderは、webpackでモジュールをバンドルするときに、TypeScriptで記述されたファイルを事前にJavascriptに変換するために必要なパッケージ

serveは、localhostでサーバを立ててHTMLファイルにアクセスできるように用意しているもの。特に今回のアプリケーションでは必須ではないが、動作確認しやすくするためにインストール

**--save-dev**はローカルインストールのオプション。

ローカルインストールなので、必要なら**node-modules**ディレクトリ内の実行ファイルを実行すればよい。

*package.json*では**devDependencies**として依存関係が定義されるので、開発時のみ使用するパッケージの意味になる。ちなみに、**package.json**に追記されます。
つまり、Buildしたコードからは使わないものを指定するということです。

補足としては、**-g**がグローバルインストールオプション。

### webpackの設定ファイル用意
***webpack.config.js***作成する

"scripts"セクションを調整。

- dev: ファイルの変更を監視して、自動でビルドを実行。ホットリロード
- serve: 開発中のアプリの動作確認

### tsconfig.jsonの作成
***tsconfig.json***作成する。

流れ：TypeScript⇨JavaScript⇨依存解決　なので、TSをJSに変換する際にもソースマップを出力しておく。
ソースマップはwebpackで読み込む。

> SourceMapとは、コンパイル前とコンパイル後の対応関係を記したファイル。だそうです。
Json形式で記述されています。

ついでに、package.jsonのビルドコマンドを調整


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

## 実行コマンド一覧
### build
`npm run build`で、*../origin_contents*にBuildしてくれる。

### dev
`npm run dev`でファイルを監視して、自動でビルドを実行させる。

基本的には起動しっぱなして、次のserveと同時に実行して画面にすぐ反映されるようにする。

### serve
`npm run serve`で*localhost:3000*サーバが起動するので、アクセスして確認可能。


