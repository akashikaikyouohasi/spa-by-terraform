# AWSのコストについて
## このドキュメントの目的
SPAを作成する際に使用するAWSのサービスを一覧化した上で、それぞれのサービスでどの程度の料金がかかるかを見積もる。

## 使用するサービス一覧
現時点で使用予定のサービスを記載する。

### AWS
- S3: オリジンコンテンツ配置、アクセスログ出力
- CloudFront: CDN
- Route53: カスタムドメイン
- ACM: 証明書発行
- API Gateway: REST API、Auth0認証リクエスト
- Lambda: コンピュートリソース
- WAF: WAF
- Shield: DDos対策
- DynamoDB: データベース
- CloudWatch: 監視

### GitHub
- GitHub Actions: CI/CD

### Others
- Auth0: 認証と認可



## 各サービスの料金発生ポイントと見積り

WAFのルール数と、DynamoDBに要注意。
他はそんなにかからない想定。

### 前提条件
一月当たりの想定
| 項目 | 仮の値 | 備考 |
| - | - | - |
| UU（ユニークユーザー） | 1000人 |  |
| PV数 | 300,000PV(100/日) | HTTPSリクエスト数に当たるかも？ |
| オリジンコンテンツ | 100MB | 多いかも |
| エッジからのデータ転送アウト | 900GB(3MB/回) |  |
| APIのリクエスト数 | 600,000回 | かなり適当 |
| APIのデータ転送量 | 1.8GB(3KB/回) |  |


### S3
[参考: Amazon S3 の料金](https://aws.amazon.com/jp/s3/pricing/)

S3標準で考えます。

課金ポイント
- ストレージ容量
- リクエスト数(GET)
- データ転送涼

データ転送は、エッジまでなので無料かと

#### ストレージ容量
0.025USD/GB(最初の50TB/月まで)

100MBだと30円程度

#### リクエスト数(GET)
0.00037USD/1000リクエスト

30万PVで10円ぐらい


### CloudFront
[参考: Amazon CloudFront の料金](https://aws.amazon.com/jp/cloudfront/pricing/)

無料枠あり
- 1TBのデータ転送(アウト)
- 1,000万件のHTTTPまたはHTTPSリクエスト
- 2百万件のCloudFront Function呼び出し

オリジンがAWSサービスなら、オリジンからエッジロケーションへのデータ転送量は無料。

この前提だと料金が発生しなさそう

### Route53
[参考: Amazon Route 53 料金表](https://aws.amazon.com/jp/route53/pricing/)

課金ポイント
- ホストゾーン
- DNSクエリ応答数

#### ホストゾーン
1ゾーンで0.5USD/月

#### クエリ応答数
0.40USD 100 万クエリごと – 最初の 10 億クエリ / 月

0.4USDにも届かないかな

### ACM
[参考: AWS Certificate Manager の料金](https://aws.amazon.com/jp/certificate-manager/pricing/)

パブリックSSL/TLS証明書は無料。

### API Gateway
[参考: Amazon API Gateway の料金](https://aws.amazon.com/jp/api-gateway/pricing/)

課金ポイント
- 受信したAPIコール
- 転送データ涼

#### 受信したAPIコール
100万リクエストで4.25USD（3億3,300万リクエスト/月まで）

#### データ転送量
0.11USD/GB(10TB/月まで)

2GBで0.22USD

### Lambda
[参考: AWS Lambda 料金](https://aws.amazon.com/jp/lambda/pricing/)

課金ポイント
- リクエスト数
- コードの実行時間

無料利用枠あり
- 1 か月あたり 100 万件の無料リクエスト
- 1 か月あたり 40 万 GB-s のコンピューティングタイム

たぶん無料利用枠内で納まるのでは？

### WAF
[参考: AWS WAF の料金](https://aws.amazon.com/jp/waf/pricing/)

課金ポイント
- Web ACL：5.00USD、月あたり
- ルール：1.00USD、月あたり
- リクエスト

適用するルール数に依存するが、どれを入れるかが未定。

10USDぐらいかかるのかな

### Shield
[参考: AWS Shield 料金](https://aws.amazon.com/jp/shield/pricing/)
Standardは追加料金なし！！！

### DynamoDB
[参考: オンデマンドキャパシティーの料金](https://aws.amazon.com/jp/dynamodb/pricing/on-demand/)

見たけどよくわからなかった！

ハンズオンなどでDynamoDBの詳細な使い方を学ぼう！


### CloudWatch
[参考: Amazon CloudWatch の料金](https://aws.amazon.com/jp/cloudwatch/pricing/)

無料利用枠あり
- 基本モニタリングのメトリクス (5 分間隔)
- 詳細モニタリングのメトリクス 10 個 (1 分間隔)
- 毎月最大 50 個のメトリクスに対応するダッシュボード 3 個
- 10 件のアラームメトリクス (高分解能アラームには適用されません)
- カスタムイベントを除くすべてのイベントが対象

正直CloudWatchの細かな設定がまだわかってないので、見積もりが立たない。

おそらく無料利用枠でだいたい納まる。納まるといいなぁ

### GitHub Actions
[参考: GitHub Actionsの支払いについて](https://docs.github.com/ja/billing/managing-billing-for-github-actions/about-billing-for-github-actions)

課金ポイント
- ストレージ
- 実行時間

Freeでは一月当たり、500MBと2000分(33.33時間)が利用可能。

このリポジトリはPublicなので、利用料金は一切かかりません！！！


### Auth0
[参考: 企業や開発者向けの柔軟な価格設定](https://auth0.com/jp/pricing)

最大7,000名のアクティブユーザーと無制限ログインをは無料

たぶん無料枠は超えれない

