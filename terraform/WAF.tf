# マネージドルールの参考文書：https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/aws-managed-rule-groups-list.html
resource "aws_wafv2_web_acl" "webacl_for_CloudFront" {
    # Name
    name = "webacl_for_Cloudfront_SPA"
    # Description
    description = "Example of a managed rule."
    # Resource type
    scope = "CLOUDFRONT"
    # Region: scopeがCLOUDFRONTの場合は、AWSプロバイダーでリージョンus-east-1（N. Virginia）も指定する必要あり
    # Multiple Providersで設定
    provider = aws.virginia
    # Associated AWS resources

    # Rules
    rule{
        name     = "AWSManagedRulesCommonRuleSet"
        priority = 1

        override_action {
            count {}
        }

        statement {
            # マネージドルールを定義します。
            managed_rule_group_statement {
                # さまざまな一般的な脅威に対する一般的な保護を提供
                name        = "AWSManagedRulesCommonRuleSet"
                vendor_name = "AWS"

                excluded_rule {
                    # URI クエリ文字列の長さが最大 2,048 バイトであることを確認するルール
                    name = "SizeRestrictions_QUERYSTRING"
                }

                excluded_rule {
                    # HTTP User-Agent ヘッダーのないリクエストをブロックするルール
                    name = "NoUserAgent_HEADER"
                }
            }
        }

        visibility_config {
            # CloudWatchメトリクスの有効化
            cloudwatch_metrics_enabled = false
            # メトリクス名
            metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
            # Block条件に該当するリクエストが発生していた場合は、リクエストの情報・該当するRuleを表示するかどうか
            sampled_requests_enabled   = true
        }
    }
    rule {
        # 無効であることがわかっており脆弱性の悪用または発見に関連するリクエストパターンをブロックするルール
        name     = "AWSManagedRulesKnownBadInputsRuleSet"
        priority = 20
 
        override_action {
            count {}
        }
    
        statement {
            managed_rule_group_statement {
                name        = "AWSManagedRulesKnownBadInputsRuleSet"
                vendor_name = "AWS"
            }
        }
    
        visibility_config {
            cloudwatch_metrics_enabled = false
            metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
            sampled_requests_enabled   = true
        }
    }
    # Default web ACL action for requests that don't match any rules
    default_action {
        allow {}
    }

    visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWS-AWSManagedRules"
        sampled_requests_enabled   = true
    }
}