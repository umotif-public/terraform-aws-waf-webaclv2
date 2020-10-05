provider "aws" {
  region = "eu-west-1"
}

#####
# IP set resources
#####
resource "aws_wafv2_ip_set" "block_ip_set" {
  name = "generated-ips"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  # generates a list of all /16s
  addresses = formatlist("%s.0.0.0/16", range(0, 50))
}

resource "aws_wafv2_ip_set" "custom_ip_set" {
  name = "custom-ip-set"

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

  name_prefix = "test-waf-setup"

  allow_default_action = true

  create_alb_association = false

  visibility_config = {
    cloudwatch_metrics_enabled = false
    metric_name                = "test-waf-setup-waf-main-metrics"
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
    }
  ]

  ip_set_rules = [
    {
      name     = "allow-custom-ip-set"
      priority = 5
      # action   = "count" # if not set, action defaults to allow
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
      priority = 6
      action   = "block"
      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.block_ip_set.arn
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "test-waf-setup-waf-ip-set-block-metrics"
        sampled_requests_enabled   = false
      }
    }
  ]

  ip_rate_based_rule = {
    name     = "ip-rate-limit"
    priority = 2
    # action   = "count" # if not set, action defaults to block

    rate_based_statement = {
      limit              = 100
      aggregate_key_type = "IP"
    }

    visibility_config = {
      cloudwatch_metrics_enabled = false
      sampled_requests_enabled   = false
    }
  }

  tags = {
    "Environment" = "test"
  }
}
