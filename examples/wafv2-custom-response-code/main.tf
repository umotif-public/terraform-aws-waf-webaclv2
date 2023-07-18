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

  rules = [
    {
      name        = "ip-rate-based"
      priority    = "6"
      action      = "block"
      rule_labels = ["LabelNameA"]

      custom_response = {
        response_code = 412
      }

      rate_based_statement = {
        limit              = 2000 # Note this is by default in a 5-min span, ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#rate_based_statement
        aggregate_key_type = "IP"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IPRateBased-metric"
        sampled_requests_enabled   = false
      }
    },
    {
      # Note: custom responses can not be applied to AWS managed rule groups directly. Must use a label technique, ref: https://aws.amazon.com/blogs/security/how-to-customize-behavior-of-aws-managed-rules-for-aws-waf/
      name     = "AWSManagedRulesBotControlRuleSet-rule-0"
      priority = "0"

      # Note: override_action is for managed rule sets only, otherwise would be action
      override_action = "none"

      managed_rule_group_statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesBotControlRuleSet-metric"
        sampled_requests_enabled   = false
      }
    }
  ]
}
