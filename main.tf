resource "aws_cloudformation_stack" "waf" {
  count = var.enabled ? 1 : 0

  name         = "${var.name_prefix}-waf-stack"
  capabilities = ["CAPABILITY_IAM"]

  template_body = file("${path.module}/cfm/waf.yaml")

  parameters = {
    NamePrefix = var.name_prefix
    AlbArn     = var.alb_arn != "" ? var.alb_arn : "no"

    DefaultActionAllowEnabled = var.enable_DefaultActionAllow ? "yes" : "no"

    AWSManagedRulesCommonRuleSetEnabled          = var.enable_CommonRuleSet ? "yes" : "no"
    AWSManagedRulesAdminProtectionRuleSetEnabled = var.enable_AdminProtectionRuleSet ? "yes" : "no"
    AWSManagedRulesKnownBadInputsRuleSetEnabled  = var.enable_KnownBadInputsRuleSet ? "yes" : "no"
    AWSManagedRulesSQLiRuleSetEnabled            = var.enable_SQLiRuleSet ? "yes" : "no"
    AWSManagedRulesLinuxRuleSetEnabled           = var.enable_LinuxRuleSet ? "yes" : "no"
    AWSManagedRulesUnixRuleSetEnabled            = var.enable_UnixRuleSet ? "yes" : "no"
    AWSManagedRulesWindowsRuleSetEnabled         = var.enable_WindowsRuleSet ? "yes" : "no"
    AWSManagedRulesPHPRuleSetEnabled             = var.enable_PHPRuleSet ? "yes" : "no"
    AWSManagedRulesWordPressRuleSetEnabled       = var.enable_WordPressRuleSet ? "yes" : "no"
    AWSManagedRulesAmazonIpReputationListEnabled = var.enable_AmazonIpReputationList ? "yes" : "no"
    AWSManagedRulesAnonymousIpListEnabled        = var.enable_AnonymousIpList ? "yes" : "no"

    OverrideActionCountCommonRuleSetEnabled          = var.enable_OverrideActionCountCommonRuleSet ? "yes" : "no"
    OverrideActionCountAdminProtectionRuleSetEnabled = var.enable_OverrideActionCountAdminProtectionRuleSet ? "yes" : "no"
    OverrideActionCountKnownBadInputsRuleSetEnabled  = var.enable_OverrideActionCountKnownBadInputsRuleSet ? "yes" : "no"
    OverrideActionCountSQLiRuleSetEnabled            = var.enable_OverrideActionCountSQLiRuleSet ? "yes" : "no"
    OverrideActionCountLinuxRuleSetEnabled           = var.enable_OverrideActionCountLinuxRuleSet ? "yes" : "no"
    OverrideActionCountUnixRuleSetEnabled            = var.enable_OverrideActionCountUnixRuleSet ? "yes" : "no"
    OverrideActionCountWindowsRuleSetEnabled         = var.enable_OverrideActionCountWindowsRuleSet ? "yes" : "no"
    OverrideActionCountPHPRuleSetEnabled             = var.enable_OverrideActionCountPHPRuleSet ? "yes" : "no"
    OverrideActionCountWordPressRuleSetEnabled       = var.enable_OverrideActionCountWordPressRuleSet ? "yes" : "no"
    OverrideActionCountAmazonIpReputationListEnabled = var.enable_OverrideActionCountAmazonIpReputationList ? "yes" : "no"
    OverrideActionCountAnonymousIpListEnabled        = var.enable_OverrideActionCountAnonymousIpList ? "yes" : "no"
  }

  tags = var.tags
}
