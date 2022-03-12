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

