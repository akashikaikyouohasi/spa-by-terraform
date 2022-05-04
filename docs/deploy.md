# このドキュメントの概要
デプロイなどに必要な手順を記載する。

## Lambda
### DynamoDB操作
現状はpythonのファイルのままデプロイ可能。

### Auth0authorizer
Auth0のAuthorizerはビルドが必要
```
$ cd lambda/Auth0_authorizer/jwt-rsa-aws-custom-authorizer-master
$ npm install
$ npm run bundle
```

## フロント
Reactを使用しているため、ビルドが必要。
```
$ cd react
$ npm install
$ npm run build
```
**origin_contents**ディレクトリにビルドしたものが出力されます。

## GitHubの使い方
### gitコマンドでの一連の流れ

ブランチ作成
```
git checkout -b feature/xxxx
```

コミット
```
git add .
git commit -m '変更内容'
```

ブランチの変更内容をリモートリポジトリの指定したブランチに登録
```
git push -u origin feature/xxxx
```

プルリクをGitHub上でする

mainに移動
```
git checkout main
```

プルリク・マージ後、masterの更新を取得
```
git fetch
git pull
```

一番上に戻る

### タグ付け

タグ作成
```
git tag "タグ名" -m "メッセージ"
```

タグの共有
```
git push origin --tags
```

### その他のコマンド
状態確認
```
git status
git branch -a
```

不要なローカルブランチ削除
```
git branch -d xxxx
```

既に削除されたリモートブランチをローカルに適用
```
git fetch --prune
```

