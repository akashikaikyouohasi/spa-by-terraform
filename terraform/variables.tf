

variable "bucket_name" {
  /* 
  # S3の各バケットに設定するユニークな名前
  ※各自で要調整  
  */
  default = {
    # SPA配置用バケット
    "single_page_application" = "dev-react-tutorial-20220129"
    # SPAのアクセスログ用バケット
    "accesslog_single_page_application" = "dev-accesslog-react-tutorial-20220129"
    # CloudFrontのアクセスログ用バケット
    "accesslog_cloudfront" = "dev-cf-accesslog-react-tutorial-20220129"
  }
}

# rootドメイン名
variable "domain_name" {
  default = "build-automation.de"
}

# CloudFront用のドメイン名
variable "cloudfront_domain_name" {
  default = "testwww.build-automation.de"
}
# CloudFront用のドメインの証明書ARN（アマゾンリソースネーム）
 variable "cloudfront_domain_name_acm_arn" {
  default = "arn:aws:acm:us-east-1:206863353204:certificate/6e17c80e-4b8a-4321-a5b3-99ae38d9f8eb"
}


### DyanamoDBの設定 ###
variable "dynamodb" {
  default = {
    # リソース名
    "resource_name" = "DynamodbForSPA"
    # プライマリーキー：パーティションキー
    "dynamodb_primary_key" = "id"
  }
}

### 変数内で繰り返し使用する文字列 ###
locals {
  api_domain_name = "testapi.build-automation.de"
}

### API Gatewayの設定 ###
variable "api_gateway" {
  default = {
    # API Gateway用のドメイン名
    "api_domain_name" = "testapi.build-automation.de"
    # API Gateway用のドメインの証明書のARN（アマゾンリソースネーム）
    "api_domain_name_acm_arn" = "arn:aws:acm:us-east-1:206863353204:certificate/728f6af2-7c61-43b3-aefe-a50a8fae8f4f"
  }
}

### Lambda authorizerの設定

variable "lambda_authorizer" {
  default = {
    # Lambdaの関数名
    "function_name" = "SPAforLambdaAuthorizer"
    # 
    audience = "https://testapi.build-automation.de"
    # 
    jwks_uri = "https://dev-mv5giriq.jp.auth0.com/.well-known/jwks.json"
    # 
    token_issuer = "https://dev-mv5giriq.jp.auth0.com/"
  }
}