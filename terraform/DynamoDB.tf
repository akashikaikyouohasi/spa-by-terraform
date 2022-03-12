#################
### DynamoDBテーブルの作成
#################
resource "aws_dynamodb_table" "single_page_application_dynamodb" {
  # 名前
  name = var.dynamodb.resource_name

  # プライマリーキー ※テスト用なので要調整
  hash_key = var.dynamodb.dynamodb_primary_key
  attribute {
    name = var.dynamodb.dynamodb_primary_key
    # (S)tring, (N)umber or (B)inary data
    type = "S"
  }

  # キャパシティモード⇒プロビジョニング済みキャパシティモードで無料枠を利用する
  billing_mode = "PROVISIONED"
  # 読み込みキャパシティ
  read_capacity = 1
  # 書き込みキャパシティ
  write_capacity = 1
  # 補完時の暗号化
  server_side_encryption {
    enabled = true
  }
}