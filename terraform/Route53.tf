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

### API Gateway用
resource "aws_route53_record" "api_gateway_alias" {
  # ゾーンID
  zone_id = data.aws_route53_zone.my_domain.id

  # レコード名
  name = aws_api_gateway_domain_name.api_domain.domain_name
  # レコードタイプ
  type = "A"
  
  # トラフィックのルーティング先をエイリアス
  alias {
    name = aws_api_gateway_domain_name.api_domain.cloudfront_domain_name 
    zone_id = aws_api_gateway_domain_name.api_domain.cloudfront_zone_id 
    # ターゲットのヘルスを評価
    evaluate_target_health = true
  }
}