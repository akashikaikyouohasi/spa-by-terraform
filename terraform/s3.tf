# -----------------------------------
# S3の作成
# -----------------------------------
### SPA用のバケット###
resource "aws_s3_bucket" "single-page-application" {
  # S3のバケット名
  bucket = var.bucket_name.single_page_application
  # アクセス管理
  acl = "private"
  # バージョニングの有効化
  versioning {
    enabled = true
  }

  # このバケットのアクセスログ出力先
  logging {
    target_bucket = aws_s3_bucket.accesslog-single-page-application.id
    target_prefix = "log/"
  }

  # タグ
  # 名称と使用環境を明記
  tags = {
    Name = "testbucket"
  }
}

resource "aws_s3_bucket_public_access_block" "single-page-application" {
  # 対象のバケット
  bucket = aws_s3_bucket.single-page-application.id
  # パブリックのアクセスをブロック
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


### SPAバケットのアクセスログ用のバケット###
resource "aws_s3_bucket" "accesslog-single-page-application" {
  # S3のバケット名
  bucket = var.bucket_name.accesslog_single_page_application
  # アクセス管理
  # log-delivery-writeは、S3ログ配信グループにオブジェクト書き込み・バケットACL読み込みを許可する
  acl = "log-delivery-write"

  # タグ
  # 名称と使用環境を明記
  tags = {
    Name = "testbucket"
  }
}
resource "aws_s3_bucket_public_access_block" "accesslog-single-page-application" {
  # 対象のバケット
  bucket = aws_s3_bucket.accesslog-single-page-application.id
  # パブリックのアクセスをブロック
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


### CloudFrontのアクセスログ用のバケット###
# AWSアカウントの正規IDを取得する
data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "cloudfront-accesslog" {
  # S3のバケット名
  bucket = var.bucket_name.accesslog_cloudfront
  # アクセス管理 ACL
  # バケット所有者にFULL_CONTROLのアクセス権限を付与
  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
  # awslogsdeliveryアカウントにFULL_COTROLアクセス権限を付与
  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }


  # タグ
  # 名称と使用環境を明記
  tags = {
    Name = "testbucket"
  }
}
resource "aws_s3_bucket_public_access_block" "cloudfrontaccesslog" {
  # 対象のバケット
  bucket = aws_s3_bucket.cloudfront-accesslog.id
  # パブリックのアクセスをブロック
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
