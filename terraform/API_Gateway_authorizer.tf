#################
### API Gateway カスタムオーソライザー設定
#################
resource "aws_api_gateway_authorizer" "auth0_authorizer" {
  # 名前
  name = "SPA-for-jwt-rsa-custom-authorizer"
  # タイプ　lambda or Cognito
  type = "TOKEN"
  # Lambda関数
  authorizer_uri = aws_lambda_function.authorizer_lambda.invoke_arn
  # Lambda呼び出しロール
  authorizer_credentials = aws_iam_role.iam_for_lambda_authorizer.arn
  # Lambdaイベントペイロード
  
  # ト－クンのソース 「method.request.header.」が前に必要な模様
  identity_source = "method.request.header.Authorization"
  # トークンの検証
  identity_validation_expression = "^Bearer [-0-9a-zA-z\\.]*$"
  # TTL
  authorizer_result_ttl_in_seconds = "3600"


  # REST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
}