![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/umotif-public/terraform-aws-waf-webaclv2?style=social)

# terraform-aws-waf-webaclv2

Terraform module to configure WAF Web ACL V2 for Application Load Balancer or Cloudfront distribution.

Supported WAF v2 components:

- Module supports all AWS managed rules defined in https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html.
- Associating WAFv2 ACL with one or more Application Load Balancers (ALB)
- Blocking IP Sets
- Rate limiting IPs (and optional scopedown statements)
- Byte Match statements
- Geo set statements
- Logical Statements (AND, OR, NOT)

## Terraform versions

Terraform 0.13+ Pin module version to `~> v3.0`. Submit pull-requests to `main` branch.
Terraform 0.12 < 0.13. Pin module version to `~> v1.0`.

## Usage

Please pin down version of this module to exact version

If referring directly to the code instead of a pinned version, take note that from release 3.0.0 all future changes will only be made to the `main` branch.

```hcl
module "waf" {
  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.1.0"

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

      override_action = "none"

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

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesPHPRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    },
    ### Byte Match Rule example
    # Refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#byte-match-statement
    # for all of the options available.
    # Additional examples available in the examples directory
    {
      name     = "ByteMatchRule-4"
      priority = "4"

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "ByteMatchRule-metric"
        sampled_requests_enabled   = false
      }

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
    ### Geo Match Rule example
    {
      name     = "GeoMatchRule-5"
      priority = "5"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "GeoMatchRule-metric"
        sampled_requests_enabled   = false
      }

      geo_match_statement = {
        country_codes = ["NL", "GB", "US"]
      }
    },
    ### IP Set Rule example
    {
      name     = "IpSetRule-6"
      priority = "6"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IpSetRule-metric"
        sampled_requests_enabled   = false
      }

      ip_set_reference_statement = {
        arn = "arn:aws:wafv2:eu-west-1:111122223333:regional/ipset/ip-set-test/a1bcdef2-1234-123a-abc0-1234a5bc67d8"
      }
    },
    ### IP Rate Based Rule example
    {
      name     = "IpRateBasedRule-7"
      priority = "7"

      action = "block"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IpRateBasedRule-metric"
        sampled_requests_enabled   = false
      }

      rate_based_statement = {
        limit              = 100
        aggregate_key_type = "IP"
        # Optional scope_down_statement to refine what gets rate limited
        scope_down_statement = {
          not_statement = {
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
    },
    ### NOT rule example (can be applied to byte_match, geo_match, and ip_set rules)
    {
      name     = "NotByteMatchRule-8"
      priority = "8"

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "NotByteMatchRule-metric"
        sampled_requests_enabled   = false
      }

      not_statement {
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

  version = ">= 3.38"
  region  = "us-east-1"
}

module "waf" {
  providers = {
    aws = aws.us-east
  }

  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.1.0"

  name_prefix = "test-waf-setup-cloudfront"
  scope = "CLOUDFRONT"
  create_alb_association = false
  ...
}
```

## Logging configuration

When you enable logging configuration for WAFv2. Remember to follow naming convention defined in https://docs.aws.amazon.com/waf/latest/developerguide/logging.html.

Importantly, make sure that Amazon Kinesis Data Firehose is using a name starting with the prefix aws-waf-logs-.

## Examples

* [WAF ACL](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/core)
* [WAF ACL with configuration logging](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/wafv2-logging-configuration)
* [WAF ACL with ip rules](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/wafv2-ip-rules)
* [WAF ACL with bytematch rules](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/wafv2-bytematch-rules)
* [WAF ACL with geo match rules](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/wafv2-geo-rules)
* [WAF ACL with and / or rules](https://github.com/umotif-public/terraform-aws-waf-webaclv2/tree/main/examples/wafv2-and-or-rules)

## Authors

Module managed by:
* [Marcin Cuber](https://github.com/marcincuber) [LinkedIn](https://www.linkedin.com/in/marcincuber/)
* [Sean Pascual](https://github.com/seanpascual) [LinkedIn](https://www.linkedin.com/in/sean-edward-pascual)
* [Abdul Wahid](https://github.com/Ohid25) [LinkedIn](https://www.linkedin.com/in/abdul-wahid/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.38 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.38 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | Application Load Balancer ARN | `string` | `""` | no |
| alb\_arn\_list | Application Load Balancer ARN list | `list(string)` | `[]` | no |
| allow\_default\_action | Set to `true` for WAF to allow requests by default. Set to `false` for WAF to block requests by default. | `bool` | `true` | no |
| create\_alb\_association | Whether to create alb association with WAF web acl | `bool` | `true` | no |
| create\_logging\_configuration | Whether to create logging configuration in order start logging from a WAFv2 Web ACL to Amazon Kinesis Data Firehose. | `bool` | `false` | no |
| description | A friendly description of the WebACL | `string` | `null` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | `bool` | `true` | no |
| log\_destination\_configs | The Amazon Kinesis Data Firehose Amazon Resource Name (ARNs) that you want to associate with the web ACL. Currently, only 1 ARN is supported. | `list(string)` | `[]` | no |
| logging\_filter | A configuration block that specifies which web requests are kept in the logs and which are dropped. You can filter on the rule action and on the web request labels that were applied by matching rules during web ACL evaluation. | `any` | `{}` | no |
| name\_prefix | Name prefix used to create resources. | `string` | n/a | yes |
| redacted\_fields | The parts of the request that you want to keep out of the logs. Up to 100 `redacted_fields` blocks are supported. | `any` | `[]` | no |
| rules | List of WAF rules. | `any` | `[]` | no |
| scope | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider. | `string` | `"REGIONAL"` | no |
| tags | A map of tags (key-value pairs) passed to resources. | `map(string)` | `{}` | no |
| visibility\_config | Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_arn | The ARN of the WAFv2 WebACL. |
| web\_acl\_assoc\_acl\_arn | The ARN of the Web ACL attached to the Web ACL Association |
| web\_acl\_assoc\_alb\_list\_acl\_arn | The ARN of the Web ACL attached to the Web ACL Association for the alb\_list resource |
| web\_acl\_assoc\_alb\_list\_id | The ID of the Web ACL Association for the alb\_list resource |
| web\_acl\_assoc\_alb\_list\_resource\_arn | The ARN of the ALB attached to the Web ACL Association for the alb\_list resource |
| web\_acl\_assoc\_id | The ID of the Web ACL Association |
| web\_acl\_assoc\_resource\_arn | The ARN of the ALB attached to the Web ACL Association |
| web\_acl\_capacity | The web ACL capacity units (WCUs) currently being used by this web ACL. |
| web\_acl\_id | The ID of the WAFv2 WebACL. |
| web\_acl\_name | The name of the WAFv2 WebACL. |
| web\_acl\_rule\_names | List of created rule names |
| web\_acl\_visibility\_config\_name | The web ACL visibility config name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

See LICENSE for full details.

## Pre-commit hooks & Golang for Terratest

### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs) required for `terraform_docs` hooks.
* [`TFLint`](https://github.com/terraform-linters/tflint) required for `terraform_tflint` hook.

#### Terratest

We are using [Terratest](https://terratest.gruntwork.io/) to run tests on this module.

```bash
brew install go
# Change to the test directory
cd test
# Get dependencies
go mod download
# Run tests
go test -v -timeout 30m
```

#### MacOS

```bash
brew install pre-commit terraform-docs tflint

brew tap git-chglog/git-chglog
brew install git-chglog
```
