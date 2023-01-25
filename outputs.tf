output "web_acl_name" {
  description = "The name of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.main[*].name)
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.main[*].arn)
}

output "web_acl_id" {
  description = "The ID of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.main[*].id)
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = join("", aws_wafv2_web_acl.main[*].capacity)
}

output "web_acl_visibility_config_name" {
  description = "The web ACL visibility config name"
  value       = var.enabled ? aws_wafv2_web_acl.main[0].visibility_config[0].metric_name : ""
}

output "web_acl_rule_names" {
  description = "List of created rule names"
  value       = [for rule_names in aws_wafv2_web_acl.main[0].rule : rule_names.name if var.enabled]
}

output "web_acl_assoc_id" {
  description = "The ID of the Web ACL Association"
  value       = try(aws_wafv2_web_acl_association.main[0].id, "")
}

output "web_acl_assoc_resource_arn" {
  description = "The ARN of the ALB attached to the Web ACL Association"
  value       = try(aws_wafv2_web_acl_association.main[0].resource_arn, "")
}

output "web_acl_assoc_acl_arn" {
  description = "The ARN of the Web ACL attached to the Web ACL Association"
  value       = try(aws_wafv2_web_acl_association.main[0].web_acl_arn, "")
}

output "web_acl_assoc_alb_list_id" {
  description = "The ID of the Web ACL Association for the alb_list resource"
  value       = try(join(", ", aws_wafv2_web_acl_association.alb_list[0].id), "")
}

output "web_acl_assoc_alb_list_resource_arn" {
  description = "The ARN of the ALB attached to the Web ACL Association for the alb_list resource"
  value       = try(join(", ", aws_wafv2_web_acl_association.alb_list[0].resource_arn), "")
}

output "web_acl_assoc_alb_list_acl_arn" {
  description = "The ARN of the Web ACL attached to the Web ACL Association for the alb_list resource"
  value       = try(join(", ", aws_wafv2_web_acl_association.alb_list[0].web_acl_arn), "")
}

output "web_acl_logging_configuration_id" {
  description = "The ID of the Web ACL logging configuration resource"
  value       = try(aws_wafv2_web_acl_logging_configuration.main[0].id, "")
}
