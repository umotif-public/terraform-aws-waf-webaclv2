package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWafWebAclV2Bytematch(t *testing.T) {
	// Random generate a string for naming resources
	uniqueID := strings.ToLower(random.UniqueId())
	resourceName := fmt.Sprintf("test%s", uniqueID)

	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/wafv2-bytematch-rules",
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

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "test"+uniqueID, WebAclName)
	assert.Contains(t, WebAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclArn, "regional/webacl/test"+uniqueID)
	assert.Equal(t, "test"+uniqueID+"-waf-setup-waf-main-metrics", WebAclVisConfigMetricName)
	assert.Equal(t, "756", WebAclCapacity)
	assert.Equal(t, "[block-all-post-requests block-cookie block-if-request-body-contains-hotmail-email block-single-user block-specific-uri-path block-unauthorized AWSManagedRulesCommonRuleSet-rule-1]", WebAclRuleNames)
}
