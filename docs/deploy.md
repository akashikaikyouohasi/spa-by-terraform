# このドキュメントの概要
デプロイなどに必要な手順を記載する。

## Lambda
現状はpythonのファイルのままデプロイ可能。

## フロント
現状はHTMLファイルだけなので、そのままデプロイ可能。

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

