locals {
  waf_outputs = coalescelist(aws_cloudformation_stack.waf.*.outputs, [{}])[0]
}

output waf_name {
  description = "The name of the created WAF Web ACL"
  value       = lookup(local.waf_outputs, "WAFWebName", null)
}

output waf_arn {
  description = "The arn of the created WAF Web ACL"
  value       = lookup(local.waf_outputs, "WAFWebArn", null)
}
