# このアプリのテスト方法
## 概要
1. Terraformを使ってSPA環境を作ります
1. dynampdbにテストデータを入れます
1. テストして確認します

## 準備
### Dynamodbテスト用データ作成
add_dynamodb.sh を実行するとデータが作成できます。

このデータが取得できることを確認します！

#### テスト用データ
```
{
  id: 1001,
  test_id: TerraformBySPA
}
```

## lambda自体のテスト方法
### 準備
AWSのLambdaの画面に移動して、作成したLambda関数を選択。

テストタブに移動し、以下の内容を設定してテスト
```
{
  "queryStringParameters": {
    "id": "1001"
  }
}
```

### 実行結果
実行結果として、以下が返ってきます。
●詳細
```
{
  "headers": {
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Origin": "https://testwww.build-automation.de",
    "Access-Control-Allow-Methods": "GET"
  },
  "statusCode": 200,
  "body": "{\"id\": \"1001\", \"test_id\": \"TerraformBySPA\"}"
}
```

## API Gatewayのメソッドの単体テスト方法
### 準備
APIのリソースタブにアクセス。

ANYメソッドを選択し、*クライアント*と書いてある箇所の上の*テスト*をクリック。

テスト実行用の画面に移動するので、メソッドを**GET**に、クエリ文字列の{dynamodb}に**id=1001**を設定して[テスト]ボタンを押す。

### 実行結果
実行結果として、以下が返ってきます
- レスポンス本文
```
{
  "id": "1001",
  "test_id": "TerraformBySPA"
}
```
- レスポンスヘッダー
```
{"Access-Control-Allow-Headers":["Content-Type"],"Access-Control-Allow-Methods":["GET"],"Access-Control-Allow-Origin":["https://testwww.build-automation.de"],"X-Amzn-Trace-Id":["Root=1-622cc96a-64b13718356142b0f74a1cdd;Sampled=0"]}
```

## API Gatewayのステージのテスト方法
ステージではAPI Gatewayの呼び出しURLが作成されます。

ステージタブに移動し、[deploy-test]をクリック。

[URLの呼び出し]に呼び出しURLが表示されているので、以下の形式でブラウザアクセスor curlコマンド実行。

```
{URLの呼び出しに表示されているURL}/dynamodb?id=1001
例：https://09po27pmfl.execute-api.ap-northeast-1.amazonaws.com/deploy-test/dynamodb?id=1001
```

### 実行結果
以下が表示される（返ってくる）。
```
{"id": "1001", "test_id": "TerraformBySPA"}
```

## API Gatewayでカスタムドメインのアクセス確認
以下のようにアクセスすると、同じテストデータが返ってくる

例：https://testapi.build-automation.de/dynamodb?id=1001

### 実行結果
以下が表示される（返ってくる）。
```
{"id": "1001", "test_id": "TerraformBySPA"}
```

