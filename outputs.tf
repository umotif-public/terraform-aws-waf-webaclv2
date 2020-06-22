output "web_acl_name" {
  value = join("", aws_wafv2_web_acl.main.*.name)
}

output "web_acl_arn" {
  value = join("", aws_wafv2_web_acl.main.*.arn)
}

output "web_acl_id" {
  value = join("", aws_wafv2_web_acl.main.*.id)
}

output "web_acl_capacity" {
  value = join("", aws_wafv2_web_acl.main.*.capacity)
}
