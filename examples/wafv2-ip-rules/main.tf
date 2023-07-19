#####
# IP set resources
#####
resource "aws_wafv2_ip_set" "block_ip_set" {
  name = "${var.name_prefix}-generated-ips"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  # generates a list of all /16s
  addresses = formatlist("%s.0.0.0/16", range(0, 50))
}

resource "aws_wafv2_ip_set" "custom_ip_set" {
  name = "${var.name_prefix}-custom-ip-set"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "10.0.0.0/16",
    "10.10.0.0/16"
  ]
}

#####
# Web Application Firewall configuration
#####
module "waf" {
  source = "../.."

  name_prefix = var.name_prefix

  allow_default_action = true

  create_alb_association = false

  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.name_prefix}-waf-setup-waf-main-metrics"
    sampled_requests_enabled   = false
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "ip-rate-limit"
      priority = "2"
      action   = "count"

      rate_based_statement = {
        limit              = 100
        aggregate_key_type = "IP"

        # Optional scope_down_statement to refine what gets rate limited
        scope_down_statement = {
          not_statement = { # not statement to rate limit everything except the following path
            byte_match_statement = {
              field_to_match = {
                uri_path = "{}"
              }
              positional_constraint = "STARTS_WITH"
              search_string         = "/path/to/match"
              priority              = 0
              type                  = "NONE"
            }
          }
        }
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "ip-rate-limit-with-or-scope-down"
      priority = "3"
      action   = "count"

      rate_based_statement = {
        limit              = 100
        aggregate_key_type = "IP"

        # Optional scope_down_statement to refine what gets rate limited
        scope_down_statement = {
          or_statement = { # OR and AND statements require 2 or more statements to function
            statements = [
              {
                byte_match_statement = {
                  field_to_match = {
                    uri_path = "{}"
                  }
                  positional_constraint = "STARTS_WITH"
                  search_string         = "/api"
                  priority              = 0
                  type                  = "NONE"
                }
              },
              {
                byte_match_statement = {
                  field_to_match = {
                    body = "{}"
                  }
                  positional_constraint = "CONTAINS"
                  search_string         = "@gmail.com"
                  priority              = 0
                  type                  = "NONE"
                }
              },
              {
                geo_match_statement = {
                  country_codes = ["NL", "GB", "US"]
                }
              }
            ]
          }
        }
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "allow-custom-ip-set"
      priority = "4"
      action   = "count"

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.custom_ip_set.arn
      }

      forwarded_ip_config = {
        header_name       = "X-Forwarded-For"
        fallback_behavior = "NO_MATCH"
        position          = "ANY"
      }


      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "allow-custom-ip-set-with-XFF-header"
      priority = "5"
      action   = "count"

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.custom_ip_set.arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "block-ip-set"
      priority = "6"
      action   = "block"

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.block_ip_set.arn

        ip_set_forwarded_ip_config = {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
          position          = "ANY"
        }
      }

      forwarded_ip_config = {
        header_name       = "X-Forwarded-For"
        fallback_behavior = "NO_MATCH"
        position          = "ANY"
      }


      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "test-waf-setup-waf-ip-set-block-metrics"
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "ip-rate-limit-wo-scope-down-statement"
      priority = "7"
      action   = "count"

      rate_based_statement = {
        limit              = 1000
        aggregate_key_type = "IP"
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
