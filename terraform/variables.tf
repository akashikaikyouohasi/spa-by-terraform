
# local変数
locals {
  /* 
  S3の各バケットに設定するユニークな名前
  ※各自で要調整  
  */
  bucket_name = {
    # SPA配置用バケット
    single_page_application = "dev-react-tutorial-20220129"
    # SPAのアクセスログ用バケット
    accesslog_single_page_application = "dev-accesslog-react-tutorial-20220129"
    # CloudFrontのアクセスログ用バケット
    accesslog_cloudfront = "dev-cf-accesslog-react-tutorial-20220129"
  }

  # rootドメイン名
  domain_name  = "build-automation.de"
  # CloudFront用のドメイン名
  cloudfront_domain_name = "udemy.build-automation.de"
  # CloudFront用のドメインの証明書ARN（アマゾンリソースネーム）
  cloudfront_domain_name_acm_arn = "arn:aws:acm:us-east-1:206863353204:certificate/77304815-b814-42f9-875f-282bebc09514"
  
}

