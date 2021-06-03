package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWafWebAclV2IpRules(t *testing.T) {
	// Random generate a string for naming resources
	uniqueID := strings.ToLower(random.UniqueId())
	resourceName := fmt.Sprintf("test%s", uniqueID)

	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/wafv2-ip-rules",
		Upgrade:      true,

		// Variables to pass using -var-file option
		Vars: map[string]interface{}{
			"name_prefix": resourceName,
		},
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

	// IP Set outputs
	BlockIpSetArn := terraform.Output(t, terraformOptions, "block_ip_set_arn")
	CustomIpSetArn := terraform.Output(t, terraformOptions, "custom_ip_set_arn")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, WebAclName, "test"+uniqueID)
	assert.Contains(t, WebAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclArn, "regional/webacl/test"+uniqueID)
	assert.Equal(t, WebAclVisConfigMetricName, "test"+uniqueID+"-waf-setup-waf-main-metrics")
	assert.Equal(t, WebAclCapacity, "721")
	assert.Equal(t, WebAclRuleNames, "block-ip-set, allow-custom-ip-set, ip-rate-limit, ip-rate-limit-with-or-scope-down, AWSManagedRulesCommonRuleSet-rule-1")
	assert.Contains(t, BlockIpSetArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, BlockIpSetArn, "regional/ipset/test"+uniqueID+"-generated-ips")
	assert.Contains(t, CustomIpSetArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, CustomIpSetArn, "regional/ipset/test"+uniqueID+"-custom-ip-set")
}
