# terraform-aws-waf-webaclv2

Terraform module to configure WAF WebACL V2 for Application Load Balancer.

This module is initally configured to use cloudformation as Terraform doesn't support WAFv2 API. Issue tracking progress on this can be found -> https://github.com/terraform-providers/terraform-provider-aws/issues/11046.

This module will progress to version 1.0.0 once full support from Terraform is implemented and provided as part of terraform-aws-provider.

Module support all AWS managed rules defained in https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html.

## Terraform versions

Terraform 0.12. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

## Usage

Please pin down version of this module to exact version.

```hcl
module "waf" {
  source = "umotif-public/waf-webaclv2/aws"
  version = "0.0.1"

  name_prefix = "test-waf-setup"
  alb_arn     = module.alb.arn

  enable_CommonRuleSet = true
  enable_PHPRuleSet    = true
}
```

## Assumptions

Module is to be used with Terraform > 0.12.

## Examples

* [WAF ACL](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/master/examples/core)

## Authors

Module managed by [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| AdminProtectionRuleSetExcludedRules | n/a | `string` | `""` | no |
| AmazonIpReputationListExcludedRules | n/a | `string` | `""` | no |
| CommonRuleSetExcludedRules | n/a | `string` | `""` | no |
| KnownBadInputsRuleSetExcludedRules | n/a | `string` | `""` | no |
| LinuxRuleSetExcludedRules | n/a | `string` | `""` | no |
| PHPRuleSetExcludedRules | n/a | `string` | `""` | no |
| RulesAnonymousIpListExcludedRules | n/a | `string` | `""` | no |
| SQLiRuleSetExcludedRules | n/a | `string` | `""` | no |
| UnixRuleSetExcludedRules | n/a | `string` | `""` | no |
| WindowsRuleSetExcludedRules | n/a | `string` | `""` | no |
| WordPressRuleSetExcludedRules | n/a | `string` | `""` | no |
| alb\_arn | Application Load Balancer ARN | `string` | `""` | no |
| enable\_AdminProtectionRuleSet | n/a | `bool` | `false` | no |
| enable\_AmazonIpReputationList | n/a | `bool` | `false` | no |
| enable\_AnonymousIpList | n/a | `bool` | `false` | no |
| enable\_CommonRuleSet | n/a | `bool` | `false` | no |
| enable\_DefaultActionAllow | n/a | `bool` | `true` | no |
| enable\_KnownBadInputsRuleSet | n/a | `bool` | `false` | no |
| enable\_LinuxRuleSet | n/a | `bool` | `false` | no |
| enable\_OverrideActionCountAdminProtectionRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountAmazonIpReputationList | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountAnonymousIpList | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountCommonRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountKnownBadInputsRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountLinuxRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountPHPRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountSQLiRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountUnixRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountWindowsRuleSet | n/a | `bool` | `true` | no |
| enable\_OverrideActionCountWordPressRuleSet | n/a | `bool` | `true` | no |
| enable\_PHPRuleSet | n/a | `bool` | `false` | no |
| enable\_SQLiRuleSet | n/a | `bool` | `false` | no |
| enable\_UnixRuleSet | n/a | `bool` | `false` | no |
| enable\_WindowsRuleSet | n/a | `bool` | `false` | no |
| enable\_WordPressRuleSet | n/a | `bool` | `false` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| name\_prefix | Name prefix used to create resources. | `string` | n/a | yes |
| tags | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |

## Outputs

No output.

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
```