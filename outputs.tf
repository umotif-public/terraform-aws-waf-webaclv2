locals {
  waf_outputs = coalescelist(aws_cloudformation_stack.waf.*.outputs, [{}])[0]
}

output waf_name {
  description = "The name of the created WAF"
  value       = lookup(local.waf_outputs, "WAFWebName", null)
}

output waf_id {
  description = "The id of the created WAF"
  value       = lookup(local.waf_outputs, "WAFWebId", null)
}
