#####
# Web Application Firewall configuration
#####
module "waf" {
  source = "../.."

  name_prefix = var.name_prefix

  allow_default_action = true

  scope = "REGIONAL"

  create_alb_association = false

  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.name_prefix}-waf-setup-waf-main-metrics"
    sampled_requests_enabled   = false
  }

  rules = [
    {
      name     = "AWSManagedRulesBotControlRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesBotControlRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "block-specific-agent"
      priority = "2"
      action   = "block"

      and_statement = {
        statements = [
          {
            label_match_statement = {
              key   = "awswaf:managed:aws:bot-control:signal:non_browser_user_agent"
              scope = "LABEL"
            }
          },
          {
            byte_match_statement = {
              field_to_match = {
                single_header = {
                  name = "user-agent"
                }
              }
              positional_constraint = "CONTAINS"
              search_string         = "BadBot"
              priority              = 0
              type                  = "NONE"
            }
          }
        ]
      }
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  tags = {
    "Environment" = "test"
  }
}
