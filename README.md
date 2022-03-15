# SPAをAWSに構築するレポジトリ
## 構成図
![](images/SPA.drawio.svg)

## ディレクトリの説明
- terraform: Terraformのリソース定義ファイル群
- images: 画像。主にAWS構成のdraw.ioの図
- origin_contents: SPAのオリジンコンテンツ
- docs: 本アプリのドキュメント
    - 料金
    - 仕様など（現時点では存在せず）
    - 使い方、デプロイ方法
- test_tool: AWSリソースなどのテスト方法ドキュメントと、テスト用のツール

### draw.ioの図について
SVGファイルなので、Draw.ioで読み込んで編集が可能です


## 機能
- オリジンコンテンツ用のS3バケットにHTMLだけのindex.htmlを配置して、CloudFront経由でカスタムドメインで配布
- API GatewayでREST API受け、Lambdaを呼び出してDynamoDBのデータを表示

### 今後の追加機能
- 配布したWEBサイトからAPI GatewayにREST APIを呼び出してDynamoDBのデータを表示
- API GatewayをAuth0での認証し、Custom Authorizer
- セキュリティとして、WAFとShieldの設定
- 運用監視として、CloudWatchにメトリクス設定。主に課金に関わる箇所を見える化する
    - Lambdaのログ出力

#### 要改善点
- Lambdaの呼び出すDynamoDBを環境変数化


## Cloneしてローカルで実行する方法 
`variables.tf`を各環境毎に調整し、[Terrformの状態変数の管理S3バケット設定](terraform/README.md)を行った後、以下のコマンドを実施。

```
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
```

やりたいのであれば、`test_tool`ディレクトリを参照して、テストを試してみてください。


## GitHub Actionsから実行する方法
CI/CDパイプラインを構築したいため、基本的にはGitHub Actionsからデプロイを実行することを想定しています。

### GitHub Actionsの設定方法
セキュリティを鑑み、OIDCで認証しています。

GitHubのRepository secretsにOIDC認証で利用できるIAMロールのARNを設定すること
　例　"AWS_ROLE_ARN": "arn:aws:iam::{アカウントID}:role/{ロール名}"

ブログ参照：[GitHub ActionsをOIDCでAWS認証してTerraformを実行する](https://anikitech.com/github-actions-terraform-by-oidc/)


### GitHub Actionsでの利用準備
GitHub Actionsではローカルのファイルが消えてしまうので、Terraformの状態管理用のファイルはS3に配置する必要があります。

Terraformの状態管理をS3で行うため、Terraform用のS3バケットを作成しておくこと

設定内容
- バブリックからのアクセスはブロック
- バージョニングの有効化
- 暗号化を有効
- ACLはプライベート


### GitHub Actionsの実行タイミング
#### 確認
Pull Requestを作成したタイミングで`terraform plan`したいなぁ（予定）

#### 実行
Pull RequestをMergeしたタイミングで`terraform apply`してます。


