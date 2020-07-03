provider "aws" {
  region = "eu-west-1"
}


#####
# VPC and subnets
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.44"

  name = "simple-waf-test-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
}

#####
# ALB
#####
module "alb" {
  source  = "umotif-public/alb/aws"
  version = "~> 1.2.0"

  name_prefix        = "alb-example"
  load_balancer_type = "application"
  internal           = false
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
}

#####
# Web Application Firewall configuration
#####
module "waf" {
  source = "../.."

  name_prefix = "test-waf-setup"
  alb_arn     = module.alb.arn

  allow_default_action = true

  create_alb_association = true

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
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesPHPRuleSet-rule-3"
      priority = "3"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesPHPRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    }
  ]

  tags = {
    "Environment" = "test"
  }
}
