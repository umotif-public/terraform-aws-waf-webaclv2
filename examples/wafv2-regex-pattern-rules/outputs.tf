output "web_acl_name" {
  description = "The name of the WAFv2 WebACL."
  value       = module.waf.web_acl_name
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = module.waf.web_acl_arn
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = module.waf.web_acl_capacity
}

output "web_acl_visibility_config_name" {
  description = "The web ACL visibility config name"
  value       = module.waf.web_acl_visibility_config_name
}

output "web_acl_rule_names" {
  description = "List of created rule names"
  value       = module.waf.web_acl_rule_names
}

output "bad_bots_regex_pattern_arn" {
  description = "Regex for bad bots example"
  value       = aws_wafv2_regex_pattern_set.bad_bots_user_agent.arn

}

output "bad_bots_regex_pattern_name" {
  description = "Regex for bad bots example"
  value       = aws_wafv2_regex_pattern_set.bad_bots_user_agent.name
}
