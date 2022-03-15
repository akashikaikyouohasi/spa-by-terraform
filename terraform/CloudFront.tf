# -----------------------------------
# CloudFrontからS3へのアクセスを許可
# -----------------------------------
resource "aws_cloudfront_origin_access_identity" "oai" {
	# S3にアクセスできるように、CloudFront用のオリジンアクセスアイデンティティ(OAI)を作成
	comment = "origin access identity for s3: ${var.bucket_name.single_page_application}"
}

data "aws_iam_policy_document" "cloudfront_to_s3_policy" {
	# CloudFrontからS3にアクセスできるようにIAMポリシーを作成
	
	statement {
		# S3のファイルの取得Actionを許可
		actions = ["s3:GetObject", "s3:ListBucket"]
	
		# 許可対象のリソース
		resources = [
			aws_s3_bucket.single-page-application.arn,
			"${aws_s3_bucket.single-page-application.arn}/*",
		]
	
		# AWSリソースのアクションに対して、リクエストできるユーザーorアプリケーションを指定。今回はOAIを通してCloduFrontを指定
		principals {
			type		= "AWS"
			identifiers 	= [ aws_cloudfront_origin_access_identity.oai.iam_arn ]
		}
	}
}

resource "aws_s3_bucket_policy" "cf-to-s3" {
	# SPA用バケットのS3に作成したポリシーを適用

    # 対象バケット
	bucket = aws_s3_bucket.single-page-application.id
    # 付与ポリシー
	policy = data.aws_iam_policy_document.cloudfront_to_s3_policy.json
}

# -----------------------------------
# キャッシュポリシー(CachingOptimized)の取得
# -----------------------------------
data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
	name = "Managed-CachingOptimized"
}


# -----------------------------------
# CloudFrontの作成
# ※Shield Standardは自動で有効になっている
# -----------------------------------
resource  "aws_cloudfront_distribution" "spa-www" {
	# 必須パラメータ。Distributionの有効化
	enabled	= true

	# オリジン
	origin {
		# ドメイン名 S3のプロパティ名のバケットウェブサイトエンドポイント
		domain_name	= aws_s3_bucket.single-page-application.bucket_regional_domain_name
		# オリジンID(オリジンの名前)
		origin_id	= aws_s3_bucket.single-page-application.id
		# S3バケットアクセス設定
		s3_origin_config {
			# オリジンアクセスアイデンティティ(OAI)
			origin_access_identity	= aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
		}

	}

	# デフォルトのキャッシュビヘイビア。キャッシュサーバの詳細設定
	default_cache_behavior {
		# オブジェクトを自動的に圧縮
		compress		= true
		# ビューワープロトコルポリシー
		viewer_protocol_policy	= "allow-all"
		# 許可されたHTTPメソッド。
		allowed_methods		= ["GET", "HEAD"]
		cached_methods		= ["GET", "HEAD"]
		# キャッシュのオリジンとなる対象
		target_origin_id 	= aws_s3_bucket.single-page-application.id
		
		# キャッシュポリシーの設定
		cache_policy_id		= data.aws_cloudfront_cache_policy.managed_caching_optimized.id
	}

    # 関数の関連付け
    #なし

	# AWS WAF web ACL 
	web_acl_id = aws_wafv2_web_acl.webacl_for_CloudFront.arn

	# 代替ドメイン名(CNAME) - オプション
 	# build-automation.de　をドメインとして取得している
	aliases 	= [var.cloudfront_domain_name]

	# カスタムSSL証明書 - オプション
	viewer_certificate {
		# バージニア北部リージョンで作成したAWS Certificate Manager(ACM)の証明書のarnを指定
		acm_certificate_arn = var.cloudfront_domain_name_acm_arn
		# CloudFrontのデフォルトの証明書を利用するかどうか
		cloudfront_default_certificate	= false
		# acm_certificate_arnを設定する場合は必須
		ssl_support_method		= "sni-only"
		# セキュリティポリシー TLSv1.2_2021がAWS推奨とのこと
		minimum_protocol_version        = "TLSv1.2_2021"
	}

	# アクセス制限について
	restrictions {
		# 地域制限機能
		geo_restriction {
			# 制限タイプ。後述のlocationsの判断タイプ
			restriction_type	= "whitelist"
			# 地域
			locations		= ["US", "JP"]
		}
	}

	# デフォルトルートオブジェクト - オプション
	default_root_object	= "index.html"

	# ログ出力
	logging_config {
		# cookie ログ記録
		include_cookies	= false
		# ログ出力先のバケット
		bucket		= aws_s3_bucket.cloudfront-accesslog.bucket_domain_name
		# ログプrフィックス - オプション（未設定）
		#prefix		= 
	}

	# IPv6
	is_ipv6_enabled	= true

    # CloudFront削除時、破棄されず無効にする。Terraform固有の機能。削除するのに時間がかかるから？
    #retain_on_delete = true
}