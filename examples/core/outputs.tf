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

output "web_acl_assoc_id" {
  description = "The ID of the Web ACL Association"
  value       = module.waf.web_acl_assoc_id
}

output "web_acl_assoc_resource_arn" {
  description = "The ARN of the ALB attached to the Web ACL Association"
  value       = module.waf.web_acl_assoc_resource_arn
}

output "web_acl_assoc_acl_arn" {
  description = "The ARN of the Web ACL attached to the Web ACL Association"
  value       = module.waf.web_acl_assoc_acl_arn
}
