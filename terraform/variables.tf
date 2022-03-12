

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
