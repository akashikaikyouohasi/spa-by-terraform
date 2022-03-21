#################
### API Gateway作成
#################
resource "aws_api_gateway_rest_api" "my_api_gw" {
  # 名前
  name = "SPAByTerraform"
  # openapiファイルを読み込ませることで、resourceやmethodを何個も書かなくていいらしい
  #body = templatefile("./  yaml", {
  #})
}

### メモ
# リソース（URLパスの設定）⇒メソッドの定義⇒
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method

### リソース
# URLパスの設定
resource "aws_api_gateway_resource" "api_gw_resource" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # 上位パス REST APIを設定
  parent_id = aws_api_gateway_rest_api.my_api_gw.root_resource_id
  # リソースのパス
  path_part = "dynamodb"
}
# メソッドリクエスト
resource "aws_api_gateway_method" "api_gw_method" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド：Lambdaプロキシ統合ではANYにするらしい
  http_method = "ANY"
  
  # 認可方式
  #authorization = "NONE"

  ## カスタムオーソライザー設定
  # 認可方式
  authorization = "CUSTOM"
  # トークンオーソライザー
  authorizer_id = aws_api_gateway_authorizer.auth0_authorizer.id

}

# 統合リクエスト
resource "aws_api_gateway_integration" "api_gw_integration" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド
  http_method = aws_api_gateway_method.api_gw_method.http_method
  
  # API GWがバックエンドと対話するメソッド：LambdaはPOST経由のみ
  integration_http_method = "POST"
  # 統合入力のタイプ：Lambdaプロキシ統合の場合はAWS_PROXY
  type = "AWS_PROXY"
  # 入力のURI　Lambdaのinvoke_arn(呼び出し元的な)
  uri = aws_lambda_function.single_page_application_lambda.invoke_arn
}

# メソッドレスポンス
resource "aws_api_gateway_method_response" "api_gw_response" {
  # API GWのREST APIのID
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # メソッドを割り当てるリソースのID
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  # HTTPのメソッド
  http_method = aws_api_gateway_method.api_gw_method.http_method
  # ステータスコード
  status_code = "200"
  
  # レスポンスモデル
  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [aws_api_gateway_method.api_gw_method]
}

# 統合レスポンス⇒Lambdaプロキシ統合では不使用
#resource "aws_api_gateway_integration_response" "api_gw_integration_response" {
#  # API GWのREST APIのID
#  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
#  # メソッドを割り当てるリソースのID
#  resource_id = aws_api_gateway_resource.api_gw_resource.id
#  # HTTPのメソッド
#  http_method = aws_api_gateway_method.api_gw_method.http_method
#  # レスポンスのステータスコード：今は200のみ
#  status_code = aws_api_gateway_method_response.api_gw_response.status_code
#
#  # 依存関係
#  depends_on = [aws_api_gateway_method_response.api_gw_response]
#}


### lambdaにAPI GWを許可
resource "aws_lambda_permission" "apigw_lambda_permission" {
  # 識別子
  statement_id = "apigw-lambda-permission"
  # 操作内容
  action = "lambda:InvokeFunction"
  # lambdaの関数名
  function_name = aws_lambda_function.single_page_application_lambda.function_name
  # 許可対象
  principal = "apigateway.amazonaws.com"

  # アクセス許可を付与するリソースのARN：
  source_arn = "${aws_api_gateway_rest_api.my_api_gw.execution_arn}/*/*${aws_api_gateway_resource.api_gw_resource.path}"
  #source_arn = "${aws_api_gateway_rest_api.my_api_gw.execution_arn}/*/${aws_api_gateway_method.api_gw_method.http_method}${aws_api_gateway_resource.api_gw_resource.path}"
}


### API Gatewayのステージ及びデプロイを定義
resource "aws_api_gateway_deployment" "deploy" {
  # REST API
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id

  # 再デプロイ時のトリガー
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.my_api_gw.body))
  }
  
  # 
  lifecycle {
    # create_before_destroyは既存のリソースがあった場合は先に削除して作り直す。ベースパスマッピングを使用するので必須
    create_before_destroy = true
  }

  # 依存関係
  depends_on = [aws_api_gateway_integration.api_gw_integration]
}

# デプロイ
resource "aws_api_gateway_stage" "deploy" {
  # APIをデプロイして外部に公開します。
  
  # 
  deployment_id = aws_api_gateway_deployment.deploy.id
  # REST API
  rest_api_id = aws_api_gateway_rest_api.my_api_gw.id
  # ステージ名
  stage_name = "deploy-test" 
}

### カスタムドメイン名
# エッジ最適化用にバージニア北部のACMの証明書が用意されていること
resource "aws_api_gateway_domain_name" "api_domain" {
  # ドメイン名
  domain_name = var.api_gateway.api_domain_name
  # TLSの最小バージョン
  security_policy = "TLS_1_2"
  # エンドポイントタイプ
  endpoint_configuration {
    types = ["EDGE"]
  }
  # ACM証明書
  certificate_arn = var.api_gateway.api_domain_name_acm_arn
}

### APIマッピング
resource "aws_api_gateway_base_path_mapping" "api_domain_mapping" {
  # 割り当てるAPI
  api_id = aws_api_gateway_rest_api.my_api_gw.id
  # 適用するステージ名
  stage_name = aws_api_gateway_stage.deploy.stage_name
  # バス（オプション） 設定しない場合はドメインのルートアクセスでルーティングされる。例：https://api.build-automation.de/api/dynamodb?id=1001でアクセスすることになる
  # まぁAPI Gatewayのリソースパスは有効なのでなくてもいい。https://api.build-automation.de/dynamodb?id=1001
  #base_path = "api"

  # ドメイン名
  domain_name = aws_api_gateway_domain_name.api_domain.domain_name

  # 依存
  depends_on = [aws_api_gateway_deployment.deploy]
}