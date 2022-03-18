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
- react: SPAのフロントエンドを作るReactのソース。*origin_contents*ディレクトリにビルドしたものを出力します。

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

$ cd ../react
$ npm run build
```

やりたいのであれば、`test_tool`ディレクトリを参照して、テストを試してみてください。

### ローカルで更新したLabmda/origin_contentsをデプロイする方法
0から構築すると、lambdaの関数とSPAの*index.html*はアップロードしてくれますが、更新して**terraform apply**してもコードは更新してくれません。

そのため、手動でデプロイしてください。GitHub Actionsでは自動でデプロイするようにします。

- Lambda
```
# aws lambda update-function-code --function-name {Lambdaの関数名} --zip-file fileb://lambda/for_dynamodb/{zipファイル名}
(実行例)# aws lambda update-function-code --function-name DynamodbforSPA --zip-file fileb://lambda/for_dynamodb/function.zip
```

- SPAのS3
```
# cd origin_contents
# aws s3 sync . s3://dev-react-tutorial-20220129/
```

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


