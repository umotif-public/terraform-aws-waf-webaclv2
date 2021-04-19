![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/umotif-public/terraform-aws-waf-webaclv2?style=social)

# terraform-aws-waf-webaclv2

Terraform module to configure WAF Web ACL V2 for Application Load Balancer or Cloudfront distribution.

Supported WAF v2 components:

- Module supports all AWS managed rules defined in https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html.
- Associating WAFv2 ACL with one or more Application Load Balancers (ALB)
- Blocking IP Sets
- Rate limiting IPs

## Terraform versions

Terraform 0.12 and 0.13. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

## Usage

Please pin down version of this module to exact version.

```hcl
module "waf" {
  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 1.5.0"

  name_prefix = "test-waf-setup"
  alb_arn     = module.alb.arn

  scope = "REGIONAL"

  create_alb_association = true

  allow_default_action = true # set to allow if not specified

  visibility_config = {
    metric_name = "test-waf-setup-waf-main-metrics"
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none" # set to none if not specified

      visibility_config = {
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
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
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
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
    "Name" = "test-waf-setup"
    "Env"  = "test"
  }
}
```

### Cloudfront configuration

```hcl
provider "aws" {
  alias = "us-east"

  version = ">= 2.70"
  region  = "us-east-1"
}

module "waf" {
  providers = {
    aws = aws.us-east
  }

  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 1.5.0"

  name_prefix = "test-waf-setup-cloudfront"
  scope = "CLOUDFRONT"
  create_alb_association = false
  ...
}
```

## Assumptions

Module is to be used with Terraform > 0.12.

## Logging configuration

When you enable logging configuration for WAFv2. Remember to follow naming convention defined in https://docs.aws.amazon.com/waf/latest/developerguide/logging.html.

Importantly, make sure that Amazon Kinesis Data Firehose is using a name starting with the prefix aws-waf-logs-.

## Examples

* [WAF ACL](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/master/examples/core)
* [WAF ACL with configuration logging](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/master/examples/wafv2-logging-configuration)
* [WAF ACL with ip rules](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/master/examples/wafv2-ip-rules)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 2.70 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | Application Load Balancer ARN | `string` | `""` | no |
| alb\_arn\_list | Application Load Balancer ARN list | `list(string)` | `[]` | no |
| allow\_default\_action | Set to `true` for WAF to allow requests by default. Set to `false` for WAF to block requests by default. | `bool` | `true` | no |
| create\_alb\_association | Whether to create alb association with WAF web acl | `bool` | `true` | no |
| create\_logging\_configuration | Whether to create logging configuration in order start logging from a WAFv2 Web ACL to Amazon Kinesis Data Firehose. | `bool` | `false` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| geo\_match\_rules | List of WAF geo match rules to detect web requests coming from a particular set of contry codes. | `list` | `[]` | no |
| ip\_rate\_based\_rule | A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | `any` | `null` | no |
| ip\_set\_rules | List of WAF ip set rules to detect web requests coming from particular IP addresses or address ranges. | `list` | `[]` | no |
| log\_destination\_configs | The Amazon Kinesis Data Firehose Amazon Resource Name (ARNs) that you want to associate with the web ACL. Currently, only 1 ARN is supported. | `list(string)` | `[]` | no |
| name\_prefix | Name prefix used to create resources. | `string` | n/a | yes |
| redacted\_fields | The parts of the request that you want to keep out of the logs. Up to 100 `redacted_fields` blocks are supported. | `list` | `[]` | no |
| rules | List of WAF rules. | `list` | `[]` | no |
| scope | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider. | `string` | `"REGIONAL"` | no |
| tags | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| visibility\_config | Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_arn | The ARN of the WAFv2 WebACL. |
| web\_acl\_capacity | The web ACL capacity units (WCUs) currently being used by this web ACL. |
| web\_acl\_id | The ID of the WAFv2 WebACL. |
| web\_acl\_name | The name of the WAFv2 WebACL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```
