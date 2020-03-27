variable "enabled" {
  type        = bool
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
  default     = true
}

variable "name_prefix" {
  type        = string
  description = "Name prefix used to create resources."
}

variable "alb_arn" {
  type        = string
  description = "Application Load Balancer ARN"
  default     = ""
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "enable_CommonRuleSet" {
  type    = bool
  default = false
}

variable "enable_AdminProtectionRuleSet" {
  type    = bool
  default = false
}

variable "enable_KnownBadInputsRuleSet" {
  type    = bool
  default = false
}

variable "enable_SQLiRuleSet" {
  type    = bool
  default = false
}

variable "enable_LinuxRuleSet" {
  type    = bool
  default = false
}

variable "enable_UnixRuleSet" {
  type    = bool
  default = false
}

variable "enable_WindowsRuleSet" {
  type    = bool
  default = false
}

variable "enable_PHPRuleSet" {
  type    = bool
  default = false
}

variable "enable_WordPressRuleSet" {
  type    = bool
  default = false
}

variable "enable_AmazonIpReputationList" {
  type    = bool
  default = false
}

variable "enable_AnonymousIpList" {
  type    = bool
  default = false
}

variable "enable_DefaultActionAllow" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountCommonRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountAdminProtectionRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountKnownBadInputsRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountSQLiRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountLinuxRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountUnixRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountWindowsRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountPHPRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountWordPressRuleSet" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountAmazonIpReputationList" {
  type    = bool
  default = true
}

variable "enable_OverrideActionCountAnonymousIpList" {
  type    = bool
  default = true
}

variable "CommonRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "AdminProtectionRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "KnownBadInputsRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "SQLiRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "LinuxRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "UnixRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "WindowsRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "PHPRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "WordPressRuleSetExcludedRules" {
  type    = string
  default = ""
}

variable "AmazonIpReputationListExcludedRules" {
  type    = string
  default = ""
}

variable "RulesAnonymousIpListExcludedRules" {
  type    = string
  default = ""
}
