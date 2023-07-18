module "waf" {
  source = "../.."

  name_prefix          = var.name_prefix
  allow_default_action = true

  create_alb_association = false

  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.name_prefix}-waf-setup-waf-main-metrics"
    sampled_requests_enabled   = false
  }

  custom_response_bodies = [
    {
      key          = "403-forbidden-json"
      content      = "{\"code\":403,\"message\":\"Forbidden\"}"
      content_type = "APPLICATION_JSON"
    }
  ]

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule"
      priority = "0"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "JsonResponse"
      priority = "1"
      action   = "block"
      custom_response = {
        custom_response_body_key = "403-forbidden-json"
        response_code            = 403
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSetJsonResponse"
        sampled_requests_enabled   = true
      }

      label_match_statement = {
        key   = "awswaf:managed:aws:"
        scope = "NAMESPACE"
      }
    },
  ]
}
