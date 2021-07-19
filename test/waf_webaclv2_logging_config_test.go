package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestWafWebAclV2Logging(t *testing.T) {
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/wafv2-logging-configuration",
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

	WebAclAssociationAlbListId := terraform.Output(t, terraformOptions, "web_acl_assoc_alb_list_id")
	WebAclAssociationAlbListResourceArn := terraform.Output(t, terraformOptions, "web_acl_assoc_alb_list_resource_arn")
	WebAclAssociationAlbListAclArn := terraform.Output(t, terraformOptions, "web_acl_assoc_alb_list_acl_arn")

	// Logging Outputs
	KinesisStreamArn := terraform.Output(t, terraformOptions, "kinesis_firehose_delivery_stream_arn")
	IamRoleArn := terraform.Output(t, terraformOptions, "logging_iam_role_arn")
	IamRoleId := terraform.Output(t, terraformOptions, "logging_iam_role_id")
	IamRoleName := terraform.Output(t, terraformOptions, "logging_iam_role_name")
	IamRolePolicyId := terraform.Output(t, terraformOptions, "logging_iam_role_policy_id")
	IamRolePolicyName := terraform.Output(t, terraformOptions, "logging_iam_role_policy_name")
	IamRolePolicyRole := terraform.Output(t, terraformOptions, "logging_iam_role_policy_role")
	S3BucketArn := terraform.Output(t, terraformOptions, "logging_s3_bucket_arn")
	S3BucketId := terraform.Output(t, terraformOptions, "logging_s3_bucket_id")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, WebAclName, "test-waf-setup")
	assert.Contains(t, WebAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclArn, "regional/webacl/test-waf-setup")
	assert.Equal(t, WebAclVisConfigMetricName, "test-waf-setup-waf-main-metrics")
	assert.Equal(t, WebAclCapacity, "950")
	assert.Equal(t, WebAclRuleNames, "AWSManagedRulesCommonRuleSet-rule-1, AWSManagedRulesKnownBadInputsRuleSet-rule-2, AWSManagedRulesPHPRuleSet-rule-3")

	assert.Contains(t, WebAclAssociationId, "arn:aws:wafv2:eu-west-1")
	assert.Contains(t, WebAclAssociationId, "regional/webacl/test-waf-setup")
	assert.Contains(t, WebAclAssociationResourceArn, "arn:aws:elasticloadbalancing:eu-west-1")
	assert.Contains(t, WebAclAssociationResourceArn, "loadbalancer/app/alb-waf-example")
	assert.Contains(t, WebAclAssociationAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclAssociationAclArn, "regional/webacl/test-waf-setup")

	assert.Contains(t, WebAclAssociationAlbListId, "arn:aws:wafv2:eu-west-1")
	assert.Contains(t, WebAclAssociationAlbListId, "regional/webacl/test-waf-setup")
	assert.Contains(t, WebAclAssociationAlbListResourceArn, "arn:aws:elasticloadbalancing:eu-west-1")
	assert.Contains(t, WebAclAssociationAlbListResourceArn, "loadbalancer/app/alb-waf-example")
	assert.Contains(t, WebAclAssociationAlbListAclArn, "arn:aws:wafv2:eu-west-1:")
	assert.Contains(t, WebAclAssociationAlbListAclArn, "regional/webacl/test-waf-setup")

	assert.Contains(t, KinesisStreamArn, "arn:aws:firehose:eu-west-1")
	assert.Contains(t, KinesisStreamArn, "deliverystream/aws-waf-logs-kinesis-firehose-test-stream")

	assert.Contains(t, IamRoleArn, "arn:aws:iam::")
	assert.Contains(t, IamRoleArn, "role/firehose-stream-test-role")
	assert.Equal(t, IamRoleId, "firehose-stream-test-role")
	assert.Equal(t, IamRoleName, "firehose-stream-test-role")

	assert.Equal(t, IamRolePolicyId, "firehose-stream-test-role:firehose-role-custom-policy")
	assert.Equal(t, IamRolePolicyName, "firehose-role-custom-policy")
	assert.Equal(t, IamRolePolicyRole, "firehose-stream-test-role")

	assert.Equal(t, S3BucketArn, "arn:aws:s3:::aws-waf-firehose-stream-test-bucket")
	assert.Equal(t, S3BucketId, "aws-waf-firehose-stream-test-bucket")
}
