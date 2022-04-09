#################
### Preflight Requestに対応するOPTIONSを追加
#################

# メソッドリクエスト
resource "aws_api_gateway_method" "api_gw_method_preflight_request" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド：Preflight Request用にOPTIONSメソッド
  http_method = "OPTIONS"
  
  # 認可方式
  authorization = "NONE"
}

# 統合リクエスト
resource "aws_api_gateway_integration" "api_gw_integration_preflight_request" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド
  http_method = aws_api_gateway_method.api_gw_method_preflight_request.http_method

  # 統合入力のタイプ
  type = "MOCK"

  # リクエスト本文のパススルー
  request_templates = {
      "application/json" = <<EOF
{
    "statusCode": 200
}
EOF
  }

}

# メソッドレスポンス
resource "aws_api_gateway_method_response" "api_gw_response_preflight_request" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド
  http_method = aws_api_gateway_method.api_gw_method_preflight_request.http_method
  # ステータスコード
  status_code = "200"
  
  # レスポンスモデル
  response_models = {
    "application/json" = "Empty"
  }

  # 200のレスポンスヘッダー
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.api_gw_method]
}

# 統合レスポンス
resource "aws_api_gateway_integration_response" "api_gw_integration_response_preflight_request" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド
  http_method = aws_api_gateway_method.api_gw_method_preflight_request.http_method

  # レスポンスのステータス
  status_code = aws_api_gateway_method_response.api_gw_response_preflight_request.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = "Empty"
  }

  # 依存関係
  depends_on = [aws_api_gateway_method_response.api_gw_response_preflight_request]
}
