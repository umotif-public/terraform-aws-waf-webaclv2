provider "aws" {
  region = "eu-west-1"
}

#####
# IP set resources
#####
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

  scope = "REGIONAL"

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
        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_BODY",
          "GenericRFI_QUERYARGUMENTS"
        ]
      }
    },
    {
      ### AND rule example
      name     = "block-specific-uri-path-and-requests-from-nl-gb-and-us"
      priority = 2
      action   = "block"

      and_statement = {
        statements = [ # 2 or more statements are required for AND
          {
            byte_match_statement = {
              field_to_match = {
                uri_path = "{}"
              }
              positional_constraint = "STARTS_WITH"
              search_string         = "/path/to/match"
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

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      ### OR rule example
      name     = "block-specific-ip-set-or-body-contains-hotmail"
      priority = 3
      action   = "block"

      or_statement = {
        statements = [ # 2 or more statements are required for OR
          {
            ip_set_reference_statement = {
              arn = aws_wafv2_ip_set.custom_ip_set.arn
            }
          },
          {
            byte_match_statement = {
              field_to_match = {
                body = "{}"
              }
              positional_constraint = "CONTAINS"
              search_string         = "@hotmail.com"
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
