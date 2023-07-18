resource "aws_wafv2_regex_pattern_set" "bad_bots_user_agent" {
  name        = "BadBotsUserAgent"
  description = "Some bots regex pattern set example"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = "semrushbot|censysinspect"
  }

  regular_expression {
    regex_string = "blackwidow|acunetix-*"
  }

  tags = {
    Name        = "RegexBadBots"
    Environment = "WAFv2"
  }
}

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
      name     = "MatchRegexRule-1"
      priority = "1"

      action = "block"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "RegexBadBotsUserAgent-metric"
        sampled_requests_enabled   = false
      }

      regex_pattern_set_reference_statement = {
        arn = aws_wafv2_regex_pattern_set.bad_bots_user_agent.arn
        field_to_match = {
          single_header = {
            name = "user-agent"
          }
        }
        priority = 0
        type     = "LOWERCASE" # The text transformation type
      }
    }
  ]

  tags = {
    "Environment" = "test"
  }
}
