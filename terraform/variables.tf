
# local変数
locals {
  # S3の各バケットに設定するユニークな名前
  bucket_name = {
    # SPA配置用バケット
    single_page_application = "dev-react-tutorial-20220129"
    # SPAのアクセスログ用バケット
    accesslog_single_page_application = "dev-accesslog-react-tutorial-20220129"
    # CloudFrontのアクセスログ用バケット
    accesslog_cloudfront = "dev-cf-accesslog-react-tutorial-20220129"
  }
}

