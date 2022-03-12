#################
### Route53 レコード作成
#################
data "aws_route53_zone" "my_domain" {
  name = var.domain_name
}

### CloudFront用
resource "aws_route53_record" "cloudfront_alias" {
  # ゾーンID
  zone_id = data.aws_route53_zone.my_domain.id

  # レコード名
  name = var.cloudfront_domain_name
  # レコードタイプ
  type = "A"

  # トラフィックのルーティング先をエイリアス
  alias {
    name = aws_cloudfront_distribution.spa-www.domain_name
    zone_id = aws_cloudfront_distribution.spa-www.hosted_zone_id
    # ターゲットのヘルスを評価
    evaluate_target_health = true
  }
}