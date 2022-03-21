#################
### カスタムオーソライザーlambda関数作成
#################
resource "aws_lambda_function" "authorizer_lambda" {
  # 関数名
  function_name = var.lambda_authorizer.function_name
  # ランタイム
  runtime = "nodejs12.x"
  # アーキテクチャ
  architectures = ["x86_64"]
  # 実行ロール
  role = aws_iam_role.iam_for_lambda_authorizer.arn

  # ハンドラー：イベントを処理する関数コード内のメソッド
  handler = "index.handler"
  # ソースコード
  filename = "../lambda/Auth0_authorizer/jwt-rsa-aws-custom-authorizer-master/custom-authorizer.zip"

  # タイムアウト設定
  timeout = "30"
  # 環境変数
  environment {
    variables = {
      AUDIENCE = var.lambda_authorizer.audience
      JWKS_URI = var.lambda_authorizer.jwks_uri
      TOKEN_ISSUER = var.lambda_authorizer.token_issuer
    }
  }
}



### labmda関数 実行用ロール
### ポリシー作成
# AWSのアカウントID取得
data "aws_iam_policy_document" "allow_lambda" {
  # lambdaの操作許可
  statement {
    # 許可or拒否
    effect = "Allow"
    # アクション
    actions = [
      "lambda:InvokeFunction",
    ]
    # 対象リソース
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "policy_lambda_authorizer" {
  # ポリシー名
  name = "SPA-for-lambda-authorizer-policy"
  # アタッチするポリシー
  policy = data.aws_iam_policy_document.allow_lambda.json
}

### ロール作成
# 信頼ポリシー作成
data "aws_iam_policy_document" "lambda_apigw_assume_role" {
  statement {
    # sts(Security Token Serivce)で、ロールを引き受ける操作を許可
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "apigateway.amazonaws.com"
      ]
    }
  }
}
# ロール作成
resource "aws_iam_role" "iam_for_lambda_authorizer" {
  name = "SPA-for-lambda-authorizer"
  assume_role_policy = data.aws_iam_policy_document.lambda_apigw_assume_role.json
}

### ロールにポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "lambda_authorizer" {
  role = aws_iam_role.iam_for_lambda_authorizer.name
  policy_arn = aws_iam_policy.policy_lambda_authorizer.arn
}