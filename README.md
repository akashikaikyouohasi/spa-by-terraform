# SPAをAWSに構築するレポジトリ
## 構成図
![](images/SPA.drawio.svg)

## ディレクトリの説明
- terraform: Terraformのリソース定義ファイル群
- images: 画像。主にAWS構成のdraw.ioの図

### draw.ioの図について
SVGファイルなので、Draw.ioで読み込んで編集が可能です

## 利用方法 

### 環境変数の設定
### GitHub
GitHubのRepository secretsにOIDC認証で利用できるIAMロールのARNを設定すること
　例　"AWS_ROLE_ARN": "arn:aws:iam::{アカウントID}:role/{ロール名}"

### ローカルでの実行方法
```
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
```

### GitHub Actionsでの利用準備
Terraformの状態管理をS3で行うため、Terraform用のS3バケットを作成しておくこと

設定内容
- バブリックからのアクセスはブロック
- バージョニングの有効化
- 暗号化を有効
- ACLはプライベート

### GitHub Actionsの設定方法
ブログ参照：[GitHub ActionsをOIDCでAWS認証してTerraformを実行する](https://anikitech.com/github-actions-terraform-by-oidc/)

セキュリティを鑑み、OIDCで認証しています。

### GitHub Actionsの実行タイミング

#### 確認
Pull Requestを作成したタイミングで`terraform plan`したいなぁ（予定）

#### 実行
Pull RequestをMergeしたタイミングで`terraform apply`してます。

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
