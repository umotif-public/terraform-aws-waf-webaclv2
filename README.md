# terraform-aws-waf-webaclv2

Terraform module to configure WAF WebACL V2 for Application Load Balancer.

Module supports all AWS managed rules defained in https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html.

## Terraform versions

Terraform 0.12. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

## Usage

Please pin down version of this module to exact version.

```hcl
module "waf" {
  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 1.0.0"

  name_prefix = "test-waf-setup"
  alb_arn     = module.alb.arn

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

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
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

## Assumptions

Module is to be used with Terraform > 0.12.

## Current Limitations/Issues

1. All rules deployed via this module are set to allowing mode. At this stage, I was unable to find a way to pass following block as an environment variable (feel free to create a PR to resolve it):
```tf
default_action {
    allow {}
}
```
This problem is tracked -> https://discuss.hashicorp.com/t/conditional-block-or-allow-variable-for-wafv2-resource-when-using-override-action-or-default-action/10162

2. There is a terraform provider issue where you can't update tags once your WAFv2 is deployed. Issue reported -> https://github.com/terraform-providers/terraform-provider-aws/issues/13863

## Examples

* [WAF ACL](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/master/examples/core)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.67 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.67 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | Application Load Balancer ARN | `string` | `""` | no |
| create\_alb\_association | Whether to create alb association with WAF web acl | `bool` | `true` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| name\_prefix | Name prefix used to create resources. | `string` | n/a | yes |
| rules | List of WAF rules. | `list` | `[]` | no |
| tags | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| visibility\_config | Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_arn | n/a |
| web\_acl\_capacity | n/a |
| web\_acl\_id | n/a |
| web\_acl\_name | n/a |

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