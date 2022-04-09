# -----------------------------------
# S3の作成
# -----------------------------------
### SPA用のバケット###
resource "aws_s3_bucket" "single-page-application" {
  # S3のバケット名
  bucket = var.bucket_name.single_page_application

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
resource "aws_s3_bucket_acl" "single-page-application-acl" {
  bucket = aws_s3_bucket.accesslog-single-page-application.id
  # アクセス管理
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "single-page-application-versioning" {
  bucket = aws_s3_bucket.single-page-application.id
  # バージョニングの有効化
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_logging" "single-page-application-logging" {
  bucket = aws_s3_bucket.single-page-application.id
  # バケットのアクセスログ出力先
  target_bucket = aws_s3_bucket.accesslog-single-page-application.id
  target_prefix = "log/"
}

### SPAバケットのアクセスログ用のバケット###
resource "aws_s3_bucket" "accesslog-single-page-application" {
  # S3のバケット名
  bucket = var.bucket_name.accesslog_single_page_application
  # アクセス管理
  # log-delivery-writeは、S3ログ配信グループにオブジェクト書き込み・バケットACL読み込みを許可する
  #acl = "log-delivery-write"

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
resource "aws_s3_bucket_acl" "accesslog-single-page-application-acl" {
  bucket = aws_s3_bucket.accesslog-single-page-application.id
  acl    = "log-delivery-write" # 参考：https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/acl-overview.html
}

### CloudFrontのアクセスログ用のバケット###
# AWSアカウントの正規IDを取得する
data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "cloudfront-accesslog" {
  # S3のバケット名
  bucket = var.bucket_name.accesslog_cloudfront

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
data "aws_canonical_user_id" "current" {}
resource "aws_s3_bucket_acl" "cloudfront-accesslog-acl" {
  # 対象のバケット
  bucket = aws_s3_bucket.cloudfront-accesslog.id
  # アクセス管理 ACL
  # バケット所有者にFULL_CONTROLのアクセス権限を付与
  access_control_policy {
    grant {
      grantee {
        id          = data.aws_canonical_user_id.current_user.id
        type        = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    # awslogsdeliveryアカウントにFULL_COTROLアクセス権限を付与
    grant {
      grantee {
        id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type        = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}