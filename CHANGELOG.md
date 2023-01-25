# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]

- Exclude rule deprecated in AWS ([#77](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/77))
- Add output `web_acl_logging_configuration_id` ([#75](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/75))
- Add dynamic rule_group_reference_statement block to attach custom rule groups ([#70](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/70))
- Added support for Regex Match Statements ([#63](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/63))
- Enable the block to attach custom rule groups
- Bug fixes for `rate_based_statement`  with `forwarded_ip_config` and `ip_set_reference_statement` with `ip_set_forwarded_ip_config` ([#69](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/69))
- Updating to meeting requirements of fix to terraform provider.
- Small corrections to sizeconstraint rule.
- Correction to use equals sign.
- Updating sizeconstraint rule to have oversizehandling for body.
- Revert "Correct ip_set example"
- Correct ip_set example
- Adding forwarded_ip_config for ip_set. Added regex_set for AND Not Statement. ([#65](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/65))
- Added support for Regex Match Statements ([#63](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/63))


<a name="3.8.1"></a>
## [3.8.1] - 2022-05-26

- feat: add label_match_statement to managed_rule_group_statement ([#60](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/60))


<a name="3.8.0"></a>
## [3.8.0] - 2022-05-18

- feat: add label_match_statement & rule_labels ([#58](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/58))
- Custom Block Response ([#56](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/56))


<a name="3.7.3"></a>
## [3.7.3] - 2022-05-12

- Add 'version' to managed_rule_group_statement ([#55](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/55))


<a name="3.7.2"></a>
## [3.7.2] - 2022-05-12

- removed duplicated code ([#53](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/53))


<a name="3.7.1"></a>
## [3.7.1] - 2022-05-12

- docs(README): add missing = sign after not_statement ([#51](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/51))


<a name="3.7.0"></a>
## [3.7.0] - 2022-03-31

- Added support for forwarded_ip_config inside of geo_match_statement ([#49](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/49))


<a name="3.6.0-patch-1"></a>
## [3.6.0-patch-1] - 2022-03-22

- Added support for forwarded_ip_config inside of geo_match_statement


<a name="3.6.0"></a>
## [3.6.0] - 2022-02-21

- feat(rules): add regex pattern rules support ([#48](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/48))


<a name="3.5.0"></a>
## [3.5.0] - 2022-01-12

- ipset in multiple not statements ([#44](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/44))


<a name="3.4.0"></a>
## [3.4.0] - 2021-12-16

- Adds Label Match Statement ([#43](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/43))


<a name="3.3.0"></a>
## [3.3.0] - 2021-10-20

- feat(rules): add size constraint statement ([#41](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/41))


<a name="3.2.0"></a>
## [3.2.0] - 2021-07-21

- Scopedown on managerules ([#40](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/40))


<a name="3.1.1"></a>
## [3.1.1] - 2021-07-09

- Switched to try for ALB outputs ([#36](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/36))
- Fix issue where using alb_arn_list will cause outputs to fail ([#35](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/35))


<a name="3.1.0"></a>
## [3.1.0] - 2021-06-28

- Add optional description fior WebACL ([#32](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/32))
- use correct loop var for not_statements ([#30](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/30))
- Fix failing terratests ([#31](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/31))


<a name="3.0.1"></a>
## [3.0.1] - 2021-06-04

- Update outputs to only output when the WAF is enabled ([#28](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/28))


<a name="3.0.0"></a>
## [3.0.0] - 2021-06-03

- RUpdated github action to refer to main branch instead of master ([#27](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/27))
- Update example to refer to 3.0.0 of the module ([#26](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/26))
- Readme update ([#25](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/25))
- DEVOPS-957 Terratests ([#22](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/22))
- Added missing single_header ([#24](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/24))
- Feature/devops 953 byte match statements ([#21](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/21))


<a name="2.0.0"></a>
## [2.0.0] - 2021-05-04

- Module upgrade with logging filter support ([#20](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/20))


<a name="1.6.0"></a>
## [1.6.0] - 2021-04-19

- Added actions, geo match and IP set  ([#18](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/18))
- spelling ([#19](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/19))
- Update README.md


<a name="1.5.1"></a>
## [1.5.1] - 2020-11-09

- Update module to remove 0.14 limit ([#17](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/17))


<a name="1.5.0"></a>
## [1.5.0] - 2020-10-05

- Add support for IP sets and rate limiting ([#15](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/15))


<a name="1.4.1"></a>
## [1.4.1] - 2020-08-05

- v3 aws provider support ([#14](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/14))


<a name="1.4.0"></a>
## [1.4.0] - 2020-08-04

- Add ability to support multiple ALBs ([#13](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/13))
- Improve documentation ([#12](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/12))


<a name="1.3.0"></a>
## [1.3.0] - 2020-07-07

- Add ability to change WAF scope ([#11](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/11))


<a name="1.2.0"></a>
## [1.2.0] - 2020-07-03

- Allow setting of override_action and default_action ([#10](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/10))
- Update example and fix example config ([#9](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/9))


<a name="1.1.0"></a>
## [1.1.0] - 2020-06-26

- Feature/wafv2 improvements ([#8](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/8))


<a name="1.0.1"></a>
## [1.0.1] - 2020-06-22

- Update default values to reduce duplication ([#7](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/7))
- update CHANGELOG.md


<a name="1.0.0"></a>
## [1.0.0] - 2020-06-22

- Rewrite module to fully use aws terraform provider ([#6](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/6))


<a name="0.2.0"></a>
## [0.2.0] - 2020-05-28

- Allow conditional association with ALB
- Feature/updates ([#3](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/3))


<a name="0.1.0"></a>
## [0.1.0] - 2020-03-27

- Feature/exclude rules support ([#2](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/2))
- Add support for enabling default actions per rule set ([#1](https://github.com/umotif-public/terraform-aws-waf-webaclv2/issues/1))


<a name="0.0.1"></a>
## 0.0.1 - 2020-03-24

- update readme
- Add initial WAF module configuration
- Initial commit


[Unreleased]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.8.1...HEAD
[3.8.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.8.0...3.8.1
[3.8.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.7.3...3.8.0
[3.7.3]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.7.2...3.7.3
[3.7.2]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.7.1...3.7.2
[3.7.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.7.0...3.7.1
[3.7.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.6.0-patch-1...3.7.0
[3.6.0-patch-1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.6.0...3.6.0-patch-1
[3.6.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.5.0...3.6.0
[3.5.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.4.0...3.5.0
[3.4.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.3.0...3.4.0
[3.3.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.2.0...3.3.0
[3.2.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.1.1...3.2.0
[3.1.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.0.1...3.1.0
[3.0.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/3.0.0...3.0.1
[3.0.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/2.0.0...3.0.0
[2.0.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.6.0...2.0.0
[1.6.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.5.1...1.6.0
[1.5.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.5.0...1.5.1
[1.5.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.4.1...1.5.0
[1.4.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/0.2.0...1.0.0
[0.2.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/umotif-public/terraform-aws-waf-webaclv2/compare/0.0.1...0.1.0
