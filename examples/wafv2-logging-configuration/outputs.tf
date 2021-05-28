output "web_acl_name" {
  description = "The name of the WAFv2 WebACL."
  value       = module.wafv2.web_acl_name
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = module.wafv2.web_acl_arn
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = module.wafv2.web_acl_capacity
}

output "web_acl_visibility_config_name" {
  description = "The web ACL visibility config name"
  value       = module.wafv2.web_acl_visibility_config_name
}

output "web_acl_rule_names" {
  description = "List of created rule names"
  value       = module.wafv2.web_acl_rule_names
}

output "web_acl_assoc_id" {
  description = "The ID of the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_id
}

output "web_acl_assoc_resource_arn" {
  description = "The ARN of the ALB attached to the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_resource_arn
}

output "web_acl_assoc_acl_arn" {
  description = "The ARN of the Web ACL attached to the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_acl_arn
}

output "web_acl_assoc_alb_list_id" {
  description = "The ID of the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_id
}

output "web_acl_assoc_alb_list_resource_arn" {
  description = "The ARN of the ALB attached to the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_resource_arn
}

output "web_acl_assoc_alb_list_acl_arn" {
  description = "The ARN of the Web ACL attached to the Web ACL Association"
  value       = module.wafv2.web_acl_assoc_acl_arn
}

output "logging_s3_bucket_id" {
  description = "The ID of the S3 bucket used for logging"
  value       = aws_s3_bucket.bucket.id
}

output "logging_s3_bucket_arn" {
  description = "The ARN of the S3 bucket used for logging"
  value       = aws_s3_bucket.bucket.arn
}

output "logging_iam_role_id" {
  description = "The ID of the IAM role used for logging"
  value       = aws_iam_role.firehose.id
}

output "logging_iam_role_arn" {
  description = "The ARN of the IAM role used for logging"
  value       = aws_iam_role.firehose.arn
}

output "logging_iam_role_name" {
  description = "The name of the IAM role used for logging"
  value       = aws_iam_role.firehose.name
}

output "logging_iam_role_policy_id" {
  description = "The ID of the IAM role policy used for logging"
  value       = aws_iam_role_policy.custom-policy.id
}

output "logging_iam_role_policy_name" {
  description = "The name of the IAM role policy used for logging"
  value       = aws_iam_role_policy.custom-policy.name
}

output "logging_iam_role_policy_role" {
  description = "The role attached to the IAM role policy used for logging"
  value       = aws_iam_role_policy.custom-policy.role
}

output "kinesis_firehose_delivery_stream_arn" {
  description = "The ARN of the kinesis firehose delivery stream used for logging"
  value       = aws_kinesis_firehose_delivery_stream.test_stream.arn
}
