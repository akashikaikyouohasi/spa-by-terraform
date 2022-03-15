#################
### lambda関数作成
#################
resource "aws_lambda_function" "single_page_application_lambda" {
  # 関数名
  function_name = "DynamodbforSPA"
  # ランタイム
  runtime = "python3.6"
  # 実行ロール
  role = aws_iam_role.iam_for_lambda.arn
  
  # ハンドラー：イベントを処理する関数コード内のメソッド
  handler = "function.lambda_handler"
  # ソースコード
  filename = data.archive_file.lambda_zip.output_path
}

### ソースコード
data "archive_file" "lambda_zip" {
  # 圧縮
  type = "zip"
  # 入力・出力
  source_dir = "../lambda/for_dynamodb"
  output_path = "../lambda/for_dynamodb/function.zip"
}

### labmda関数 実行用ロール
### ポリシー作成
# AWSのアカウントID取得
data "aws_caller_identity" "self" { }
data "aws_iam_policy_document" "allow_dynamodb" {
  # DynamoDBの操作許可
  statement {
    # 許可or拒否
    effect = "Allow"
    # アクション
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
    # 対象リソース
    resources = [
      aws_dynamodb_table.single_page_application_dynamodb.arn
    ]
  }

  # log書き込み
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.self.account_id}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
       "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.self.account_id}:log-group:/aws/lambda/SinglePageApplication:*"
    ]
  }
}
resource "aws_iam_policy" "policy_lambda" {
  # ポリシー名
  name = "SPA-allow-dynamodb-policy"
  # アタッチするポリシー
  policy = data.aws_iam_policy_document.allow_dynamodb.json
}

### ロール作成
# 信頼ポリシー作成
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    # sts(Security Token Serivce)で、ロールを引き受ける操作を許可
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
# ロール作成
resource "aws_iam_role" "iam_for_lambda" {
  name = "SPA-allow-dynamodb-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

### ロールにポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy_lambda.arn
}