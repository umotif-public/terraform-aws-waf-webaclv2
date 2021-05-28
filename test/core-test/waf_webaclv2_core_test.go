package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWafWebAclV2Core(t *testing.T) {
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/core",
		Upgrade:      true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	// WebACL outputs
	WebAclName := terraform.Output(t, terraformOptions, "web_acl_name")
	WebAclArn := terraform.Output(t, terraformOptions, "web_acl_arn")
	WebAclCapacity := terraform.Output(t, terraformOptions, "web_acl_capacity")
	WebAclVisConfigMetricName := terraform.Output(t, terraformOptions, "web_acl_visibility_config_name")

	// Rule outputs
	WebAclRuleNames := terraform.Output(t, terraformOptions, "web_acl_rule_names")

	// Web ACL Association Outputs
	WebAclAssociationId := terraform.Output(t, terraformOptions, "web_acl_assoc_id")
	WebAclAssociationResourceArn := terraform.Output(t, terraformOptions, "web_acl_assoc_resource_arn")
	WebAclAssociationAclArn := terraform.Output(t, terraformOptions, "web_acl_assoc_acl_arn")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, WebAclName, "test-waf-setup")
	assert.Contains(t, WebAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclArn, "regional/webacl/test-waf-setup")
	assert.Equal(t, WebAclVisConfigMetricName, "test-waf-setup-waf-main-metrics")
	assert.Equal(t, WebAclCapacity, "1051")
	assert.Equal(t, WebAclRuleNames, "block-nl-us-traffic, AWSManagedRulesBotControlRuleSet-rule-4, AWSManagedRulesCommonRuleSet-rule-1, AWSManagedRulesKnownBadInputsRuleSet-rule-2, AWSManagedRulesPHPRuleSet-rule-3")
	assert.Contains(t, WebAclAssociationId, "arn:aws:wafv2:eu-west-1")
	assert.Contains(t, WebAclAssociationId, "regional/webacl/test-waf-setup")
	assert.Contains(t, WebAclAssociationResourceArn, "arn:aws:elasticloadbalancing:eu-west-1")
	assert.Contains(t, WebAclAssociationResourceArn, "loadbalancer/app/alb-waf-example")
	assert.Contains(t, WebAclAssociationAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclAssociationAclArn, "regional/webacl/test-waf-setup")
}
