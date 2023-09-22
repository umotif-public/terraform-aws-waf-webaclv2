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
      name     = "AWSManagedRulesBotControlRuleSet-rule"
      priority = "0"

      # Note: override_action is for managed rule sets only, otherwise would be action
      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesBotControlRuleSet-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS",
        managed_rule_group_configs = {
          aws_managed_rules_bot_control_rule_set = {
            inspection_level = "TARGETED"
          }
        },
        rule_action_overrides = [
          {
            action_to_use = {
              count = {}
            }

            name = "SignalNonBrowserUserAgent"
          },
          {
            action_to_use = {
              count = {}
            }

            name = "CategoryHttpLibrary"
          },
          {
            action_to_use = {
              count = {}
            }

            name = "CategoryMonitoring"
          },
          {
            action_to_use = {
              challenge = {}
            }

            name = "TGT_VolumetricIpTokenAbsent"
          },
          {
            action_to_use = {
              captcha = {}
            }

            name = "TGT_VolumetricSession"
          },
          {
            action_to_use = {
              captcha = {}
            }

            name = "TGT_TokenReuseIp"
          },
          {
            action_to_use = {
              captcha = {}
            }

            name = "TGT_SignalBrowserInconsistency"
          },
        ]
      }
    },

  ]
}
